enum CardStatus {
  active,
  inactive,
  closed,
}

class CardStatusConverter {
  static CardStatus cardStatus(String string) {
    if (string == "active") {
      return CardStatus.active;
    } else if (string == "inactive") {
      return CardStatus.inactive;
    } else if (string == "closed") {
      return CardStatus.closed;
    } else {
      return null;
    }
  }

  static String string(CardStatus status) {
    if (status == CardStatus.active) {
      return "active";
    } else if (status == CardStatus.inactive) {
      return "inactive";
    } else if (status == CardStatus.closed) {
      return "closed";
    } else {
      return null;
    }
  }
}

class Card {
  final int id;
  final CardStatus status;
  final String currency;
  final int expiredYear;
  final int expiredMonth;
  final String maskedNumber;
  final bool isVirtual;
  final bool isReloadable;
  final String limitsGroup;

  Card({
    this.id,
    this.status,
    this.currency,
    this.expiredYear,
    this.expiredMonth,
    this.maskedNumber,
    this.isVirtual,
    this.isReloadable,
    this.limitsGroup,
  });
}
