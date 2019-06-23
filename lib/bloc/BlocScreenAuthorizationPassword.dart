import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:validators/validators.dart';

enum UseCase { emailValidate, register, login }

class BlocStateAuthPW extends BlocState {
  String email;
  String emailError;
  bool emailAutoValidate = false;
  String password;
  String passwordError;
  bool passwordAutoValidate = false;
  UseCase useCase = UseCase.emailValidate;
  bool isLoading = false;
}

class BlocActionSetUseCase extends BlocAction<BlocStateAuthPW> {
  final UseCase _useCase;

  BlocActionSetUseCase(this._useCase);

  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    if (_useCase != state.useCase) {
      state.useCase = _useCase;
      return state;
    }
    return null;
  }
}

class BlocActionSetLoading extends BlocAction<BlocStateAuthPW> {
  final bool _isLoading;

  BlocActionSetLoading(this._isLoading);

  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    if (state.isLoading != _isLoading) {
      state.isLoading = _isLoading;
      return state;
    }
    return null;
  }
}

class BlocActionEmailChanged extends BlocAction<BlocStateAuthPW> {
  final String _string;

  BlocActionEmailChanged(this._string);

  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    state.email = _string;
    if (state.emailAutoValidate) {
      BlocActionEmailValidate().action(state, bloc);
    }
    if (state.useCase == UseCase.register || state.useCase == UseCase.login) {
      BlocActionSetUseCase(UseCase.emailValidate).action(state, bloc);
    }

    return state;
  }
}

class BlocActionEmailValidate extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    final String string = state.email;

    if (string == null || string.isEmpty) {
      state.emailError = "Email cannot be empty";
    } else if (!isEmail(string)) {
      state.emailError = "This is not like email";
    } else {
      state.emailError = null;
    }

    return state;
  }
}

class BlocActionPasswordChanged extends BlocAction<BlocStateAuthPW> {
  final String _string;

  BlocActionPasswordChanged(this._string);

  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    state.password = _string;
    if (state.passwordAutoValidate) {
      BlocActionPasswordValidate().action(state, bloc);
    }
    return state;
  }
}

class BlocActionPasswordValidate extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    final String string = state.password;

    if (string == null || string.isEmpty) {
      state.passwordError = "Password can not be empty";
    } else if (!isLength(string, 6)) {
      state.passwordError = "Password must contain at least 6 characters";
    } else if (isNumeric(string)) {
      state.passwordError = "Password should not contain only numbers";
    } else if (isAlpha(string)) {
      state.passwordError = "Password should not contain only letters";
    } else if (isLowercase(string)) {
      state.passwordError = "Password must contain at least one capital letter";
    } else if (isUppercase(string)) {
      state.passwordError = "Password must contain at least one lower case letter.";
    } else if (isAlphanumeric(string)) {
      state.passwordError = "Password must contain at least one character";
    } else {
      state.passwordError = null;
    }

    return state;
  }
}

class BlocActionOnPressButtonNext extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    if (state.useCase == UseCase.emailValidate) {
      state.emailAutoValidate = true;
      BlocActionEmailValidate().action(state, bloc);
      if (state.emailError == null) {
        return BlocActionFirebaseFindCurrentUser().action(state, bloc);
      } else {
        return state;
      }
    } else if (state.useCase == UseCase.register) {
      state.emailAutoValidate = true;
      state.passwordAutoValidate = true;
      BlocActionEmailValidate().action(state, bloc);
      BlocActionPasswordValidate().action(state, bloc);
      if (state.emailError == null && state.passwordError == null) {
        return BlocActionFirebaseRegister().action(state, bloc);
      } else {
        return state;
      }
    } else if (state.useCase == UseCase.login) {
      state.emailAutoValidate = true;
      state.passwordAutoValidate = true;
      BlocActionEmailValidate().action(state, bloc);
      BlocActionPasswordValidate().action(state, bloc);
      if (state.emailError == null && state.passwordError == null) {
        return BlocActionFirebaseLogin().action(state, bloc);
      } else {
        return state;
      }
    }
    return null;
  }
}

