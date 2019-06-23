import 'package:decimal/decimal.dart';
import 'package:eps_open_api_reference_app/utils/Currency.dart';
import 'package:meta/meta.dart';

export 'package:eps_open_api_reference_app/utils/Currency.dart';

class Money {
  static String format({@required String string, Currency currency, int fractions, String currencyCode}) {
    if (currency != null) {
      return _toStringWithCurrency(value: string, currency: currency);
    } else {
      currency = Currency.fromCode(currencyCode);
      if (currency != null) {
        return _toStringWithCurrency(value: string, currency: currency);
      } else {
        String result = _toStringWithFractions(value: string, fractions: fractions);
        result = _toStringWithCurrencyCode(value: result, currencyCode: currencyCode);
        return result;
      }
    }
  }

  static String _toStringWithCurrency({@required String value, Currency currency, int fractions, String currencyCode}) {
    if (currency != null) {
      String result;

      result = _toStringWithFractions(value: value, fractions: currency.fractions ?? fractions);
      result = _toStringWithCurrencyCode(value: result, currencyCode: currency.code ?? currencyCode);

      return result;
    } else {
      return value;
    }
  }

  static String _toStringWithFractions({@required String value, int fractions}) {
    assert(value != null);

    String result;

    try {
      final decimal = Decimal.parse(value);
      result = decimal.toStringAsFixed(fractions);
    } catch (error) {
      result = value;
    }

    return result;
  }

  static String _toStringWithCurrencyCode({@required String value, String currencyCode}) {
    assert(value != null);

    String result = value;

    if (currencyCode != null) {
      result += ' ' + currencyCode;
    }

    return result;
  }
}
