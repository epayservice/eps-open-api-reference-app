import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocStateCreateP2P extends BlocState {
  bool isCreating = false;
}

class BlocActionSetIsCreating extends BlocAction<BlocStateCreateP2P> {
  bool isCreating = false;

  BlocActionSetIsCreating(this.isCreating);

  @override
  BlocStateCreateP2P action(BlocStateCreateP2P state, Bloc<BlocStateCreateP2P> bloc) {
    state.isCreating = this.isCreating;
    return state;
  }
}

class BlocActionCreateP2P extends BlocAction<BlocStateCreateP2P> {
  final _api = EpayserviceApi();
  Map<String, dynamic> params;

  BlocActionCreateP2P(this.params);

  @override
  BlocStateCreateP2P action(BlocStateCreateP2P state, Bloc<BlocStateCreateP2P> bloc) {
    bloc.enqueueAction(BlocActionSetIsCreating(true));
    _api.postP2POut(params).then((response) {
      bloc.enqueueEvent(BlocCreateP2PSuccess(response));
    }).catchError((error) {
      bloc.enqueueError(error);
    }).whenComplete(() {
      bloc.enqueueAction(BlocActionSetIsCreating(false));
    });
    return state;
  }
}

class BlocCreateP2PSuccess extends BlocEvent {
  Map<String, dynamic> response;

  BlocCreateP2PSuccess(this.response);
}
