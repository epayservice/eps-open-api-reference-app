import 'package:eps_open_api_reference_app/entity/AccountHistory.dart';
import 'package:eps_open_api_reference_app/net/EpayserviceApi.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:intl/intl.dart';

class BlocStateAccountHistory extends BlocState {
  List<AccountHistoryEntity> historySource = [];
  List<AccountHistoryListAbstractItem> historyListView = [];
  bool isRefreshing = false;
}

class BlocActionGetAccountHistory extends BlocAction<BlocStateAccountHistory> {
  final _api = EpayserviceApi();
  String accountId;

  BlocActionGetAccountHistory(this.accountId);

  @override
  BlocStateAccountHistory action(BlocStateAccountHistory state, Bloc<BlocStateAccountHistory> bloc) {
    bloc.enqueueAction(BlocActionGetAccountHistoryServer(accountId));
    return state;
  }
}

class BlocActionGetAccountHistoryServer extends BlocAction<BlocStateAccountHistory> {
  final _api = EpayserviceApi();
  String accountId;

  BlocActionGetAccountHistoryServer(this.accountId);

  @override
  BlocStateAccountHistory action(BlocStateAccountHistory state, Bloc<BlocStateAccountHistory> bloc) {
    state.isRefreshing = true;
    _api.getAccountHistory(accountId).then((data) {
      List<AccountHistoryEntity> result = [];

      for (final item in data) {
        final entity = AccountHistoryEntity.fromMap(item);
        result.add(entity);
      }

      state.isRefreshing = false;
      bloc.enqueueAction(BlocActionSetAccountHistory(result));
    });
    return state;
  }
}

class BlocActionSetAccountHistory extends BlocAction<BlocStateAccountHistory> {
  List<AccountHistoryEntity> accountHistory = null;

  BlocActionSetAccountHistory(this.accountHistory);

  @override
  BlocStateAccountHistory action(BlocStateAccountHistory state, Bloc<BlocStateAccountHistory> bloc) {
    state.historySource = this.accountHistory;
    state.historyListView = this.createListForView();
    return state;
  }

  List<AccountHistoryListAbstractItem> createListForView() {
    Map<String, List<AccountHistoryListItem>> dictionary = {};

    for (final item in this.accountHistory) {
      final day = new DateFormat.MMMMEEEEd().format(item.createdAt);
      if (dictionary[day] == null) {
        dictionary[day] = [];
      }
      dictionary[day].add(AccountHistoryListItem(item));
    }

    List<AccountHistoryListAbstractItem> result = [];
    for (final day in dictionary.keys) {
      result.add(AccountHistoryHeadingItem(day));
      result.addAll(dictionary[day]);
    }

    return result;
  }
}

abstract class AccountHistoryListAbstractItem {}

class AccountHistoryHeadingItem implements AccountHistoryListAbstractItem {
  final String heading;

  AccountHistoryHeadingItem(this.heading);
}

class AccountHistoryListItem implements AccountHistoryListAbstractItem {
  AccountHistoryEntity entity;

  AccountHistoryListItem(this.entity);
}
