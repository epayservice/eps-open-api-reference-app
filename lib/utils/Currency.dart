import 'package:flutter/foundation.dart';
import 'package:money/money.dart' as lib;

const Set<Currency> _currencies = const {
  Currency(code: "BTC", fractions: 8),
  Currency(code: "BYN", fractions: 2),
  Currency(code: "WMZ", fractions: 2),
  Currency(code: "WME", fractions: 2),
  Currency(code: "WMR", fractions: 2),
};

class Currency {
  final String code;
  final int fractions;

  const Currency({
    @required this.code,
    @required this.fractions,
  })  : assert(code != null),
        assert(fractions != null),
        assert(fractions >= 0);

  static Currency fromCode(String code) {
    try {
      final currency = lib.Currency(code);
      return Currency(
        code: currency.code,
        fractions: currency.defaultFractionDigits,
      );
    } catch (error) {
      if (code != null) {
        final currency = _currencies.firstWhere(
          (currency) {
            return currency.code == code;
          },
          orElse: () {
            return null;
          },
        );
        if (currency != null) {
          return Currency(
            code: currency.code,
            fractions: currency.fractions,
          );
        }
      }
    }

    return null;
  }
}
