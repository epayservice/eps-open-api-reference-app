import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:local_auth/local_auth.dart';

class BlocStateAuthBio extends BlocState {
  bool isFingerprintAvailable = false;
  bool isFaceIdAvailable = false;
}

class BlocActionBioSetAvailable extends BlocAction<BlocStateAuthBio> {
  final bool _isFingerprintAvailable;
  final bool _isFaceIdAvailable;

  BlocActionBioSetAvailable(this._isFingerprintAvailable, this._isFaceIdAvailable);

  @override
  BlocStateAuthBio action(BlocStateAuthBio state, Bloc<BlocStateAuthBio> bloc) {
    state.isFingerprintAvailable = _isFingerprintAvailable;
    state.isFaceIdAvailable = _isFaceIdAvailable;
    return state;
  }
}

class BlocActionBioCheckSettingsAndAuthenticate extends BlocAction<BlocStateAuthBio> {
  @override
  BlocStateAuthBio action(BlocStateAuthBio state, Bloc<BlocStateAuthBio> bloc) {
    final auth = LocalAuthentication();

    auth.getAvailableBiometrics().then((list) {
      final bool isFingerprint = list.contains(BiometricType.fingerprint);
      final bool isFaceId = list.contains(BiometricType.face);
      bloc.enqueueAction(BlocActionBioSetAvailable(isFingerprint, isFaceId));
      if (isFingerprint || isFaceId) {
        bloc.enqueueAction(BlocActionBioAuthenticate());
      }
    }).catchError((error) {
      bloc.enqueueAction(BlocActionBioSetAvailable(false, false));
      bloc.enqueueError(ErrorStringUndefined());
    });

    return null;
  }
}

class BlocActionBioAuthenticate extends BlocAction<BlocStateAuthBio> {
  @override
  BlocStateAuthBio action(BlocStateAuthBio state, Bloc<BlocStateAuthBio> bloc) {
    final auth = LocalAuthentication();

    auth.authenticateWithBiometrics(localizedReason: "Confirm login to the app", useErrorDialogs: true).then((isAuthenticated) {
      if (isAuthenticated) {
        bloc.enqueueEvent(BlocEventBioAuthenticationSuccess());
      }
    }).catchError((error) {
      if (error is PlatformException && error.code == "NotEnrolled") {
        bloc.enqueueError(ErrorString("Fingerprints are not configured on the device."));
      } else if (error is PlatformException && error.message != null) {
        bloc.enqueueError(ErrorString(error.message));
      } else {
        bloc.enqueueError(ErrorStringUndefined());
      }
    });

    return null;
  }
}

class BlocEventBioAuthenticationSuccess extends BlocEvent {}
