import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/widget/WidgetAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetAccountList extends StatelessWidget {
  final List<Account> accounts;
  final List<String> filterAccountType;
  final List<String> filterPaymentProvider;
  final void Function(Account account) onPressed;

  WidgetAccountList({
    Key key,
    @required this.accounts,
    this.filterAccountType,
    this.filterPaymentProvider,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _onBuildContent();
  }

  Widget _onBuildContent() {
    final List<ListItem> result = [];
    final List<ListItem> walletsUS = [];
    final List<ListItem> walletsEU = [];
    final List<ListItem> debitCards = [];
    final List<ListItem> virtualCards = [];
    final List<ListItem> digitalCurrency = [];
    final List<ListItem> cryptoCurrency = [];

    for (final account in accounts) {
      if (filterAccountType != null && !filterAccountType.contains(account.type)) {
        continue;
      }
      if (filterPaymentProvider != null && !filterPaymentProvider.contains(account.paymentProviderCode)) {
        continue;
      }

      if (account.type == 'REGULAR') {
        if (account.paymentProviderCode == 'MTACCEU') {
          walletsEU.add(AccountItem(account));
        } else if (account.paymentProviderCode == 'MTACCUS') {
          walletsUS.add(AccountItem(account));
        } else if (account.paymentProviderCode == 'WM') {
          digitalCurrency.add(AccountItem(account));
        }
      } else if (account.type == 'CARD') {
        debitCards.add(AccountItem(account));
      } else if (account.type == 'VCARD') {
        virtualCards.add(AccountItem(account));
      } else if (account.type == 'CRYPTO') {
        cryptoCurrency.add(AccountItem(account));
      }
    }

    if (walletsUS.length > 0) {
      result.add(HeaderItem('US wallets'));
      result.addAll(walletsUS);
    }

    if (walletsEU.length > 0) {
      result.add(HeaderItem('EU wallets'));
      result.addAll(walletsEU);
    }

    if (digitalCurrency.length > 0) {
      result.add(HeaderItem('Digital currency'));
      result.addAll(digitalCurrency);
    }

    if (debitCards.length > 0) {
      result.add(HeaderItem('Debit cards'));
      result.addAll(debitCards);
    }

    if (virtualCards.length > 0) {
      result.add(HeaderItem('Virtual cards'));
      result.addAll(virtualCards);
    }

    if (cryptoCurrency.length > 0) {
      result.add(HeaderItem('Crypto currency'));
      result.addAll(cryptoCurrency);
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 25),
      itemCount: result.length,
      itemBuilder: (context, index) {
        final item = result.elementAt(index);
        if (item is HeaderItem) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Text(
              item.text,
              style: AppTextStyle.getText3(color: AppColor.greyOnWhite),
            ),
          );
        } else if (item is AccountItem) {
          return WidgetAccount(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            account: item.account,
            onPressed: () {
              if (this.onPressed != null) {
                Navigator.of(context).pop();
                onPressed(item.account);
              }
            },
          );
        }
      },
      separatorBuilder: (context, index) {
        bool show = ((index < result.length - 1) && (result.elementAt(index) is AccountItem) && (result.elementAt(index + 1) is AccountItem));
        return Divider(
          height: 1,
          color: show ? AppColor.white15 : AppColor.transparent,
          indent: 30,
        );
      },
    );
  }
}

abstract class ListItem {}

class HeaderItem extends ListItem {
  String text;

  HeaderItem(this.text);
}

class AccountItem extends ListItem {
  final Account account;

  AccountItem(this.account);
}
