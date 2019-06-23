import 'package:decimal/decimal.dart';
import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationPin.dart';
import 'package:eps_open_api_reference_app/bloc/BlocScreenTransactionP2PConfirmation.dart';
import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:eps_open_api_reference_app/utils/Money.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/ModalBottomSheet.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_svg/svg.dart';

import 'WidgetScreenAuthorizationPin.dart';
import 'WidgetScreenWithScaffold.dart';

final kDescription = "Description";
final kAmount = "Amount";
final kToWallet = "To Wallet";
final kFromWallet = "From Wallet";
final kFee = "Fee";
final kTotal = "Total";
final kCurrency = "Currency";

class TransactionType {
  static const p2p = const TransactionType._("Internal Transfer");
  static const webmoney = const TransactionType._("Webmoney Transfer");

  static get values => [p2p, webmoney];

  final String value;

  const TransactionType._(this.value);
}

class WidgetScreenTransactionP2PConfirmation extends StatefulWidget {
  final Map<String, String> formInfo;
  final Map<String, String> requestParams;
  final TransactionType transactionType;

  WidgetScreenTransactionP2PConfirmation(this.transactionType, this.formInfo, this.requestParams);

  @override
  State<StatefulWidget> createState() => WidgetScreenTransactionP2PConfirmationState(this.transactionType, this.formInfo, this.requestParams);
}

class WidgetScreenTransactionP2PConfirmationState extends State<WidgetScreenTransactionP2PConfirmation> with RouteAware {
  final Map<String, String> formInfo;
  final Map<String, String> requestParams;
  final TransactionType transactionType;
  final bloc;

  WidgetScreenTransactionP2PConfirmationState(this.transactionType, this.formInfo, this.requestParams)
      : bloc = BlocStorage.storage.getOrCreate<BlocStateCreateP2P>(BlocStateCreateP2P());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    BlocStorage.storage.destroy(bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScreenWithScaffold(
      child: BlocWidgetObserver(
        bloc: bloc,
        onError: _onError,
        onEvent: _onEvent,
        onBuild: (context, state, bloc) {
          return Container(
              padding: EdgeInsets.all(20.0),
              color: AppColor.white,
              child: SafeArea(
                  bottom: false,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_topBlock(), _fieldsListBlock(), _bottomButton(state)])));
        },
      ),
    );
  }

  Widget _topBlock() {
    final typeStr = this.transactionType.value;
    final amountStr = Money.format(string: this.formInfo[kAmount], currencyCode: this.formInfo[kCurrency]);
    final descriptionStr = this.formInfo[kDescription];

    final btn = (material.FlatButton(
        padding: EdgeInsets.all(0),
        child: SvgPicture.asset(
          AppAssetPath.getCrossLines(),
          color: AppColor.greyE5,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        shape: CircleBorder()));

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
      Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [Spacer(flex: 1), Container(width: 30, height: 30, child: btn)]),
      ),
      Text(typeStr, style: AppTextStyle.getTextHeader5(color: AppColor.blueOnWhite)),
      SizedBox(height: 16),
      Text(amountStr, style: AppTextStyle.getTextHeader1(color: AppColor.blue)),
      SizedBox(height: 8),
      Text(descriptionStr, style: AppTextStyle.getText2(color: AppColor.blueOnWhite)),
    ]);
  }

  Widget _onBuildSeparator() {
    return material.Divider(
      color: material.Colors.grey,
    );
  }

  Widget _fieldBlock(String key, String value) {
    return SizedBox(
      height: 30,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
        Text(key, style: AppTextStyle.getText3(color: AppColor.black)),
        Text(value, style: AppTextStyle.getText3(color: AppColor.black)),
      ]),
    );
  }

  _createPayment() {
    switch (this.transactionType) {
      case TransactionType.p2p:
        bloc.enqueueAction(BlocActionCreateP2P(this.requestParams));
        break;
      case TransactionType.webmoney:
        break;
    }
  }

  _showSCA() {
    ModalBottomSheet.show(
      context: context,
      backgroundColor: AppColor.blueOnWhite,
      child: WidgetScreenAuthorizationPin(
        useCase: UseCasePin.confirmation,
        onSuccessCallback: () {
          Navigator.pop(context);
          _createPayment();
        },
      ),
      percent: 0.85,
    );
  }

  Widget _bottomButton(BlocStateCreateP2P state) {
    return ButtonStadium(
      onPressed: _showSCA,
      progressIndicatorEnabled: state.isCreating,
      text: "Pay",
      stretchHorizontally: true,
    );
  }

  Widget _fieldsListBlock() {
    //todo: there is must stay only keys and values.
    final feeValueStr = Money.format(string: this.formInfo[kFee], currencyCode: this.formInfo[kCurrency]);

    final totalValueDecimal = Decimal.parse(this.formInfo[kFee]) + Decimal.parse(this.formInfo[kAmount]);

    final totalValueStr = Money.format(string: totalValueDecimal.toString(), currencyCode: this.formInfo[kCurrency]);

    List<Widget> fields = [
      _fieldBlock(kToWallet, this.formInfo[kToWallet]),
      _onBuildSeparator(),
      _fieldBlock(kFromWallet, this.formInfo[kFromWallet]),
      _onBuildSeparator(),
      _fieldBlock(kFee, feeValueStr),
      _onBuildSeparator(),
      _fieldBlock(kTotal, totalValueStr),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: fields);
  }

  void _onEvent(BuildContext context, BlocEvent event, Bloc<BlocState> bloc) {
    if (event is BlocCreateP2PSuccess) {
      // for reciept comporation
      event.response["transaction_type"] = this.transactionType.value;
      //

      Navigator.pop(context, event.response);
      EpayserviceApi().getAccounts();
    }
  }

  void _onError(BuildContext context, Object error, Bloc<BlocState> bloc) {
    ErrorHandler.process(context: context, error: error);
  }
}
