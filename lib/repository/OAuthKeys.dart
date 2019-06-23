import 'dart:io';

import 'package:eps_open_api_reference_app/repository/EnvVarHolder.dart';

class OAuthKeys {
  static final OAuthKeys _instance = new OAuthKeys._internal();

   final clientId ;
   final clientSecret;
   final redirectUri;

  factory OAuthKeys() {
    return _instance;
  }

  OAuthKeys._internal():
    this.clientId     = EnvVarHolder().env["EPS_DEMO_CLIENT_ID"],
    this.clientSecret = EnvVarHolder().env["EPS_DEMO_CLIENT_ID_SECRET"],
    this.redirectUri  = "epayserviceApp://epyservice_openbanking.com";

}