import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/entity/Card.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocStateAccountsActive extends BlocState {
  List<Account> accounts;

  BlocStateAccountsActive() : accounts = List();
}

class BlocActionAccountsActiveUpdate extends BlocAction<BlocStateAccountsActive> {
  final List<Account> accounts;

  BlocActionAccountsActiveUpdate(this.accounts);

  @override
  BlocStateAccountsActive action(BlocStateAccountsActive state, Bloc<BlocStateAccountsActive> bloc) {
    final List<Account> list = List();

    for (final account in accounts) {
      if (account.card == null || account.card.status == CardStatus.active) {
        list.add(account);
      }
    }

    state.accounts = list;
    return state;
  }
}
