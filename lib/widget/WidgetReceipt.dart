import 'package:eps_open_api_reference_app/entity/AccountHistory.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Money.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class WidgetReceipt extends StatefulWidget {
  final AccountHistoryEntity transaction;

  WidgetReceipt(this.transaction);

  @override
  State<StatefulWidget> createState() {
    return _WidgetReceiptState(transaction);
  }
}

class _WidgetReceiptState extends State<WidgetReceipt> {
  final AccountHistoryEntity transaction;

  _WidgetReceiptState(this.transaction);

  @override
  Widget build(BuildContext context) {
    final widgetsList = List<Widget>();

    if (transaction != null) {
      widgetsList.add(SizedBox(height: 50));

      if (transaction.transactionType != null) {
        widgetsList.add(Text(transaction.transactionType, style: AppTextStyle.getTextHeader3()));
      }

      if (transaction.amount != null) {
        String amountStr = Money.format(string: transaction.amount, currencyCode: transaction.currency);

        Widget widget = Text(amountStr, style: AppTextStyle.getTextHeader1(color: AppColor.blue));
        widget = Container(margin: EdgeInsets.only(top: 5), child: widget);
        widgetsList.add(widget);
      }

      if (transaction.comment != null) {
        String string = transaction.comment;
        Widget widget = Text(
          string,
          style: AppTextStyle.getTextHeader4(color: AppColor.black),
          textAlign: TextAlign.center,
        );
        widget = Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: widget,
        );
        widgetsList.add(widget);
      }

      widgetsList.add(SizedBox(height: 20));

      if (transaction.createdAt != null) {
        widgetsList.add(_onBuildRow("Date", DateFormat.MMMMEEEEd().format(transaction.createdAt)));
        widgetsList.add(_onBuildDivider());
      }

      if (transaction.amount != null && transaction.tax != null) {
        final amountTax = double.parse(transaction.amount) + double.parse(transaction.tax);
        final amountTaxStr = Money.format(string: amountTax.toString(), currencyCode: transaction.currency);
        widgetsList.add(_onBuildRow("Amount", amountTaxStr));
        widgetsList.add(_onBuildDivider());
      }

      if (transaction.tax != null) {
        String string = transaction.tax;
        if (transaction.currency != null) {
          string += ' ' + transaction.currency;
        }
        widgetsList.add(_onBuildRow("Fee", string));
        widgetsList.add(_onBuildDivider());
      }

      widgetsList.add(SizedBox(height: 20));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgetsList,
    );
  }

  Widget _onBuildRow(String left, String right) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(left, style: AppTextStyle.getText1()),
            Text(right, style: AppTextStyle.getText1()),
          ],
        ));
  }

  Widget _onBuildDivider() {
    return Divider(
      indent: 30,
      color: AppColor.black50,
    );
  }
}
