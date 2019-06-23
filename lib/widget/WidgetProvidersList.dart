import 'dart:io';

import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationProviders.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppRoute.dart';
import 'package:eps_open_api_reference_app/utils/AppSnackBar.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:eps_open_api_reference_app/widget/DialogUnlinkProvider.dart';
import 'package:eps_open_api_reference_app/widget/ui/SpinProgressIndicator.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetProvidersList extends StatelessWidget {
  final Bloc<BlocAuthProviders> bloc;

  WidgetProvidersList() : bloc = BlocStorage.storage.get(BlocAuthProviders);

  @override
  Widget build(BuildContext context) {
    return BlocWidgetObserver(
      bloc: bloc,
      onBuild: (context, state, _) {
        return _onBuildContent(context, state);
      },
      onEvent: _onEvent,
      onError: _onError,
    );
  }

  Widget _onBuildContent(BuildContext context, BlocAuthProviders state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: SizedBox(
              height: 35,
              child: SvgPicture.asset(
                AppAssetPath.getEpayserviceLogo(),
                alignment: Alignment.centerLeft,
                color: AppColor.black,
                fit: BoxFit.contain,
                placeholderBuilder: (context) {
                  return SizedBox(child: SpinProgressIndicator());
                },
              ),
            ),
          ),
        ),
        material.Switch.adaptive(
          value: state.epayserviceOauth.isTokenValid(),
          onChanged: (isEnabled) => _onSwitchEpayserviceChanged(context, isEnabled),
        )
      ],
    );
  }

  void _onSwitchEpayserviceChanged(BuildContext context, bool isEnabled) {
    if (isEnabled) {
      bloc.enqueueEvent(BlocEventGoToAuthorizationEpayserviceOauth());
    } else {
      if (Platform.isAndroid) {
        material.showDialog(
          context: context,
          builder: (context) {
            return DialogUnlinkProvider();
          },
        );
      } else if (Platform.isIOS) {
        cupertino.showCupertinoDialog(
          context: context,
          builder: (context) {
            return DialogUnlinkProvider();
          },
        );
      }
    }
  }

  void _onEvent(BuildContext context, BlocEvent event, Bloc<BlocState> bloc) {
    if (event is BlocEventGoToAuthorizationEpayserviceOauth) {
      Navigator.of(context).pushNamed(AppRoute.screen_authorization_oauth_epayservices).then((result) {
        bloc.enqueueAction(BlocActionUpdateState());
      }).whenComplete(() {
        bloc.enqueueAction(BlocActionUpdateState());
      });
    }
  }

  void _onError(BuildContext context, Object error, Bloc<BlocState> bloc) {
    if (error is ErrorString) {
      final snackBar = AppSnackBar.get(text: error.text);
      material.Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
