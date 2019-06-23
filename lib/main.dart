import 'dart:io';

import 'package:eps_open_api_reference_app/bloc/BlocAccounts.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccountsActive.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccountsFavorites.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccountsTotalBalances.dart';
import 'package:eps_open_api_reference_app/repository/EnvVarHolder.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppRoute.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenAuthorizationOauthEpayservice.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenAuthorizationPassword.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenAuthorizationProviders.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenDashboardBottomBar.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenDeveloper.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformPageRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'database/Database.dart';

void main() async {
  //  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  setupApplication();
  runApp(WidgetApplication());
}

void setupApplication(){
  BlocStorage.initialize();
  Database().remove();
  Database().initializeDB((result) {});
}

class WidgetApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (Platform.isAndroid) {
      widget = MaterialApp(
        initialRoute: AppRoute.screen_developer,
        title: 'ePayService Open API Example',
        theme: ThemeData(
          accentColor: AppColor.blue,
          highlightColor: AppColor.blue,
          errorColor: AppColor.red,
          canvasColor: Colors.transparent,
        ),
        onGenerateRoute: _onGenerateRoute,
        debugShowMaterialGrid: false,
        showSemanticsDebugger: false,
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      widget = CupertinoApp(
        initialRoute: AppRoute.screen_developer,
        title: 'ePayService Open API Example',
        theme: CupertinoThemeData(
          primaryColor: AppColor.blue,
        ),
        onGenerateRoute: _onGenerateRoute,
        showSemanticsDebugger: false,
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
      );
    }

    return _WidgetBlocProvider(widget);
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    return PlatformPageRoute.build(builder: (context) {
      switch (settings.name) {
        case AppRoute.screen_authorization_password:
          return WidgetScreenAuthorizationPassword();
        case AppRoute.screen_authorization_providers:
          return WidgetScreenAuthorizationProviders();
        case AppRoute.screen_authorization_oauth_epayservices:
          return WidgetScreenAuthorizationOauthEpayservice();
        case AppRoute.screen_dashboard:
          return WidgetScreenDashboardBottomBar();
        case "/":
        case AppRoute.screen_developer:
        default:
          return WidgetScreenDeveloper();
      }
    });
  }
}

class _WidgetBlocProvider extends StatefulWidget {
  final Widget child;

  _WidgetBlocProvider(this.child);

  @override
  State<StatefulWidget> createState() {
    return _WidgetBlocProviderState();
  }
}

class _WidgetBlocProviderState extends State<_WidgetBlocProvider> {
  final Bloc<BlocStateAccounts> blocAccounts;
  final Bloc<BlocStateAccountsActive> blocAccountsActive;
  final Bloc<BlocStateAccountsFavorites> blocAccountsFavorites;
  final Bloc<BlocStateAccountsTotalBalances> blocAccountsTotalBalances;
  final BlocObserver<BlocStateAccounts> observer;

  _WidgetBlocProviderState()
      : blocAccounts = BlocInstance.storage.getOrCreate(BlocStateAccounts()),
        blocAccountsActive = BlocInstance.storage.getOrCreate(BlocStateAccountsActive()),
        blocAccountsFavorites = BlocInstance.storage.getOrCreate(BlocStateAccountsFavorites()),
        blocAccountsTotalBalances = BlocInstance.storage.getOrCreate(BlocStateAccountsTotalBalances()),
        observer = BlocObserver<BlocStateAccounts>();

  @override
  void initState() {
    super.initState();
    observer.subscribe(
      bloc: blocAccounts,
      onStateChanged: (state, bloc) {
        blocAccountsActive.enqueueAction(BlocActionAccountsActiveUpdate(state.accounts));
        blocAccountsFavorites.enqueueAction(BlocActionAccountsFavoritesUpdate(state.accounts));
        blocAccountsTotalBalances.enqueueAction(BlocActionAccountsTotalBalancesUpdate(state.accounts));
      },
    );
  }

  @override
  void dispose() {
    observer.unsubscribe();
    blocAccounts.dispose();
    blocAccountsActive.dispose();
    blocAccountsFavorites.dispose();
    blocAccountsTotalBalances.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
