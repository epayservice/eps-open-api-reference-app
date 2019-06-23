import 'dart:async';
import 'dart:io';

import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationProviders.dart';
import 'package:eps_open_api_reference_app/entity/EpayserviceOauthData.dart';
import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:eps_open_api_reference_app/repository/OAuthKeys.dart';
import 'package:eps_open_api_reference_app/repository/SecureStorage.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/ui/SpinProgressIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WidgetScreenAuthorizationOauthEpayservice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetScreenAuthorizationOauthEpayserviceState();
  }
}

class _WidgetScreenAuthorizationOauthEpayserviceState extends State<WidgetScreenAuthorizationOauthEpayservice> {
  FlutterWebviewPlugin _flutterWebViewPlugin;
  StreamSubscription<String> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _flutterWebViewPlugin = FlutterWebviewPlugin();
    _streamSubscription = _flutterWebViewPlugin.onUrlChanged.listen(_onUrlChanged);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uri = EpayserviceApi.getUri(
      path: "oauth/authorize",
      queryParameters: {"client_id": OAuthKeys().clientId, "response_type": "code"},
    );

    final String url = uri.toString() + "&redirect_uri=" + OAuthKeys().redirectUri + "&scope=" + EpayserviceApi.scope;

    return WidgetScreen(
      isScaffoldEnabled: false,
      isScrollViewEnabled: false,
      isBackgroundEnabled: false,
      isLogoEnabled: false,
      child: WebviewScaffold(
        url: url,
        initialChild: Center(
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: AppColor.blue),
            child: SizedBox(
              child: SpinProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _onBuildTopBar() {
    if (Platform.isAndroid) {
      return null;
    } else if (Platform.isIOS) {
      return null;
    } else {
      return null;
    }
  }

  Widget _onBuildMaterialAppBar() {}

  Widget _onBuildCupertinoNavigationBar() {}

  void _onUrlChanged(String url) {
    final uri = Uri.parse(url);

    if (uri.scheme == "epayserviceapp" && uri.host == "epyservice_openbanking.com") {
      final queryParameters = uri.queryParameters;
      if (queryParameters == null) {
        _goBack();
        return;
      }

      if (queryParameters.containsKey("code")) {
        String code = uri.queryParameters["code"];
        if (code != null) {
          _goBack();
          EpayserviceApi().getAccessToken(authorizationCode: code).then((result) {
            final bloc = BlocStorage.storage.get(BlocAuthProviders);
            if (bloc != null) {
              bloc.enqueueAction(BlocActionUpdateState());
            }
          });
        } else {
          // TODO: show error
          _deleteTokenAndGoBack();
        }
      } else if (queryParameters.containsKey("error")) {
        // TODO: show error
        _deleteTokenAndGoBack();
      } else {
        // TODO: show error
        _deleteTokenAndGoBack();
      }
    } else if (uri.host != "online.epayservices.com") {
      // TODO: show error
      _goBack();
    }
  }

  void _deleteTokenAndGoBack() {
    SecureStorage.getInstance().then((storage) {
      return storage.setEpayserviceOauthData(EpayserviceOauthData());
    }).whenComplete(() {
      _goBack();
    });
  }

  void _goBack() {
    _flutterWebViewPlugin.goBack().whenComplete(() {
      Navigator.of(context).pop();
    });
  }
}
