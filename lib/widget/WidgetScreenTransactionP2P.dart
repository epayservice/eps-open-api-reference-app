import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:eps_open_api_reference_app/bloc/BlocAccounts.dart';
import 'package:eps_open_api_reference_app/bloc/BlocScreenTransactionP2P.dart';
import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Money.dart';
import 'package:eps_open_api_reference_app/widget/WidgetAccount.dart';
import 'package:eps_open_api_reference_app/widget/WidgetAccountList.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreenTransactionP2PConfirmation.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonCircle.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/ModalBottomSheet.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformButton.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformPageRoute.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/TextField.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class WidgetScreenTransactionP2P extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<WidgetScreenTransactionP2P> {
  TextInputFormatter numberInputFormatter;
  TextInputFormatter amountInputFormatter;
  Bloc<BlocStateScreenTransactionP2P> bloc;
  FocusNode focusNodeWalletNumber;
  FocusNode focusNodeComment;
  FocusNode focusNodeAmount;

  _State() {
    numberInputFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocStorage.storage.getOrCreate<BlocStateScreenTransactionP2P>(
        BlocStateScreenTransactionP2P());
    focusNodeWalletNumber = FocusNode();
    focusNodeComment = FocusNode();
    focusNodeAmount = FocusNode();
    FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
  }

  @override
  void dispose() {
    BlocStorage.storage.destroy(bloc);
    focusNodeWalletNumber.dispose();
    focusNodeComment.dispose();
    focusNodeAmount.dispose();
    super.dispose();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: AppColor.grey,
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: focusNodeWalletNumber,
        ),
        KeyboardAction(
          focusNode: focusNodeComment,
        ),
        KeyboardAction(
          focusNode: focusNodeAmount,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocWidgetObserver(
      bloc: bloc,
      onBuild: (context, state, _) {
        amountInputFormatter =
            TextInputFormatter.withFunction((oldValue, newValue) {
          try {
            String text = newValue.text;

            if (text.startsWith(".")) {
              text = text.substring(1);
            }

            Decimal decimal = Decimal.parse(text);

            if (text.contains(".") && !text.endsWith(".")) {
              int fractions = 0;
              if (bloc.state.fromAccount != null) {
                final currency =
                    Currency.fromCode(bloc.state.fromAccount.currency);
                if (currency != null) {
                  fractions = currency.fractions;
                }
              }

              if (decimal.scale > fractions) {
                text = decimal.toStringAsFixed(fractions);
                if (fractions <= 0) {
                  text = text.replaceAll(".", "");
                }
              }
            }

            return newValue.copyWith(text: text);
          } catch (exception) {
            if (newValue.text == '') {
              return newValue;
            } else {
              return newValue.copyWith(text: oldValue.text);
            }
          }
        });

        return WidgetScreen(
          isBackgroundEnabled: false,
          isLogoEnabled: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 15),
                          Text("Internal transfer",
                              style: AppTextStyle.getTextHeader2(
                                  color: AppColor.blueOnWhite)),
                          SizedBox(height: 6),
                          Text("To another person".toUpperCase(),
                              style: AppTextStyle.getText2(
                                  color: AppColor.blueOnWhite))
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    ButtonCircle(
                      colorEnabled: false,
                      childLeft: SvgPicture.asset(
                        AppAssetPath.getCrossLines(),
                        color: AppColor.greyOnWhite,
                      ),
                      onPressed: () => _onPressedButtonClose(context),
                    )
                  ],
                ),
                SizedBox(height: 30),
                if (bloc.state.fromAccountError != null && Platform.isIOS)
                  Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 6),
                    child: Text(bloc.state.fromAccountError,
                        style: AppTextStyle.getText4(color: AppColor.red)),
                  ),
                PlatformButton(
                  platform: PlatformSelector.android,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: (bloc.state.fromAccountError == null)
                        ? BorderSide.none
                        : BorderSide(color: AppColor.red, width: 1.5),
                  ),
                  color: AppColor.blueOnWhite,
                  padding: EdgeInsets.all(15),
                  child: Container(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (bloc.state.fromAccount != null) ...[
                          Text(
                            "From wallet",
                            style: AppTextStyle.getText1(
                                color: AppColor.greyOnWhite),
                          ),
                          SizedBox(height: 10),
                          WidgetAccount(account: bloc.state.fromAccount),
                        ] else
                          Container(
                            width: double.maxFinite,
                            child: Text(
                              "Select wallet ⤵".toUpperCase(),
                              textAlign: TextAlign.center,
                              style:
                                  AppTextStyle.getText1(color: AppColor.white)
                                      .copyWith(fontWeight: FontWeight.w400),
                            ),
                          )
                      ],
                    ),
                  ),
                  onPressed: () => _onPressedButtonSelectAccount(context),
                ),
                if (bloc.state.fromAccountError != null && Platform.isAndroid)
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 6),
                    child: Text(bloc.state.fromAccountError,
                        style: AppTextStyle.getText4(color: AppColor.red)),
                  ),
                SizedBox(height: 30),
                TextField2(
                  labelText: "Wallet Number",
                  errorText: bloc.state.toWalletNumberError,
                  keyboardType: TextInputType.number,
                  focusNode: focusNodeWalletNumber,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [numberInputFormatter],
                  onChanged: (text) {
                    bloc.enqueueAction(
                        BlocActionScreenTransactionP2PSetWalletNumber(text));
                  },
                  onSubmitted: (text) {
                    focusNodeWalletNumber.unfocus();
                    FocusScope.of(context).requestFocus(focusNodeComment);
                  },
                ),
                SizedBox(height: 16),
                TextField2(
                  labelText: "Comment",
                  errorText: bloc.state.commentError,
                  keyboardType: TextInputType.text,
                  focusNode: focusNodeComment,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    bloc.enqueueAction(
                        BlocActionScreenTransactionP2PSetComment(text));
                  },
                  onSubmitted: (text) {
                    focusNodeComment.unfocus();
                    FocusScope.of(context).requestFocus(focusNodeAmount);
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField2(
                        labelText: "Amount",
                        errorText: bloc.state.amountError,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        focusNode: focusNodeAmount,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [amountInputFormatter],
                        onChanged: (text) {
                          bloc.enqueueAction(
                              BlocActionScreenTransactionP2PSetAmount(text));
                        },
                        onSubmitted: (text) {
                          focusNodeAmount.unfocus();
                        },
                      ),
                    ),
                    if (bloc.state.fromAccount != null)
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          top: (Platform.isIOS) ? 20 : 0,
                          bottom: (Platform.isAndroid &&
                                  bloc.state.amountError != null)
                              ? 22
                              : 0,
                        ),
                        child: Text(
                          bloc.state.fromAccount.currency,
                          style: AppTextStyle.getTextHeader4(
                                  color: AppColor.blueOnWhite)
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(child: Container()),
                if (bloc.state.fee != null)
                  Text("Fee: " + bloc.state.fee,
                      style: AppTextStyle.getText1(color: AppColor.black)),
                if (bloc.state.feeSms != null)
                  Text("Sms fee: " + bloc.state.feeSms,
                      style: AppTextStyle.getText1(color: AppColor.black)),
                if (bloc.state.total != null)
                  Text("Total: " + bloc.state.total,
                      style: AppTextStyle.getText1(color: AppColor.black)),
                SizedBox(height: 16),
                ButtonStadium(
                  progressIndicatorEnabled: bloc.state.isFeeUpdating,
                  text: "Confirm transfer",
                  onPressed: (!bloc.state.isFeeUpdating &&
                          (!bloc.state.isErrorsEnabled ||
                              bloc.state.isAllValid))
                      ? () {
                          focusNodeWalletNumber.unfocus();
                          focusNodeComment.unfocus();
                          focusNodeAmount.unfocus();
                          bloc.enqueueAction(BlocActionScreenTransactionP2POnPressButtonNext());
                        }
                      : null,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
      onEvent: (context, event, bloc) {
        if (event is BlocEventGoToScreenConfirmation) {
          _onPressedButtonConfirm(context);
        }
      },
    );
  }

  void _onPressedButtonSelectAccount(BuildContext context) {
    final Bloc<BlocStateAccounts> bloc =
        BlocStorage.storage.get(BlocStateAccounts);

    Widget widget = Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColor.blueOnWhite,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      child: WidgetAccountList(
        accounts: bloc.state.accounts,
        filterAccountType: ["REGULAR"],
        onPressed: _onAccountSelected,
      ),
    );

    ModalBottomSheet.show(context: context, child: widget, percent: 0.85);
  }

  void _onPressedButtonConfirm(BuildContext context) async {
    Map<String, String> formInfo = {};

    formInfo[kFromWallet] = bloc.state.fromAccount.number;
    formInfo[kToWallet] = bloc.state.toWalletNumber;
    formInfo[kDescription] = bloc.state.comment;
    formInfo[kCurrency] = bloc.state.fromAccount.currency;
    formInfo[kAmount] = bloc.state.amount;
    formInfo[kFee] = "0.0";

    Map<String, String> paramsRequest = {
      "sender_account_id": bloc.state.fromAccount.id.toString(),
      "receiver_account_number": bloc.state.toWalletNumber,
      "amount": bloc.state.amount,
      "comment": bloc.state.comment
    };

    final respose = await Navigator.push(
      context,
      PlatformPageRoute.build(
        fullscreenDialog: true,
        builder: (context) => WidgetScreenTransactionP2PConfirmation(
            TransactionType.p2p, formInfo, paramsRequest),
      ),
    );

    if (respose != null) {
      Navigator.pop(context, respose);
    }
  }

  void _onPressedButtonClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onAccountSelected(Account account) {
    bloc.enqueueAction(BlocActionScreenTransactionP2PSetAccount(account));
  }
}
