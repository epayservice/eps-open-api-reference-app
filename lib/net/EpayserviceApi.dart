import 'dart:async';
import 'dart:convert';

import 'package:eps_open_api_reference_app/database/DatabaseAccountsProvider.dart';
import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/entity/Card.dart';
import 'package:eps_open_api_reference_app/entity/EpayserviceOauthData.dart';
import 'package:eps_open_api_reference_app/repository/OAuthKeys.dart';
import 'package:eps_open_api_reference_app/repository/SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class EpayserviceApi {
  static const scheme = "https";
  static const host = "online.epayservices.com";
  static const path = "open_api";
  static const responseType = "code";
  static const scope = "read+openid+email+p2p_out";

  static Uri getUri({String path, Map<String, dynamic> queryParameters}) {
    return Uri(
      scheme: EpayserviceApi.scheme,
      host: EpayserviceApi.host,
      path: EpayserviceApi.path + '/' + path,
      queryParameters: queryParameters,
    );
  }

  Future<void> getAccessToken({String authorizationCode, String refreshToken}) async {
    final completer = Completer();

    final url = getUri(path: "oauth/token").toString();

    final headers = {
      "Accept": "application/json",
    };

    Map<String, String> body = {
      "client_id": OAuthKeys().clientId,
      "client_secret": OAuthKeys().clientSecret,
      "redirect_uri": OAuthKeys().redirectUri,
    };

    if (authorizationCode != null) {
      body["grant_type"] = "authorization_code";
      body["code"] = authorizationCode;
    } else if (refreshToken != null) {
      body["grant_type"] = "refresh_token";
      body["refresh_token"] = refreshToken;
    }

print (body);

    Request.post(
      url: url,
      headers: headers,
      body: body,
    ).then((response) {
      final Map<String, dynamic> map = jsonDecode(response.body);

      if (map['access_token'] == null || map['refresh_token'] == null || map["created_at"] == null || map['expires_in'] == null) {
        completer.completeError(UndefinedErrorServerException());
      }

      final oauth = EpayserviceOauthData(
        tokenAccess: map['access_token'],
        tokenRefresh: map['refresh_token'],
        timestampCreatedAt: map["created_at"],
        timestampExpiresIn: map['expires_in'],
      );

      SecureStorage.getInstance().then((storage) {
        storage.setEpayserviceOauthData(oauth).then((result) {
          completer.complete();
        }).catchError((error) {
          completer.completeError(UndefinedErrorServerException());
        });
      });
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  void getAccounts() async {
    final storage = await SecureStorage.getInstance();
    final token = await storage.getEpayserviceTokenAccess();

    final url = getUri(path: "accounts").toString();

    final Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };

    final response = await Request.get(
      url: url,
      headers: headers,
    );

    final accounts = List<Account>();

    final result = jsonDecode(response.body);
    if (result is List) {
      for (final accountItem in result) {
        if (accountItem is Map<String, dynamic>) {
          Card card;

          if (accountItem.containsKey("epscard")) {
            final Map<String, dynamic> cardItem = accountItem["epscard"];

            card = Card(
              id: cardItem["id"],
              status: CardStatusConverter.cardStatus(cardItem["status"]),
              currency: cardItem["currency"],
              expiredYear: cardItem["exp_y"],
              expiredMonth: cardItem["exp_m"],
              maskedNumber: cardItem["masked_number"],
              isVirtual: cardItem["is_virtual"],
              isReloadable: cardItem["is_reloadable"],
            );
          }

          final account = Account(
            id: accountItem["id"],
            type: accountItem["type"],
            balance: accountItem["balance"],
            name: accountItem["name"],
            number: accountItem["number"],
            currency: accountItem["currency"],
            currencyLabel: accountItem["currency_label"],
            favorite: accountItem["favorite"],
            paymentProviderCode: accountItem["payment_provider_code"],
            card: card,
          );

          accounts.add(account);
        }
      }
    }

    DatabaseAccountsProvider().deleteAll().then((result) {
      DatabaseAccountsProvider().saveAll(accounts);
    });
  }

  Future<dynamic> getAccountHistory(String accountId) async {
    String url = getUri(path: "account_history", queryParameters: {"account_id": accountId}).toString();

    final storage = await SecureStorage.getInstance();
    String token = await storage.getEpayserviceTokenAccess();

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };

    final response = await Request.get(url: url, headers: headers);
    return jsonDecode(response.body);
  }

  Future<Map<String, String>> getP2PFee(Account account, String amount) async {
    final completer = Completer<Map<String, String>>();

    final storage = await SecureStorage.getInstance();
    String token = await storage.getEpayserviceTokenAccess();

    Map<String, String> params = {
      "account_id": account.id.toString(),
      "amount": amount,
      "receiver_account_number": account.number,
    };

    String url = getUri(path: "out/p2ps/fee", queryParameters: params).toString();
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };

    Request.get(url: url, headers: headers).then((response) {
      Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, String> result = Map();

      if (map.containsKey("amount")) {
        final Map<String, dynamic> mapAmount = map["amount"];
        if (mapAmount != null) {
          if (mapAmount.containsKey("value")) {
            result["amount_value"] = mapAmount["value"];
          }
          if (mapAmount.containsKey("currency")) {
            result["amount_currency"] = mapAmount["currency"];
          }
        }
      }

      if (map.containsKey("fee")) {
        final Map<String, dynamic> mapAmount = map["fee"];
        if (mapAmount != null) {
          if (mapAmount.containsKey("value")) {
            result["fee_value"] = mapAmount["value"];
          }
          if (mapAmount.containsKey("currency")) {
            result["fee_currency"] = mapAmount["currency"];
          }
        }
      }

      if (map.containsKey("smsFee")) {
        final Map<String, dynamic> mapAmount = map["smsFee"];
        if (mapAmount != null) {
          if (mapAmount.containsKey("value")) {
            result["fee_sms_value"] = mapAmount["value"];
          }
          if (mapAmount.containsKey("currency")) {
            result["fee_sms_currency"] = mapAmount["currency"];
          }
        }
      }

      if (map.containsKey("total")) {
        final Map<String, dynamic> mapAmount = map["total"];
        if (mapAmount != null) {
          if (mapAmount.containsKey("value")) {
            result["total_value"] = mapAmount["value"];
          }
          if (mapAmount.containsKey("currency")) {
            result["total_currency"] = mapAmount["currency"];
          }
        }
      }

      completer.complete(result);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<dynamic> postP2POut(Map<String, String> params) async {
    final storage = await SecureStorage.getInstance();
    String token = await storage.getEpayserviceTokenAccess();

    params["protection_code"] = "";
    params["protection_days"] = "1";

    String url = getUri(path: "out/p2ps").toString();
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };

    return http.post(url, headers: headers, body: params).then((response) {
      ResponseErrorHandler.process(response: response);
      final responseJson = jsonDecode(response.body);
      return responseJson;
    }).catchError((error) {
      throw (error);
    });
  }
}

class Request {
  static Future<http.Response> get({
    @required String url,
    @required Map<String, String> headers,
  }) {
    return http.get(url, headers: headers).then((response) {
      try {
        ResponseErrorHandler.process(response: response);
        return response;
      } catch (error) {
        return error;
      }
    }, onError: (error) {
      return error;
    });
  }

  static Future<http.Response> post({
    @required String url,
    @required Map<String, String> headers,
    @required Map<String, String> body,
  }) {
    return http.post(url, headers: headers, body: body).then((response) {
      try {
        ResponseErrorHandler.process(response: response);
        return response;
      } catch (error) {
        return error;
      }
    }, onError: (error) {
      return error;
    });
  }
}

class ResponseErrorHandler {
  static void process({@required http.Response response}) {
    if (response.statusCode < 200 || response.statusCode > 205) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      if (result.containsKey("error")) {
        throw ServerException(
          code: response.statusCode,
          message: result["error"],
        );
      } else {
        throw UndefinedErrorServerException();
      }
    }
  }
}

class ServerException {
  String message;
  int code;

  ServerException({
    this.message,
    this.code,
  });
}

class UndefinedErrorServerException extends ServerException {
  UndefinedErrorServerException() : super(code: -1);
}
