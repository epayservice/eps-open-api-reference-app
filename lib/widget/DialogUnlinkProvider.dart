import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationProviders.dart';
import 'package:eps_open_api_reference_app/entity/EpayserviceOauthData.dart';
import 'package:eps_open_api_reference_app/repository/SecureStorage.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppRoute.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformStatelessWidget.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class DialogUnlinkProvider extends PlatformStatelessWidget {
  static const String text = "You are going to unlink the “ePayService” account provider from this application. Are you sure?";
  static const TextStyle textStyle = TextStyle(fontSize: 18);
  static const Color backgroundColor = AppColor.white;
  static const EdgeInsetsGeometry padding = EdgeInsets.all(30);

  DialogUnlinkProvider() : super(platform: PlatformSelector.autodetect);

  @override
  Widget onBuildAndroidWidget(BuildContext context) {
    return material.AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      content: Text(
        text,
        style: textStyle,
      ),
      backgroundColor: backgroundColor,
      contentPadding: padding,
      actions: <Widget>[
        ButtonStadium(
          platform: PlatformSelector.android,
          text: "Unlink",
          colorEnabled: false,
          stretchHorizontally: false,
          onPressed: () {
            _onPressedButtonUnlink(context);
          },
          textColor: AppColor.red,
        )
      ],
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
          text: "Cancel",
          colorEnabled: false,
          stretchHorizontally: false,
          onPressed: () => _onPressedButtonCancel(context),
          textColor: AppColor.blueOnWhite,
        ),
        ButtonStadium(
          platform: PlatformSelector.ios,
          text: "Unlink",
          colorEnabled: false,
          stretchHorizontally: false,
          onPressed: () => _onPressedButtonUnlink(context),
          textColor: AppColor.red,
        )
      ],
    );
  }

  void _onPressedButtonUnlink(BuildContext context) {
    final Bloc<BlocAuthProviders> bloc = BlocStorage.storage.get(BlocAuthProviders);
    if (bloc != null) {
      SecureStorage.getInstance().then((storage) {
        storage.setEpayserviceOauthData(EpayserviceOauthData());
        bloc.enqueueAction(BlocActionSetOauth(EpayserviceOauthData()));
        Navigator.of(context).pushReplacementNamed(AppRoute.screen_authorization_providers);
      });
    }
  }

  void _onPressedButtonCancel(BuildContext context) {
    Navigator.of(context).pop();
  }
}
