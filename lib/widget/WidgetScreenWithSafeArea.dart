import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetScreenWithSafeArea extends StatelessWidget {
  final Widget _child;

  WidgetScreenWithSafeArea({@required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _child ?? Container(),
      bottom: false,
    );
  }
}
