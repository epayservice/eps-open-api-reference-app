import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenWithBackground.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenWithLogo.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenWithScaffold.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenWithScroll.dart';
import 'package:flutter/widgets.dart';

class WidgetScreen extends StatelessWidget {
  final bool _isScaffoldEnabled;
  final bool _isSafeAreaEnabled;
  final bool _isBackgroundEnabled;
  final bool _isScrollEnabled;
  final bool _isLogoEnabled;
  final Widget _child;

  WidgetScreen({
    @required Widget child,
    bool isScaffoldEnabled = true,
    bool isSafeAreaEnabled = true,
    bool isBackgroundEnabled = true,
    bool isScrollViewEnabled = true,
    bool isLogoEnabled = true,
  })  : _child = child,
        _isScaffoldEnabled = isScaffoldEnabled,
        _isSafeAreaEnabled = isSafeAreaEnabled,
        _isBackgroundEnabled = isBackgroundEnabled,
        _isScrollEnabled = isScrollViewEnabled,
        _isLogoEnabled = isLogoEnabled;

  @override
  Widget build(BuildContext context) {
    Widget widget = _child;

    assert(_child != null);

    if (_isLogoEnabled) {
      widget = WidgetScreenWithLogo(
        child: widget,
        color: AppColor.white,
      );
    }

    if (_isScrollEnabled) {
      widget = WidgetScreenWithScroll(child: widget);
    }

    if (_isSafeAreaEnabled) {
      widget = SafeArea(child: widget, bottom: false);
    }

    if (_isScaffoldEnabled) {
      widget = WidgetScreenWithScaffold(child: widget);
    }

    if (_isBackgroundEnabled) {
      widget = WidgetScreenWithBackground(child: widget);
    } else {
      widget = Container(
        color: AppColor.white,
        child: widget,
      );
    }

    return widget;
  }
}
