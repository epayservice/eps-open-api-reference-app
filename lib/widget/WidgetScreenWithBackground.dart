import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetScreenWithBackground extends StatelessWidget {
  final Widget _child;

  WidgetScreenWithBackground({@required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    var widgetList = new List<Widget>();

    widgetList.add(
      Image.asset(
        AppAssetPath.getScreenBackground(),
        fit: BoxFit.cover,
        alignment: Alignment.topLeft,
        color: AppColor.black60,
        colorBlendMode: BlendMode.srcOver,
      ),
    );

    if (_child != null) {
      widgetList.add(_child);
    }

    return Stack(
      fit: StackFit.expand,
      children: widgetList,
    );
  }
}
