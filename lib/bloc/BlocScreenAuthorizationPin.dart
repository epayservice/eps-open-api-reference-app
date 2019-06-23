import 'package:eps_open_api_reference_app/repository/SecureStorage.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

enum UseCasePin { setup, enter, confirmation }

class BlocStateAuthPin extends BlocState {
  UseCasePin useCase = UseCasePin.setup;
  String pin = "";

  BlocStateAuthPin({@required UseCasePin useCase}) : useCase = useCase;
}

class BlocActionAddDigit extends BlocAction<BlocStateAuthPin> {
  final String _text;

  BlocActionAddDigit(this._text);

  @override
  BlocStateAuthPin action(BlocStateAuthPin state, Bloc<BlocStateAuthPin> bloc) {
    if (state.pin.length < 8) {
      state.pin += _text;
      if (state.useCase == UseCasePin.enter || state.useCase == UseCasePin.confirmation) {
        BlockActionValidate().action(state, bloc);
      }
      return state;
    } else {
      bloc.enqueueError(ErrorString("PIN code can contain a maximum of 8 characters"));
    }
    return null;
  }
}

class BlocActionBackspace extends BlocAction<BlocStateAuthPin> {
  @override
  BlocStateAuthPin action(BlocStateAuthPin state, Bloc<BlocStateAuthPin> bloc) {
    if (state.pin != null && state.pin.length > 0) {
      state.pin = state.pin.substring(0, state.pin.length - 1);
      return state;
    }
    return null;
  }
}

class BlocActionReset extends BlocAction<BlocStateAuthPin> {
  @override
  BlocStateAuthPin action(BlocStateAuthPin state, Bloc<BlocStateAuthPin> bloc) {
    if (state.pin != "") {
      state.pin = "";
      return state;
    }
    return null;
  }
}

class BlockActionValidate extends BlocAction<BlocStateAuthPin> {
  @override
  BlocStateAuthPin action(BlocStateAuthPin state, Bloc<BlocStateAuthPin> bloc) {
    if (state.useCase == UseCasePin.setup) {
      return _actionSetup(state, bloc);
    } else if (state.useCase == UseCasePin.enter || state.useCase == UseCasePin.confirmation) {
      return _actionEnter(state, bloc);
    }
    return null;
  }

  BlocStateAuthPin _actionSetup(BlocStateAuthPin state, Bloc<BlocStateAuthPin> bloc) {
    if (state.pin == null || state.pin.length < 4) {
      bloc.enqueueError(ErrorString("Это слишком короткий пин-код"));
      return null;
    }
    _savePin(state.pin, bloc);
    bloc.enqueueEvent(BlocEventPinAuthorizationSuccessful());
    return null;
  }

  BlocStateAuthPin _actionEnter(BlocStateAuthPin state, Bloc<BlocStateAuthPin> bloc) {
    _getPin().then((pinOriginal) {
      if (state.pin == pinOriginal) {
        bloc.enqueueEvent(BlocEventPinAuthorizationSuccessful());
      } else if (state.pin.length >= pinOriginal.length) {
        bloc.enqueueError(ErrorString("Неверный пин-код"));
        bloc.enqueueAction(BlocActionReset());
      }
    }).catchError((error) {
      bloc.enqueueError(ErrorStringUndefined());
    });
    return null;
  }

  void _savePin(String pin, Bloc<BlocStateAuthPin> bloc) async {
    final storage = await SecureStorage.getInstance();
    await storage.setPin(pin).catchError((error) {
      bloc.enqueueError(ErrorStringUndefined());
    });
  }

  Future<String> _getPin() {
    return SecureStorage.getInstance().then((s) {
      return s.getPin();
    });
  }
}

class BlocEventPinAuthorizationSuccessful extends BlocEvent {}
