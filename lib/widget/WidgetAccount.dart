import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Money.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class WidgetAccount extends StatelessWidget {
  final Account account;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;

  WidgetAccount({
    @required this.account,
    this.padding = const EdgeInsets.all(0.0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = Padding(
      padding: padding,
      child: (account != null) ? _onBuildAccount() : Container(),
    );

    if (onPressed != null) {
      widget = GestureDetector(
        onTap: () {
          onPressed();
        },
        child: widget,
      );
    }

    return widget;
  }

  Widget _onBuildAccount() {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          AppAssetPath.getWallet(),
          width: 17,
          height: 17,
          color: AppColor.blue,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Text(
              account.name,
              style: AppTextStyle.getText1(color: AppColor.white),
            ),
          ),
        ),
        Text(
          Money.format(
            string: account.balance,
            currencyCode: account.currency,
          ),
          style: AppTextStyle.getText1(color: AppColor.white),
        ),
      ],
    );
  }
}
