import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class WidgetScreenWithScaffold extends StatelessWidget {
  final Widget child;
  final Widget bottomNavigationBar;

  WidgetScreenWithScaffold({
    @required this.child,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    //    if (Platform.isAndroid) {
    return material.Scaffold(
      body: child ?? Container(),
      backgroundColor: AppColor.transparent,
      bottomNavigationBar: bottomNavigationBar,
    );
    //    } else if (Platform.isIOS) {
    //      return cupertino.CupertinoPageScaffold(
    //        child: child ?? Container(),
    //        backgroundColor: AppColor.transparent,
    //      );
    //    } else {
    //      return Container(child: child);
    //    }
  }
}
