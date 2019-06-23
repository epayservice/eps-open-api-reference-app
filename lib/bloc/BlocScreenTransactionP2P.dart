import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocStateScreenTransactionP2P extends BlocState {
  Account fromAccount;
  String fromAccountError;
  String toWalletNumber;
  String toWalletNumberError;
  String comment;
  String commentError;
  String amount;
  String amountError;
  String fee;
  String feeSms;
  String total;
  bool isAllValid = true;
  bool isErrorsEnabled = false;
  bool isFeeUpdating = false;
}

class BlocActionScreenTransactionP2PSetAccount extends BlocAction<BlocStateScreenTransactionP2P> {
  final Account account;

  BlocActionScreenTransactionP2PSetAccount(this.account);

  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    if (account != state.fromAccount) {
      state.fromAccount = account;
    }
    BlocActionScreenTransactionP2PValidate().action(state, bloc);
    BlocActionScreenTransactionP2PUpdateFee().action(state, bloc);
    return state;
  }
}

class BlocActionScreenTransactionP2PSetWalletNumber extends BlocAction<BlocStateScreenTransactionP2P> {
  final String string;

  BlocActionScreenTransactionP2PSetWalletNumber(this.string);

  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    if (string != state.toWalletNumber) {
      state.toWalletNumber = string;
    }
    BlocActionScreenTransactionP2PValidate().action(state, bloc);
    BlocActionScreenTransactionP2PUpdateFee().action(state, bloc);
    return state;
  }
}

class BlocActionScreenTransactionP2PSetComment extends BlocAction<BlocStateScreenTransactionP2P> {
  final String string;

  BlocActionScreenTransactionP2PSetComment(this.string);

  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    state.comment = string;
    BlocActionScreenTransactionP2PValidate().action(state, bloc);
    //    BlocActionScreenTransactionP2PUpdateFee().action(state, bloc);
    return state;
  }
}

class BlocActionScreenTransactionP2PSetAmount extends BlocAction<BlocStateScreenTransactionP2P> {
  final String string;

  BlocActionScreenTransactionP2PSetAmount(this.string);

  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    if (string != state.amount) {
      state.amount = string;
    }
    BlocActionScreenTransactionP2PValidate().action(state, bloc);
    BlocActionScreenTransactionP2PUpdateFee().action(state, bloc);
    return state;
  }
}

class BlocActionScreenTransactionP2PValidate extends BlocAction<BlocStateScreenTransactionP2P> {
  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    state.isAllValid = true;

    if (state.fromAccount != null) {
      state.fromAccountError = null;
    } else {
      state.isAllValid = false;
      if (state.isErrorsEnabled) {
        state.fromAccountError = "You have not chosen a wallet";
      }
    }

    if (state.toWalletNumber != null && state.toWalletNumber.replaceAll(' ', '').length == 16) {
      state.toWalletNumberError = null;
    } else {
      state.isAllValid = false;
      if (state.isErrorsEnabled) {
        state.toWalletNumberError = "Wallet number entered incorrectly";
      }
    }

    if (state.comment != null && state.comment.length >= 5) {
      state.commentError = null;
    } else {
      state.isAllValid = false;
      if (state.isErrorsEnabled) {
        state.commentError = "Comment entered incorrectly";
      }
    }

    if (state.amount != null && state.amount != "") {
      state.amountError = null;
    } else {
      state.isAllValid = false;
      if (state.isErrorsEnabled) {
        state.amountError = "Amount entered incorrectly";
      }
    }

    return state;
  }
}

class BlocActionScreenTransactionP2PUpdateFee extends BlocAction<BlocStateScreenTransactionP2P> {
  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    if (state.isAllValid) {
      state.isFeeUpdating = true;

      Future.delayed(Duration(microseconds: 300), () {
        EpayserviceApi().getP2PFee(state.fromAccount, state.amount).then((result) {
          state.fee = null;
          state.feeSms = null;
          state.total = null;

          if (result.containsKey("fee_value")) {
            state.fee = result["fee_value"];
            if (result.containsKey("fee_currency")) {
              state.fee += ' ' + result["fee_currency"];
            }
          }
          if (result.containsKey("fee_sms_value")) {
            if (result["fee_sms_value"] != "0.0") {
              state.feeSms = result["fee_sms_value"];
              if (result.containsKey("fee_sms_currency")) {
                state.feeSms += ' ' + result["fee_sms_currency"];
              }
            }
          }
          if (result.containsKey("total_value")) {
            state.total = result["total_value"];
            if (result.containsKey("total_currency")) {
              state.total += ' ' + result["total_currency"];
            }
          }

          state.isFeeUpdating = false;
          bloc.enqueueAction(BlocActionUpdate());
        });
      });
    } else {
      state.isFeeUpdating = false;
      state.fee = null;
      state.feeSms = null;
      state.total = null;
    }
    return state;
  }
}

class BlocActionScreenTransactionP2POnPressButtonNext extends BlocAction<BlocStateScreenTransactionP2P> {
  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    state.isErrorsEnabled = true;
    BlocActionScreenTransactionP2PValidate().action(state, bloc);

    if (state.isAllValid && !state.isFeeUpdating) {
      bloc.enqueueEvent(BlocEventGoToScreenConfirmation());
    }

    return state;
  }
}

class BlocActionUpdate extends BlocAction<BlocStateScreenTransactionP2P> {
  @override
  BlocStateScreenTransactionP2P action(BlocStateScreenTransactionP2P state, Bloc<BlocStateScreenTransactionP2P> bloc) {
    BlocActionScreenTransactionP2PValidate().action(state, bloc);
    return state;
  }
}

class BlocEventGoToScreenConfirmation extends BlocEvent {}
