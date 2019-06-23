import 'package:eps_open_api_reference_app/entity/Card.dart';

enum AccountType {
  regular,
  card,
  virtualCard,
  crypto,
}

class Account {
  final int id;
  final String type;
  final String balance;
  final String name;
  final String number;
  final String currency;
  final String currencyLabel;
  final String paymentProviderCode;
  final bool favorite;
  final Card card;

  Account({
    this.id,
    this.type,
    this.balance,
    this.name,
    this.number,
    this.currency,
    this.currencyLabel,
    this.paymentProviderCode,
    this.favorite,
    this.card,
  });
}
