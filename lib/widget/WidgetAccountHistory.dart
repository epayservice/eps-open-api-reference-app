import 'package:decimal/decimal.dart';
import 'package:eps_open_api_reference_app/bloc/BlocScreenAccountHistory.dart';
import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/entity/AccountHistory.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Money.dart';
import 'package:eps_open_api_reference_app/widget/WidgetReceipt.dart';
import 'package:eps_open_api_reference_app/widget/ui/ModalBottomSheet.dart';
import 'package:eps_open_api_reference_app/widget/ui/SpinProgressIndicator.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WidgetAccountHistory extends StatefulWidget {
  final Account account;

  WidgetAccountHistory(this.account);

  @override
  State<StatefulWidget> createState() => WidgetAccountHistoryState(this.account);
}

class WidgetAccountHistoryState extends State<WidgetAccountHistory> {
  final Account account;
  final Bloc<BlocStateAccountHistory> bloc;

  WidgetAccountHistoryState(this.account) : bloc = BlocStorage.storage.getOrCreate<BlocStateAccountHistory>(BlocStateAccountHistory());

  @override
  void initState() {
    super.initState();
    bloc.enqueueAction(BlocActionGetAccountHistory(this.account.id.toString()));
  }

  @override
  void dispose() {
    BlocStorage.storage.destroy(bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.blueOnWhite,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _infoBlock(),
            Expanded(child: _listBlock()),
          ],
        ),
      ),
    );
  }

  Widget _infoBlock() {
    final btn = material.FlatButton(
      padding: EdgeInsets.all(0),
      child: SvgPicture.asset(
        AppAssetPath.getCrossLines(),
        color: AppColor.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      shape: CircleBorder(),
    );

    String walletNumber = "";
    if (account.card != null && account.type == "CARD" || account.type == "VCARD") {
      walletNumber = account.card.maskedNumber;
    } else {
      walletNumber = account.number;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: Text(
                account.name,
                style: AppTextStyle.getText1(color: AppColor.white),
              ),
            ),
            Container(width: 30, height: 30, child: btn)
          ]),
        ),
        Text(Money.format(string: account.balance, currencyCode: account.currency), style: AppTextStyle.getTextHeader1(color: AppColor.white)),
        Text("Wallet number: " + walletNumber, style: AppTextStyle.getText1(color: AppColor.white))
      ]),
    );
  }

  Widget _listBlock() {
    final spinner = Container(
      height: 100,
      width: 50,
      child: SpinProgressIndicator(),
    );

    final blocObserverWidget = BlocWidgetObserver(
      bloc: bloc,
      onBuild: (context, state, bloc) {
        if (state.isRefreshing) {
          return Center(child: spinner);
        } else {
          return Expanded(child: _listView(state: state));
        }
      },
    );

    return Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: new BorderRadius.only(topLeft: const Radius.circular(20.0), topRight: const Radius.circular(20.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 25),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                "Recent Transactions",
                style: AppTextStyle.getTextHeader3(color: AppColor.blueOnWhite),
              ),
            ),
            SizedBox(height: 8),
            blocObserverWidget
          ]),
        ));
  }

  Widget dayHeading({String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: AppColor.grey,
                borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
              ),
              child: Text(title, style: AppTextStyle.getText3(color: AppColor.blueOnWhite60))),
        ],
      ),
    );
  }

  Widget rowItem({AccountHistoryListItem item}) {
    final time = new DateFormat.Hm().format(item.entity.createdAt);
    final color = item.entity.typeAct == "in" ? AppColor.blue : AppColor.red;

    final sign = item.entity.typeAct == "in" ? "+" : "-";
    Decimal amount = Decimal.parse(item.entity.amount);
    final amountStr = Money.format(string: amount.toString(), currencyCode: item.entity.currency);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(children: [
        Row(children: [
          Expanded(child: Text(item.entity.transactionType, style: AppTextStyle.getText3(color: AppColor.black))),
          Text(sign + amountStr, style: AppTextStyle.getText1(color: color))
        ]),
        Row(children: [
          Expanded(child: Text(item.entity.description, style: AppTextStyle.getText3(color: AppColor.black))),
          Text(time, style: AppTextStyle.getText1(color: AppColor.greyOnWhite40))
        ])
      ]),
    );
  }

  void _onPressShowReceipt(BuildContext context, AccountHistoryEntity transaction) {
    ModalBottomSheet.show(context: context, child: WidgetReceipt(transaction), percent: 0.85);
  }

  Widget _listView({BlocStateAccountHistory state}) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10),
      separatorBuilder: (context, index) {
        AccountHistoryListAbstractItem item = state.historyListView[index];
        bool isNextDay = false;
        if ((index + 1) < state.historyListView.length) {
          AccountHistoryListAbstractItem itemNext = state.historyListView[index + 1];
          isNextDay = itemNext is AccountHistoryHeadingItem;
        }
        if (item is AccountHistoryListItem && !isNextDay) {
          return material.Divider(color: AppColor.black30, indent: 25);
        } else {
          return material.Divider(
            color: AppColor.transparent,
          );
        }
      },
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: state.historyListView.length,
      itemBuilder: (BuildContext context, int index) {
        AccountHistoryListAbstractItem item = state.historyListView[index];
        if (item is AccountHistoryListItem) {
          return GestureDetector(
              onTap: () {
                _onPressShowReceipt(context, item.entity);
              },
              child: rowItem(item: item));
        } else if (item is AccountHistoryHeadingItem) {
          return dayHeading(title: item.heading);
        }
      },
    );
  }
}
