import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformStatelessWidget.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class MaterialButtonData {
  MaterialButtonData();
}

class CupertinoButtonData {
  CupertinoButtonData();
}

class PlatformButton extends PlatformStatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Color disabledColor;
  final ShapeBorder shapeBorder;

  PlatformButton({
    Key key,
    PlatformSelector platform,
    this.onPressed,
    this.color,
    this.padding,
    this.child,
    this.disabledColor,
    this.shapeBorder,
  }) : super(
          key: key,
          platform: platform,
        );

  @override
  Widget onBuildAndroidWidget(BuildContext context) {
    return material.ButtonTheme(
      minWidth: 0,
      height: 0,
      child: material.FlatButton(
        onPressed: onPressed,
        color: color,
        padding: padding,
        child: child,
        disabledColor: disabledColor,
        shape: shapeBorder,
      ),
    );
  }

  @override
  Widget onBuildIOSWidget(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: shapeBorder,
      ),
      child: cupertino.CupertinoButton(
        onPressed: onPressed,
        color: color,
        padding: padding,
        child: child,
        disabledColor: disabledColor,
        borderRadius: BorderRadius.zero,
        pressedOpacity: 0.7,
      ),
    );
  }
}