class BlocActionFirebaseFindCurrentUser extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        bloc.enqueueAction(BlocActionSetLoading(false));
        bloc.enqueueEvent(BlocEventGoToSetupPin());
      } else {
        bloc.enqueueAction(BlocActionFirebaseFindEmail());
      }
    }).catchError((error) {
      bloc.enqueueAction(BlocActionFirebaseFindEmail());
    });
    return null;
  }
}

class BlocActionFirebaseFindEmail extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    FirebaseAuth.instance.fetchSignInMethodsForEmail(email: state.email).then((list) {
      if (list.length > 0 && list.contains("password")) {
        bloc.enqueueAction(BlocActionSetLoading(false));
        bloc.enqueueAction(BlocActionSetUseCase(UseCase.login));
      } else {
        bloc.enqueueAction(BlocActionSetLoading(false));
        bloc.enqueueAction(BlocActionSetUseCase(UseCase.register));
      }
    }, onError: (error) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      if (error is PlatformException) {
        PlatformException exception = error;
        if (exception.code == "ERROR_INVALID_CREDENTIAL") {
          bloc.enqueueError(ErrorString("Email failed validation"));
        } else if (exception.code == "ERROR_USER_NOT_FOUND") {
          bloc.enqueueAction(BlocActionSetUseCase(UseCase.register));
        } else {
          bloc.enqueueError(ErrorStringUndefined());
        }
      }
    }).catchError((error) {
      // TODO: fix error NoSuchMethod(): length
      bloc.enqueueAction(BlocActionSetLoading(false));
      if (error is NoSuchMethodError) {
        bloc.enqueueAction(BlocActionSetUseCase(UseCase.register));
      } else {
        bloc.enqueueError(ErrorStringUndefined());
      }
    });

    return BlocActionSetLoading(true).action(state, bloc);
  }
}

class BlocActionFirebaseRegister extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: state.email, password: state.password).then((user) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      bloc.enqueueEvent(BlocEventGoToSetupPin());
    }, onError: (error) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      if (error is PlatformException) {
        PlatformException exception = error;
        if (exception.code == "ERROR_WEAK_PASSWORD") {
          bloc.enqueueError(ErrorString("Password is too simple"));
        } else if (exception.code == "ERROR_INVALID_CREDENTIAL") {
          bloc.enqueueError(ErrorString("Email failed validation"));
        } else if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          bloc.enqueueError(ErrorString("User with this email is already registered"));
          bloc.enqueueAction(BlocActionSetUseCase(UseCase.login));
        } else if (exception.code == "ERROR_OPERATION_NOT_ALLOWED") {
          bloc.enqueueError(ErrorString("Registration is currently unavailable"));
        } else {
          bloc.enqueueError(ErrorStringUndefined());
        }
      }
    }).catchError((error) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      bloc.enqueueError(ErrorStringUndefined());
    });

    return BlocActionSetLoading(true).action(state, bloc);
  }
}

class BlocActionFirebaseLogin extends BlocAction<BlocStateAuthPW> {
  @override
  BlocStateAuthPW action(BlocStateAuthPW state, Bloc<BlocStateAuthPW> bloc) {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: state.email, password: state.password).then((user) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      bloc.enqueueEvent(BlocEventGoToSetupPin());
    }, onError: (error) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      if (error is PlatformException) {
        PlatformException exception = error;
        if (exception.code == "ERROR_INVALID_EMAIL") {
          bloc.enqueueError(ErrorString("Invalid email"));
        } else if (exception.code == "ERROR_WRONG_PASSWORD") {
          bloc.enqueueError(ErrorString("Wrong password"));
        } else if (exception.code == "ERROR_USER_NOT_FOUND") {
          bloc.enqueueError(ErrorString("User with such email not found"));
        } else if (exception.code == "ERROR_TOO_MANY_REQUESTS") {
          bloc.enqueueError(ErrorString("Number of login attempts exceeded. Try later."));
        } else if (exception.code == "ERROR_OPERATION_NOT_ALLOWED") {
          bloc.enqueueError(ErrorString("Authorization is currently unavailable"));
        } else {
          bloc.enqueueError(ErrorStringUndefined());
        }
      }
    }).catchError((error) {
      bloc.enqueueAction(BlocActionSetLoading(false));
      bloc.enqueueError(ErrorStringUndefined());
    });

    return BlocActionSetLoading(true).action(state, bloc);
  }
}

class BlocEventGoToSetupPin extends BlocEvent {}
