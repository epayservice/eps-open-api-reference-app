import 'package:path/path.dart';
import 'package:sqfentity/db/sqfEntityBase.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  final String model = Database().createModel();
  return;
}

class Database extends SqfEntityModel {
  Database() {
    databaseName = "OpenBankingORM.db";
    bundledDatabasePath = null;
    databaseTables = [_DatabaseTableAccounts.getInstance, _DatabaseTableCards.getInstance];
  }

  remove() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this.databaseName);
    await deleteDatabase(path);
  }
}

class _DatabaseTableAccounts extends SqfEntityTable {
  static SqfEntityTable _instance;

  static SqfEntityTable get getInstance {
    if (_instance == null) {
      _instance = _DatabaseTableAccounts();
    }
    return _instance;
  }

  _DatabaseTableAccounts() {
    tableName = "DatabaseTableAccount";
    modelName = "DatabaseAccount";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;

    fields = [
      SqfEntityField("type", DbType.text),
      SqfEntityField("balance", DbType.text),
      SqfEntityField("name", DbType.text),
      SqfEntityField("number", DbType.text),
      SqfEntityField("currency_label", DbType.text),
      SqfEntityField("currency", DbType.text),
      SqfEntityField("favorite", DbType.bool),
      SqfEntityField("payment_provider_code", DbType.text),
      SqfEntityFieldRelationship(_DatabaseTableCards.getInstance, DeleteRule.CASCADE, defaultValue: "0"),
    ];

    super.init();
  }
}

class _DatabaseTableCards extends SqfEntityTable {
  static SqfEntityTable _instance;

  static SqfEntityTable get getInstance {
    if (_instance == null) {
      _instance = _DatabaseTableCards();
    }
    return _instance;
  }

  _DatabaseTableCards() {
    tableName = "DatabaseTableCard";
    modelName = "DatabaseCard";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;

    fields = [
      SqfEntityField("status", DbType.text),
      SqfEntityField("currency", DbType.text),
      SqfEntityField("exp_y", DbType.integer),
      SqfEntityField("exp_m", DbType.integer),
      SqfEntityField("masked_number", DbType.text),
      SqfEntityField("is_virtual", DbType.bool),
      SqfEntityField("is_reloadable", DbType.bool),
      SqfEntityField("limit_groups", DbType.text),
    ];

    super.init();
  }
}
