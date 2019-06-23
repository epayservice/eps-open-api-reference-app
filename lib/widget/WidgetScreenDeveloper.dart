import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationPin.dart';
import 'package:eps_open_api_reference_app/repository/SecureStorage.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppRoute.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformPageRoute.dart';
import 'package:eps_open_api_reference_app/widget/ui/WidgetTitleTextImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'WidgetScreenAuthorizationPin.dart';

class WidgetScreenDeveloper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetScreen(
      isScrollViewEnabled: true,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            WidgetTitleTextImage.build(
              "Developer!",
              "Welcome to Open API demonstration application. To continue please login with your ePayService account’s credentials.",
              AppAssetPath.getDevelop(),
            ),
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: ButtonStadium(
                text: "Next",
                onPressed: () => _onPressedButtonNext(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedButtonNext(BuildContext context) {
    SecureStorage.getInstance().then((storage) {
      storage.getPin().then((pin) {
        if (pin != null) {
          Navigator.pushReplacement(
            context,
            PlatformPageRoute.build(
              builder: (context) => WidgetScreenAuthorizationPin(
                  useCase: UseCasePin.enter,
                  onSuccessCallback: () {
                    Navigator.of(context).pushReplacementNamed(AppRoute.screen_authorization_providers);
                  }),
            ),
          );
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoute.screen_authorization_password);
        }
      });
    });
  }
}
