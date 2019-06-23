import 'package:eps_open_api_reference_app/widget/ui/ButtonBase.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:flutter/widgets.dart';

class ButtonStadium extends ButtonBase {
  ButtonStadium({
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
    bool progressIndicatorEnabled = false,
    bool stretchHorizontally = true,
  }) : super(
          key: key,
          platform: platform,
          onPressed: onPressed,
          colorEnabled: colorEnabled,
          childLeft: childLeft,
          text: text,
          textColor: textColor,
          textStyle: textStyle,
          childRight: childRight,
          progressIndicatorEnabled: progressIndicatorEnabled,
          stretchHorizontally: stretchHorizontally,
          padding: padding,
          shapeBorder: const StadiumBorder(),
        );
}
