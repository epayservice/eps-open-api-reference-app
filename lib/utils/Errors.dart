import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:eps_open_api_reference_app/utils/AppSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorHandler {
  static void process({BuildContext context, Object error, void Function({BuildContext context, Object error}) onUndefinedError}) {
    if (error is ErrorString) {
      _showSnackBar(context: context, text: error.text);
    } else if (error is ServerException) {
      _showSnackBar(context: context, text: error.message);
    } else if (error is PlatformException) {
      _showSnackBar(context: context, text: error.message);
    } else {
      onUndefinedError(context: context, error: error);
    }
  }

  static void _showSnackBar({BuildContext context, String text}) {
    final snackBar = AppSnackBar.get(text: text);
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

class ErrorString {
  final String text;

  ErrorString(this.text);
}

class ErrorStringUndefined extends ErrorString {
  ErrorStringUndefined() : super("Что-то пошло не так");
}
