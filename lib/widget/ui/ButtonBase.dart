import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformButton.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/SpinProgressIndicator.dart';
import 'package:flutter/widgets.dart';

class ButtonBase extends PlatformButton {
  ButtonBase({
    Key key,
    PlatformSelector platform,
    VoidCallback onPressed,
    bool colorEnabled = true,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
    Widget childLeft,
    String text,
    Color textColor,
    TextStyle textStyle,
    Widget childRight,
    ShapeBorder shapeBorder = const StadiumBorder(),
    bool progressIndicatorEnabled = false,
    bool stretchHorizontally = true,
  }) : super(
          key: key,
          platform: platform,
          onPressed: onPressed,
          color: colorEnabled ? AppColor.blue : AppColor.transparent,
          padding: padding,
          child: _onBuildChild(childLeft, text, textColor, textStyle, childRight, progressIndicatorEnabled, stretchHorizontally) ?? Container(),
          disabledColor: colorEnabled ? AppColor.blue20 : AppColor.transparent,
          shapeBorder: shapeBorder,
        );

  static Widget _onBuildChild(
    Widget childLeft,
    String text,
    Color textColor,
    TextStyle textStyle,
    Widget childRight,
    bool progressIndicatorEnabled,
    bool stretchHorizontally,
  ) {
    Widget widget;

    if (progressIndicatorEnabled) {
      widget = SpinProgressIndicator(
        materialBuilder: (context) => MaterialSpinProgressIndicatorData(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.white),
              backgroundColor: AppColor.transparent,
              strokeWidth: 4.0,
            ),
      );
    } else if (text != null) {
      widget = Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: _getTextStyle(textStyle, textColor),
      );
    }

    if (childLeft != null || childRight != null) {
      widget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (childLeft != null) childLeft,
          if (widget != null) widget,
          if (childRight != null) childRight,
        ],
      );
    }

    if (stretchHorizontally != false) {
      widget = SizedBox(
        width: double.maxFinite,
        height: 22,
        child: widget,
      );
    }

    return widget;
  }

  static TextStyle _getTextStyle(TextStyle textStyle, Color textColor) {
    final defaultTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      color: textColor ?? AppColor.white,
    );

    if (textStyle != null) {
      return defaultTextStyle.merge(textStyle);
    } else {
      return defaultTextStyle;
    }
  }
}
