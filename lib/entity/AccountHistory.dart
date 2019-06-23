class AccountHistoryEntity {
  final id;
  final accountId;
  final typeAct;
  final details;
  final description;
  final comment;
  final status;
  final amount;
  final tax;
  final currency;
  final createdAt;
  final transactionType;
  final availableBalance;

  AccountHistoryEntity(this.id, this.accountId, this.typeAct, this.details, this.description, this.comment, this.status, this.amount, this.tax, this.currency,
      this.createdAt, this.transactionType, this.availableBalance);

  AccountHistoryEntity.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        accountId = json["account_id"],
        typeAct = json["type_act"],
        details = json["details"],
        description = json["description"],
        comment = json["comment"],
        status = json["status"],
        amount = json["amount"],
        tax = json["tax"],
        currency = json["currency"],
        createdAt = DateTime.parse(json["created_at"]),
        transactionType = json["transaction_type"],
        availableBalance = json["available_balance"];

  Map<String, dynamic> toMap() => {
        "id": id,
        "account_id": accountId,
        "type_act": typeAct,
        "details": details,
        "description": description,
        "comment": comment,
        "status": status,
        "tax": tax,
        "currency": currency,
        "amount": amount,
        "created_at": createdAt.toString(),
        "transaction_type": transactionType,
        "available_balance": availableBalance,
      };
}
