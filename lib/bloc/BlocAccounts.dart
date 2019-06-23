import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocStateAccounts extends BlocState {
  List<Account> accounts;

  BlocStateAccounts() : accounts = List();
}

class BlocActionAccountsUpdate extends BlocAction<BlocStateAccounts> {
  final List<Account> accounts;

  BlocActionAccountsUpdate(this.accounts);

  @override
  BlocStateAccounts action(BlocStateAccounts state, Bloc<BlocStateAccounts> bloc) {
    state.accounts = accounts;
    return state;
  }
}
