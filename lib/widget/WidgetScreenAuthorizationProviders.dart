import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationProviders.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppRoute.dart';
import 'package:eps_open_api_reference_app/utils/AppSnackBar.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:eps_open_api_reference_app/widget/WidgetProvidersList.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/WidgetTitleTextImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class WidgetScreenAuthorizationProviders extends StatelessWidget {
  Widget build(BuildContext context) {
    return WidgetScreen(
      child: Builder(
        builder: (context) {
          final screenHeight = MediaQuery.of(context).size.height;
          return new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: new EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: WidgetTitleTextImage.build(
                  "Choose Account Provider",
                  "Please, choose the Account Provider system for the authorization.",
                  AppAssetPath.getPiggyBank(),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                ),
                padding: new EdgeInsets.symmetric(vertical: 25.0),
                child: _WidgetSupportedProviders(),
              )
            ],
          );
        },
      ),
    );
  }
}

class _WidgetSupportedProviders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetSupportedProvidersState();
  }
}

class _WidgetSupportedProvidersState extends State<_WidgetSupportedProviders> {
  Bloc<BlocAuthProviders> bloc;

  _WidgetSupportedProvidersState() : bloc = BlocStorage.storage.getOrCreate<BlocAuthProviders>(BlocAuthProviders());

  @override
  void initState() {
    super.initState();
    bloc.enqueueAction(BlocActionUpdateState());
  }

  @override
  void dispose() {
    super.dispose();
    BlocStorage.storage.destroy(bloc);
    bloc = null;
  }

  Widget build(BuildContext context) {
    return BlocWidgetObserver(
      bloc: bloc,
      onBuild: (context, state, bloc) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Supported Providers",
                style: AppTextStyle.getTextHeader3(color: AppColor.blueOnWhite),
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: WidgetProvidersList(),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ButtonStadium(
                text: "CONTINUE",
                onPressed: bloc.state.epayserviceOauth.isTokenValid() ? () => _onPressedButtonContinue(context) : null,
              ),
            )
          ],
        );
      },
      onEvent: _onEvent,
      onError: _onError,
    );
  }

  void _onPressedButtonContinue(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoute.screen_dashboard);
  }

  void _onEvent(BuildContext context, BlocEvent event, Bloc<BlocState> bloc) {}

  void _onError(BuildContext context, Object error, Bloc<BlocState> bloc) {
    if (error is ErrorString) {
      final snackBar = AppSnackBar.get(text: error.text);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
