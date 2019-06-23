import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenDashboard.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenSettings.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenWithSafeArea.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonCircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class WidgetScreenDashboardBottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<WidgetScreenDashboardBottomBar> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: _onBuildScreen(),
        ),
        WidgetScreenWithSafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _onBuildBottomBar(),
          ),
        ),
      ],
    );
  }

  Widget _onBuildScreen() {
    if (index == 1) {
      return WidgetScreenDashboard();
    } else if (index == 2) {
      return WidgetScreenSettings();
    } else {
      return null;
    }
  }

  Widget _onBuildBottomBar() {
    return SizedBox(
      height: 90,
      child: Container(
        color: AppColor.greyE5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ButtonCircle(
              childLeft: SvgPicture.asset(
                AppAssetPath.getWalletSvg(),
                color: index == 1 ? AppColor.blue : AppColor.blueOnWhite,
              ),
              colorEnabled: false,
              onPressed: _onPressedButtonDashboard,
            ),
            ButtonCircle(
              childLeft: SvgPicture.asset(
                AppAssetPath.getUserSettingsSvg(),
                color: index == 2 ? AppColor.blue : AppColor.blueOnWhite,
              ),
              colorEnabled: false,
              onPressed: _onPressedButtonUserSettings,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedButtonDashboard() {
    setState(() {
      index = 1;
    });
  }

  void _onPressedButtonUserSettings() {
    setState(() {
      index = 2;
    });
  }
}
