import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocStateAccountsFavorites extends BlocState {
  List<Account> accounts;

  BlocStateAccountsFavorites() : accounts = List();
}

class BlocActionAccountsFavoritesUpdate extends BlocAction<BlocStateAccountsFavorites> {
  final List<Account> accounts;

  BlocActionAccountsFavoritesUpdate(this.accounts);

  @override
  BlocStateAccountsFavorites action(BlocStateAccountsFavorites state, Bloc<BlocStateAccountsFavorites> bloc) {
    final List<Account> list = List();

    int max = 3;
    for (int i = 0; i < max && i < accounts.length; i++) {
      if (accounts[i].type == "CARD" || accounts[i].type == "VCARD" && accounts[i].card == null) {
        max++;
        continue;
      }
      //      if (accounts[i].favorite) {
      list.add(accounts[i]);
      //      }
    }

    state.accounts = list;
    return state;
  }
}
