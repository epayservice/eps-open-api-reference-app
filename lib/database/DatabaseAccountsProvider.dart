import 'dart:async';

import 'package:eps_open_api_reference_app/bloc/BlocAccounts.dart';
import 'package:eps_open_api_reference_app/database/SqfEntityModels.dart';
import 'package:eps_open_api_reference_app/entity/Account.dart';
import 'package:eps_open_api_reference_app/entity/Card.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class DatabaseAccountsProvider {
  Future<bool> save(Account account, {bool update = true}) async {
    final completer = Completer<bool>();

    final Function saveAccount = () {
      _accountToDB(account).save().then((result) {
        completer.complete(true);
        if (update) {
          _onUpdateAccounts();
        }
      }).catchError((error) {
        completer.completeError(error);
      });
    };

    if (account != null && account.id != null) {
      if (account.card == null) {
        saveAccount();
      } else {
        _DatabaseCardsProvider().save(account.card).then((result) {
          saveAccount();
        }).catchError((error) {
          completer.completeError(error);
        });
      }
    } else {
      completer.completeError(Exception());
    }

    return completer.future;
  }

  Future<void> saveAll(List<Account> accounts) async {
    final completer = Completer();

    final List<Future<bool>> futures = List();
    for (Account account in accounts) {
      final future = save(account, update: false);
      futures.add(future);
    }

    Future.wait(futures).then((list) {
      for (bool result in list) {
        if (!result) {
          completer.completeError(Exception());
          return;
        }
      }
      completer.complete(null);
      _onUpdateAccounts();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  //  Future<Account> getById(int id) async {
  //    final completer = Completer();
  //
  //    DatabaseAccount().getById(
  //      id,
  //      (dbAccount) {
  //        final account = _accountFromDB(dbAccount);
  //        completer.complete(account);
  //      },
  //    );
  //
  //    return completer.future;
  //  }

  Future<List<Account>> getAll() async {
    final completer = Completer<List<Account>>();
    final list = List<Account>();
    final futures = List<Future>();

    DatabaseAccount().select().toList((dbAccounts) {
      for (final dbAccount in dbAccounts) {
        final future = _accountFromDB(dbAccount).then((account) {
          list.add(account);
        });
        futures.add(future);
      }

      Future.wait(futures).then((result) {
        completer.complete(list);
      }).catchError((error) {
        completer.completeError(Exception());
      });
    });

    return completer.future;
  }

  Future<bool> deleteById(int id) {
    final completer = Completer();

    DatabaseAccount().getById(id, (dbAccount) {
      dbAccount.getDatabaseCard((dbCard) {
        dbCard.delete().then((result) {
          if (result.success) {
            dbAccount.delete().then((result2) {
              if (result2.success) {
                completer.complete(true);
              } else {
                completer.completeError(Exception());
              }
            });
          } else {
            completer.completeError(Exception());
          }
        }).catchError((error) {
          completer.completeError(error);
        });
      });
    });

    return completer.future;
  }

  Future<bool> deleteAll() {
    final completer = Completer<bool>();

    DatabaseAccount().select().delete().then((result) {
      completer.complete(true);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<Account> _accountFromDB(DatabaseAccount dbAccount) {
    final completer = Completer<Account>();

    final Account Function(DatabaseAccount dbAccount, Card card) func = (dbAccount, card) {
      return Account(
        id: dbAccount.id,
        type: dbAccount.type,
        balance: dbAccount.balance,
        name: dbAccount.name,
        number: dbAccount.number,
        currencyLabel: dbAccount.currency_label,
        currency: dbAccount.currency,
        paymentProviderCode: dbAccount.payment_provider_code,
        favorite: dbAccount.favorite,
        card: card,
      );
    };

    dbAccount.getDatabaseCard((dbCard) {
      Card card;
      if (dbCard != null) {
        card = _DatabaseCardsProvider()._cardFromDB(dbCard);
      }
      final account = func(dbAccount, card);
      completer.complete(account);
    });

    return completer.future;
  }

  DatabaseAccount _accountToDB(Account account) {
    return DatabaseAccount(
      id: account.id,
      type: account.type,
      balance: account.balance,
      name: account.name,
      number: account.number,
      currency: account.currency,
      currency_label: account.currencyLabel,
      favorite: account.favorite,
      payment_provider_code: account.paymentProviderCode,
      DatabaseTableCardId: account.card != null ? account.card.id : null,
    );
  }

  void _onUpdateAccounts() {
    getAll().then((accounts) {
      final bloc = BlocInstance.storage.getOrCreate<BlocStateAccounts>(BlocStateAccounts());
      bloc.enqueueAction(BlocActionAccountsUpdate(accounts));
    });
  }
}

class _DatabaseCardsProvider {
  Future<void> save(Card card) async {
    final completer = Completer();

    if (card != null && card.id != null) {
      _cardToDB(card).save().then((result) {
        completer.complete(null);
      }).catchError((error) {
        completer.completeError(error);
      });
    } else {
      completer.completeError(Exception());
    }

    return completer.future;
  }

  //  Future<void> saveAll(List<Card> cards) async {
  //    final completer = Completer();
  //
  //    final futures = List<Future<bool>>();
  //    for (Card card in cards) {
  //      futures.add(save(card));
  //    }
  //
  //    Future.wait(futures).then((list) {
  //      for (bool result in list) {
  //        if (!result) {
  //          completer.completeError(Exception());
  //          return;
  //        }
  //      }
  //      completer.complete(null);
  //    }).catchError((error) {
  //      completer.completeError(error);
  //    });
  //
  //    return completer.future;
  //  }
  //
  //  Future<Card> getById(int id) async {
  //    final completer = Completer();
  //
  //    DatabaseCard().getById(
  //      id,
  //      (dbCard) {
  //        if (dbCard != null) {
  //          final card = _cardFromDB(dbCard);
  //          completer.complete(card);
  //        } else {
  //          completer.completeError(Exception());
  //        }
  //      },
  //    );
  //
  //    return completer.future;
  //  }
  //
  //  Future<List<Card>> getAll() async {
  //    final completer = Completer();
  //    final list = List<Card>();
  //
  //    DatabaseCard().select().toList((dbCards) {
  //      for (final dbCard in dbCards) {
  //        final card = _cardFromDB(dbCard);
  //        list.add(card);
  //      }
  //      completer.complete(list);
  //    });
  //
  //    return completer.future;
  //  }
  //
  //  Future<void> deleteById(int id) async {
  //    final completer = Completer();
  //
  //    DatabaseCard().getById(id, (dbCard) {
  //      dbCard.delete().then((result) {
  //        if (result.success) {
  //          completer.complete(null);
  //        } else {
  //          completer.completeError(Exception());
  //        }
  //      }).catchError((error) {
  //        completer.completeError(error);
  //      });
  //    });
  //
  //    return completer.future;
  //  }
  //
  //  Future<void> deleteAll() async {
  //    final completer = Completer();
  //
  //    DatabaseCard().select().delete().then((result) {
  //      if (result.success) {
  //        completer.complete(null);
  //      } else {
  //        completer.completeError(Exception());
  //      }
  //    }).catchError((error) {
  //      completer.completeError(error);
  //    });
  //
  //    return completer.future;
  //  }

  Card _cardFromDB(DatabaseCard dbCard) {
    return Card(
      id: dbCard.id,
      status: CardStatusConverter.cardStatus(dbCard.status),
      currency: dbCard.currency,
      expiredYear: dbCard.exp_y,
      expiredMonth: dbCard.exp_m,
      maskedNumber: dbCard.masked_number,
      isVirtual: dbCard.is_virtual,
      isReloadable: dbCard.is_reloadable,
      limitsGroup: dbCard.limit_groups,
    );
  }

  DatabaseCard _cardToDB(Card card) {
    return DatabaseCard(
      id: card.id,
      status: CardStatusConverter.string(card.status),
      currency: card.currency,
      exp_y: card.expiredYear,
      exp_m: card.expiredMonth,
      masked_number: card.maskedNumber,
      is_virtual: card.isVirtual,
      is_reloadable: card.isReloadable,
      limit_groups: card.limitsGroup,
    );
  }
}
