import 'package:decimal/decimal.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccountsActive.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccountsFavorites.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccountsTotalBalances.dart';
import 'package:eps_open_api_reference_app/entity/AccountHistory.dart';
import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:eps_open_api_reference_app/utils/Money.dart';
import 'package:eps_open_api_reference_app/widget/WidgetAccount.dart';
import 'package:eps_open_api_reference_app/widget/WidgetAccountHistory.dart';
import 'package:eps_open_api_reference_app/widget/WidgetAccountList.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonCircle.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/ModalBottomSheet.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformPageRoute.dart';
import 'package:eps_open_api_reference_app/widget/ui/SpinProgressIndicator.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'WidgetReceipt.dart';
import 'WidgetScreenTransactionP2P.dart';

class WidgetScreenDashboard extends StatelessWidget {
  Widget build(BuildContext context) {
    return WidgetScreen(
      isScrollViewEnabled: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: 110),
        child: WidgetDashboard(),
      ),
    );
  }
}

class WidgetDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WidgetDashboardState();
}

class WidgetDashboardState extends State<WidgetDashboard>
    with TickerProviderStateMixin {
  final Bloc<BlocStateAccountsActive> blocAccountsActive;
  final Bloc<BlocStateAccountsFavorites> blocAccountsFavorites;
  final Bloc<BlocStateAccountsTotalBalances> blocAccountsTotalBalances;
  _AnimatorDashboard animator;

  WidgetDashboardState()
      : blocAccountsActive = BlocStorage.storage.get(BlocStateAccountsActive),
        blocAccountsFavorites =
            BlocStorage.storage.get(BlocStateAccountsFavorites),
        blocAccountsTotalBalances =
            BlocStorage.storage.get(BlocStateAccountsTotalBalances);

  @override
  void initState() {
    super.initState();
    this.animator = _AnimatorDashboard(this);
    EpayserviceApi().getAccounts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: BlocWidgetObserver(
        bloc: blocAccountsActive,
        onBuild: (context, state, bloc) {
          return BlocWidgetObserver(
            bloc: blocAccountsFavorites,
            onBuild: (context, state, bloc) {
              return BlocWidgetObserver(
                bloc: blocAccountsTotalBalances,
                onBuild: (context, state, bloc) {
                  return FadeTransition(
                    opacity: animator.fadeContentAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _onBuildUserInfo(),
                          SizedBox(height: 25),
                          _onBuildMenu(),
                          SizedBox(height: 25),
                          _onBuildButtonPay(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _onBuildUserInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DateFormat('EEEE, d MMM').format(DateTime.now()).toUpperCase(),
          textAlign: TextAlign.start,
          style: AppTextStyle.getText2(color: AppColor.white),
        ),
        SizedBox(height: 8.0),
        Text(
          'Hello',
          style: AppTextStyle.getTextHeader2(color: AppColor.white),
        ),
        SizedBox(height: 8.0),
        Text(
          "You have " +
              blocAccountsActive.state.accounts.length.toString() +
              " wallets",
          style: AppTextStyle.getText1(color: AppColor.white),
        ),
      ],
    );
  }

  Widget _onBuildMenu() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        onBuildMenuContent(),
        _onBuildMenuButton(),
      ],
    );
  }

  Widget onBuildMenuContent() {
    return Container(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 27),
        decoration: BoxDecoration(
          color: Color(0xFF374C6B),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _onBuildMenuTotalBalances(),
            _onBuildMenuFavoritesAccounts(),
          ],
        ),
      ),
    );
  }

  Widget _onBuildMenuSpinner() {
    return Container(
      height: 30,
      width: 30,
      child: SpinProgressIndicator(),
    );
  }

  Widget _onBuildMenuTotalBalances() {
    return SizedBox(
      height: 50,
      child: PageView.builder(
        itemCount: blocAccountsTotalBalances.state.balances.length,
        itemBuilder: _onBuildTotalBalanceWidget,
      ),
    );
  }

  Widget _onBuildTotalBalanceWidget(BuildContext context, int index) {
    final map = blocAccountsTotalBalances.state.balances;
    final String currency = map.keys.elementAt(index);
    final Decimal balance = map.values.elementAt(index);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'TOTAL $currency',
          style: AppTextStyle.getText3(
            color: Color(0xFFE5E5E5),
          ),
        ),
        Text(
          Money.format(string: balance.toString(), currencyCode: currency),
          style: AppTextStyle.getTextHeader3(color: AppColor.white),
        ),
      ],
    );
  }

  Widget _onBuildMenuFavoritesAccounts() {
    final List<Widget> widgets = List();
    final accounts = blocAccountsFavorites.state.accounts;

    for (int i = 0; i < accounts.length; i++) {
      final account = accounts.elementAt(i);
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: WidgetAccount(
            account: account,
            onPressed: () {
              Navigator.push(
                context,
                PlatformPageRoute.build(
                  fullscreenDialog: true,
                  builder: (context) => WidgetAccountHistory(account),
                ),
              );
            },
          ),
        ),
      );
      if (i < accounts.length - 1) {
        widgets.add(
          material.Divider(
            height: 1,
            color: AppColor.white15,
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widgets.length > 0) SizedBox(height: 15),
        if (widgets.length > 0)
          Text(
            "Favorite wallets",
            style: AppTextStyle.getText1(color: AppColor.greyOnWhite)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        if (widgets.length > 0) SizedBox(height: 5),
        ...widgets,
      ],
    );
  }

  Widget _onBuildMenuButton() {
    return SizedBox(
      width: 48,
      height: 48,
      child: ButtonCircle(
        childLeft: SvgPicture.asset(
          AppAssetPath.getMenuBurger(),
          color: AppColor.white,
          width: 13,
          height: 13,
          alignment: Alignment.center,
        ),
        onPressed: () => _onShowModalBottomSheet(
            child: _widgetFullAccountList(context),
            backgroundColor: AppColor.blueOnWhite),
      ),
    );
  }

  Widget _widgetFullAccountList(BuildContext context) {
    return WidgetAccountList(
        accounts: blocAccountsActive.state.accounts,
        onPressed: (account) {
          Navigator.of(context).push(
            PlatformPageRoute.build(
              fullscreenDialog: true,
              builder: (context) {
                return WidgetAccountHistory(account);
              },
            ),
          );
        });
  }

  void _onShowModalBottomSheet(
      {@required Widget child, Color backgroundColor}) {
    animator.hideContent();
    ModalBottomSheet.show(
            context: context,
            percent: 0.85,
            child: child,
            backgroundColor: backgroundColor)
        .whenComplete(
      () => animator.showContent(),
    );
  }

  Widget _onBuildButtonPay() {
    return ButtonStadium(
      text: "Send money",
      onPressed: () async {
        final response = await Navigator.push(
          context,
          PlatformPageRoute.build(
            fullscreenDialog: true,
            builder: (context) {
              final size = MediaQuery.of(context).size;
              final child = Container(
                  height: size.height,
                  width: size.width,
                  child: WidgetScreenTransactionP2P());
              return material.Container(
                  color: AppColor.grey,
                  child: FormKeyboardActions(autoScroll: true, child: child));
            },
          ),
        );

        if (response != null) {
          final transaction = AccountHistoryEntity.fromMap(response);
          _onShowModalBottomSheet(
              child: WidgetReceipt(transaction),
              backgroundColor: AppColor.white);
        }
      },
    );
  }

  void _onEvent(BuildContext context, BlocEvent event, Bloc<BlocState> bloc) {}

  void _onError(BuildContext context, Object error, Bloc<BlocState> bloc) {
    ErrorHandler.process(context: context, error: error);
  }
}

class _AnimatorDashboard {
  AnimationController controller;
  Animation<double> fadeContentAnimation;

  _AnimatorDashboard(WidgetDashboardState widget) {
    this.controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: widget);
    fadeContentAnimation =
        Tween<double>(begin: 1, end: 0).animate(this.controller);
  }

  void hideContent() {
    this.controller.forward();
  }

  void showContent() {
    this.controller.reverse();
  }
}
