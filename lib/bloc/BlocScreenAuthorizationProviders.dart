import 'package:eps_open_api_reference_app/entity/EpayserviceOauthData.dart';
import 'package:eps_open_api_reference_app/repository/SecureStorage.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocAuthProviders extends BlocState {
  EpayserviceOauthData epayserviceOauth;

  BlocAuthProviders() {
    epayserviceOauth = EpayserviceOauthData();
  }
}

class BlocActionUpdateState extends BlocAction<BlocAuthProviders> {
  @override
  BlocAuthProviders action(BlocAuthProviders state, Bloc<BlocAuthProviders> bloc) {
    SecureStorage.getInstance().then((storage) {
      storage.getEpayserviceOauthData().then((epayserviceOauth) {
        bloc.enqueueAction(BlocActionSetOauth(epayserviceOauth));
      });
    });
    return null;
  }
}

class BlocActionSetOauth extends BlocAction<BlocAuthProviders> {
  final EpayserviceOauthData _epayserviceOauth;

  BlocActionSetOauth(this._epayserviceOauth);

  @override
  BlocAuthProviders action(BlocAuthProviders state, Bloc<BlocAuthProviders> bloc) {
    state.epayserviceOauth = _epayserviceOauth;
    return state;
  }
}

class BlocEventGoToAuthorizationEpayserviceOauth extends BlocEvent {}
