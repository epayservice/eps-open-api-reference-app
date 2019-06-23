import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static SnackBar get({@required String text, Duration duration = const Duration(seconds: 2), Color backgroundColor = AppColor.blue50}) {
    return SnackBar(
      content: Text(text),
      backgroundColor: backgroundColor,
      duration: duration,
    );
  }
}
