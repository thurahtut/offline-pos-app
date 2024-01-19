// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const PAYMENT_METHOD_TABLE_NAME = "payment_method_table";
const PAYMENT_METHOD_ID = "id";
const PAYMENT_METHOD_NAME = "name";
const OUTSTANDING_ACCOUNT_ID = "outstanding_account_id";
const RECEIVABLE_ACCOUNT_ID = "receivable_account_id";
const IS_CASH_COUNT = "is_cash_count";
const JOURNAL_ID = "journal_id";
const SPLIT_TRANSACTIONS = "split_transactions";
const COMPANY_ID_IN_PMT = "company_id";
const USE_PAYMENT_TERMINAL = "use_payment_terminal";
const ACTIVE = "active";
const CREATE_UID_IN_PMT = "create_uid";
const CREATE_DATE_IN_PMT = "create_date";
const WRITE_UID_IN_PMT = "write_uid";
const WRITE_DATE_IN_PMT = "write_date";
const WALLET_METHOD = "wallet_method";
const FOR_POINTS = "for_points";

class PaymentMethodTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PAYMENT_METHOD_TABLE_NAME("
        "$PAYMENT_METHOD_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PAYMENT_METHOD_NAME TEXT,"
        "$OUTSTANDING_ACCOUNT_ID INTEGER,"
        "$RECEIVABLE_ACCOUNT_ID INTEGER,"
        "$IS_CASH_COUNT TEXT,"
        "$JOURNAL_ID INTEGER,"
        "$SPLIT_TRANSACTIONS TEXT,"
        "$COMPANY_ID_IN_PMT INTEGER,"
        "$USE_PAYMENT_TERMINAL TEXT,"
        "$ACTIVE TEXT,"
        "$CREATE_UID_IN_PMT INTEGER,"
        "$CREATE_DATE_IN_PMT TEXT,"
        "$WRITE_UID_IN_PMT INTEGER,"
        "$WRITE_DATE_IN_PMT TEXT,"
        "$WALLET_METHOD TEXT,"
        "$FOR_POINTS TEXT"
        ")");
  }

  static Future<int> insert(PaymentMethod productMethod) async {
    final Database db = await DatabaseHelper().db;

    String sql = "INSERT INTO $PAYMENT_METHOD_TABLE_NAME("
        "${productMethod.id != null && productMethod.id != 0 ? "$PAYMENT_METHOD_ID," : ""}"
        "$PAYMENT_METHOD_NAME, $OUTSTANDING_ACCOUNT_ID, $RECEIVABLE_ACCOUNT_ID, "
        "$IS_CASH_COUNT, $JOURNAL_ID, $SPLIT_TRANSACTIONS, "
        "$COMPANY_ID_IN_PMT, $USE_PAYMENT_TERMINAL, $ACTIVE, "
        "$CREATE_UID_IN_PMT, $CREATE_DATE_IN_PMT, $WRITE_UID_IN_PMT, "
        "$WRITE_DATE_IN_PMT, $WALLET_METHOD, $FOR_POINTS"
        ")"
        " VALUES("
        "${productMethod.id != null && productMethod.id != 0 ? "${productMethod.id}," : ""}"
        "'${productMethod.name}', ${productMethod.outstandingAccountId}, ${productMethod.receivableAccountId}, "
        "'${productMethod.isCashCount?.toString()}', ${productMethod.journalId}, '${productMethod.splitTransactions?.toString()}', "
        "${productMethod.companyId}, '${productMethod.usePaymentTerminal?.toString()}', '${productMethod.active?.toString()}', "
        "${productMethod.createUid}, '${productMethod.createDate}', ${productMethod.writeUid}, "
        "'${productMethod.writeDate}', '${productMethod.walletMethod?.toString()}', '${productMethod.forPoints?.toString()}', "
        ")";

    return db.rawInsert(sql);
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();

    int index = 0;
    for (final element in data) {
      PaymentMethod paymentMethod = PaymentMethod.fromJson(element);
      batch.insert(
        PAYMENT_METHOD_TABLE_NAME,
        paymentMethod.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (index % 1000 == 0) {
        await batch.commit(noResult: true);
        batch = db.batch();
      }
      index++;
    }

    await batch.commit(noResult: true);
  }

  static Future<List<PaymentMethod>?> getActivePaymentMethod() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PAYMENT_METHOD_TABLE_NAME,
      where: "$ACTIVE=?",
      whereArgs: ["true"],
      orderBy: '$PAYMENT_METHOD_ID ASC',
    );
    return List.generate(maps.length, (i) {
      return PaymentMethod.fromJson(maps[i]);
    });
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $PAYMENT_METHOD_TABLE_NAME");
  }
}
