import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformStatelessWidget.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class DialogSuccess extends PlatformStatelessWidget {
  static const String text = "Success";
  static const TextStyle textStyle = TextStyle(fontSize: 18);
  static const Color backgroundColor = AppColor.white;
  static const EdgeInsetsGeometry padding = EdgeInsets.all(30);

  DialogSuccess() : super(platform: PlatformSelector.autodetect);

  @override
  Widget onBuildAndroidWidget(BuildContext context) {
    return material.AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      content: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: backgroundColor,
      contentPadding: padding,
    );
  }

  @override
  Widget onBuildIOSWidget(BuildContext context) {
    return cupertino.CupertinoAlertDialog(
      content: Text(
        text,
        style: textStyle,
      ),
      actions: <Widget>[
        ButtonStadium(
          platform: PlatformSelector.ios,
          text: "Close",
          colorEnabled: false,
          stretchHorizontally: false,
          onPressed: () => _onPressedButtonCancel(context),
          textColor: AppColor.blueOnWhite,
        )
      ],
    );
  }

  void _onPressedButtonCancel(BuildContext context) {
    Navigator.of(context).pop();
  }
}
