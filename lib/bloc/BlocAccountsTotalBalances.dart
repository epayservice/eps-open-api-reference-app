import 'package:decimal/decimal.dart';
import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class BlocStateAccountsTotalBalances extends BlocState {
  Map<String, Decimal> balances;

  BlocStateAccountsTotalBalances() : balances = Map();
}

class BlocActionAccountsTotalBalancesUpdate extends BlocAction<BlocStateAccountsTotalBalances> {
  final List<Account> accounts;

  BlocActionAccountsTotalBalancesUpdate(this.accounts);

  @override
  BlocStateAccountsTotalBalances action(BlocStateAccountsTotalBalances state, Bloc<BlocStateAccountsTotalBalances> bloc) {
    Map<String, Decimal> balances = Map();

    for (final account in accounts) {
      final String currency = account.currency;
      final Decimal balance = Decimal.parse(account.balance);
      balances.update(
        currency.toUpperCase(),
        (value) {
          return value + balance;
        },
        ifAbsent: () {
          return balance;
        },
      );
    }

    state.balances = balances;
    return state;
  }
}
