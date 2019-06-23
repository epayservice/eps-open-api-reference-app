import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationProviders.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/widget/WidgetProvidersList.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class WidgetScreenSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<WidgetScreenSettings> {
  Bloc<BlocAuthProviders> bloc;

  _State() : bloc = BlocStorage.storage.create<BlocAuthProviders>(BlocAuthProviders());

  @override
  void initState() {
    super.initState();
    bloc.enqueueAction(BlocActionUpdateState());
  }

  @override
  void dispose() {
    BlocStorage.storage.destroy(bloc);
    bloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScreen(
      isSafeAreaEnabled: true,
      isScaffoldEnabled: true,
      isBackgroundEnabled: false,
      isLogoEnabled: false,
      isScrollViewEnabled: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Settings",
                  style: AppTextStyle.getTextHeader1().merge(TextStyle(color: AppColor.blueOnWhite, fontWeight: FontWeight.w700)),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Authorized providers",
                  style: AppTextStyle.getTextHeader3().merge(TextStyle(color: AppColor.blueOnWhite, fontWeight: FontWeight.w400)),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: WidgetProvidersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
