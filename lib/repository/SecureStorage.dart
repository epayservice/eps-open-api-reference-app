import 'package:eps_open_api_reference_app/entity/EpayserviceOauthData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static SecureStorage _sInstance;

  static const String AUTHENTICATION_PIN = "AUTHENTICATION_PIN";
  static const String AUTHENTICATION_EPAYSERVICE_TOKEN_ACCESS = "AUTHENTICATION_EPAYSERVICE_TOKEN_ACCESS";
  static const String AUTHENTICATION_EPAYSERVICE_TOKEN_REFRESH = "AUTHENTICATION_EPAYSERVICE_TOKEN_REFRESH";
  static const String AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_EXPIRES_IN = "AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_EXPIRES_IN";
  static const String AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_CREATED_AT = "AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_CREATED_AT";

  static const String _FIRST_RUN_FLAG = "FIRST_RUN_FLAG";

  FlutterSecureStorage _storage;

  static Future<SecureStorage> getInstance() async {
    if (_sInstance == null) {
      _sInstance = SecureStorage._internal();
      final prefs = await SharedPreferences.getInstance();
      final isFirstRun = prefs.getBool(_FIRST_RUN_FLAG);
      if (isFirstRun == null) {
        await _sInstance.clear();
        await FirebaseAuth.instance.signOut();
        prefs.setBool(_FIRST_RUN_FLAG, true);
      }
    }
    return _sInstance;
  }

  SecureStorage._internal() : _storage = new FlutterSecureStorage();

  Future<void> clear() {
    return _storage.deleteAll();
  }

  Future<void> setPin(String pin) {
    return _storage.write(key: AUTHENTICATION_PIN, value: pin);
  }

  Future<String> getPin() {
    return _storage.read(key: SecureStorage.AUTHENTICATION_PIN);
  }

  Future<void> setEpayserviceTokenAccess(String token) {
    return _storage.write(key: AUTHENTICATION_EPAYSERVICE_TOKEN_ACCESS, value: token);
  }

  Future<String> getEpayserviceTokenAccess() {
    return _storage.read(key: SecureStorage.AUTHENTICATION_EPAYSERVICE_TOKEN_ACCESS);
  }

  Future<void> setEpayserviceTokenRefresh(String token) {
    return _storage.write(key: AUTHENTICATION_EPAYSERVICE_TOKEN_REFRESH, value: token);
  }

  Future<String> getEpayserviceTokenRefresh() {
    return _storage.read(key: SecureStorage.AUTHENTICATION_EPAYSERVICE_TOKEN_REFRESH);
  }

  Future<void> setEpayserviceTimestampTokenCreatedAt(int timestamp) {
    final String string = timestamp.toString();
    return _storage.write(key: AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_CREATED_AT, value: string);
  }

  Future<int> getEpayserviceTimestampTokenCreatedAt() async {
    final string = await _storage.read(key: SecureStorage.AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_CREATED_AT);
    if (string != null && string != "null") {
      final int value = int.parse(string);
      return value;
    } else {
      return -1;
    }
  }

  Future<void> setEpayserviceTimestampTokenExpiresIn(int timestamp) {
    final String string = timestamp.toString();
    return _storage.write(key: AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_EXPIRES_IN, value: string);
  }

  Future<int> getEpayserviceTimestampTokenExpiresIn() async {
    final string = await _storage.read(key: SecureStorage.AUTHENTICATION_EPAYSERVICE_TIME_TOKEN_EXPIRES_IN);
    if (string != null && string != "null") {
      final int value = int.parse(string);
      return value;
    } else {
      return -1;
    }
  }

  Future<void> setEpayserviceOauthData(EpayserviceOauthData data) async {
    return Future.wait({
      setEpayserviceTokenAccess(data.tokenAccess),
      setEpayserviceTokenRefresh(data.tokenRefresh),
      setEpayserviceTimestampTokenCreatedAt(data.timestampCreatedAt),
      setEpayserviceTimestampTokenExpiresIn(data.timestampExpiresIn),
    });
  }

  Future<EpayserviceOauthData> getEpayserviceOauthData() async {
    final String tokenAccess = await getEpayserviceTokenAccess();
    final String tokenRefresh = await getEpayserviceTokenRefresh();
    final int createdAt = await getEpayserviceTimestampTokenCreatedAt();
    final int expiresIn = await getEpayserviceTimestampTokenExpiresIn();

    return EpayserviceOauthData(
      tokenAccess: tokenAccess,
      tokenRefresh: tokenRefresh,
      timestampCreatedAt: createdAt,
      timestampExpiresIn: expiresIn,
    );
  }
}
