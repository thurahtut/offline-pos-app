// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const PAYMENT_TRANSACTION_TABLE_NAME = "payment_transaction_table";
const PAYMENT_TRANSACTION_ID = "id";
const ORDER_ID_IN_TRAN = "order_id";
const PAYMENT_DATE = "payment_date";
const PAYMENT_METHOD_ID_TRAN = "payment_method_id";
const AMOUNT_IN_TRAN = "amount";
const CARD_TYPE = "card_type";
const CARD_HOLDER_NAME = "cardholder_name";
const CREATE_DATE_IN_TRAN = "create_date";
const CREATE_UID_IN_TRAN = "create_uid";
const IS_CHANGE = "is_change";
const PAYMENT_STATUS = "payment_status";
const SESSION_ID_IN_TRAN = "session_id";
const TICKET = "ticket";
const TRANSACTION_ID = "transaction_id";
const WRITE_DATE_IN_TRAN = "write_date";
const WRITE_UID_IN_TRAN = "write_uid";

class PaymentTransactionTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PAYMENT_TRANSACTION_TABLE_NAME("
        "$PAYMENT_TRANSACTION_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ORDER_ID_IN_TRAN INTEGER NOT NULL,"
        "$PAYMENT_DATE TEXT NOT NULL,"
        "$PAYMENT_METHOD_ID_TRAN INTEGER NOT NULL,"
        "$AMOUNT_IN_TRAN REAL,"
        "$CARD_TYPE TEXT,"
        "$CARD_HOLDER_NAME TEXT,"
        "$CREATE_DATE_IN_TRAN TEXT NOT NULL,"
        "$CREATE_UID_IN_TRAN INTEGER NOT NULL,"
        "$IS_CHANGE TEXT,"
        "$PAYMENT_STATUS TEXT,"
        "$SESSION_ID_IN_TRAN INTEGER NOT NULL,"
        "$TICKET TEXT,"
        "$TRANSACTION_ID TEXT,"
        "$WRITE_DATE_IN_TRAN TEXT,"
        "$WRITE_UID_IN_TRAN INTEGER"
        ")");
  }

  static Future<int> insertWithDb(
    final Database db,
    PaymentTransaction paymentTransaction,
  ) async {
    return db.insert(
        PAYMENT_TRANSACTION_TABLE_NAME, paymentTransaction.toJson());
  }

  static Future<int> update(PaymentTransaction paymentTransaction) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      PAYMENT_TRANSACTION_TABLE_NAME,
      paymentTransaction.toJson(),
      where: "$PAYMENT_TRANSACTION_ID=?",
      whereArgs: [paymentTransaction.id],
    );
  }

  static Future<int> delete(int orderID, int paymentMethodId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      PAYMENT_TRANSACTION_TABLE_NAME,
      where: "$ORDER_ID_IN_TRAN=? and $PAYMENT_METHOD_ID_TRAN=?",
      whereArgs: [orderID, paymentMethodId],
    );
  }

  static Future<int> deleteByOrderId({
    Database? db,
    Transaction? txn,
    required int orderID,
  }) async {
    if (txn != null) {
      return txn.delete(
        PAYMENT_TRANSACTION_TABLE_NAME,
        where: "$ORDER_ID_IN_TRAN=?",
        whereArgs: [orderID],
      );
    } else {
      db ??= await DatabaseHelper().db;
      return db.delete(
        PAYMENT_TRANSACTION_TABLE_NAME,
        where: "$ORDER_ID_IN_TRAN=?",
        whereArgs: [orderID],
      );
    }
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    insertOrUpdateWithDB(db, data);
  }

  static Future<void> insertOrUpdateWithDB(
      final Database db, List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      PaymentTransaction paymentTransaction = element is PaymentTransaction
          ? element
          : PaymentTransaction.fromJson(element);
      batch.insert(
        PAYMENT_TRANSACTION_TABLE_NAME,
        paymentTransaction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (index % 1000 == 0) {
        await batch.commit(noResult: true);
        batch = db.batch();
      }
      index++;
    }
  }

  static Future<List<Map<String, dynamic>>> getTotalTransactionSummary(
      int sessionId) async {
    final Database db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select sum($AMOUNT_IN_TRAN) as tPaid, "
            "$PAYMENT_METHOD_ID_TRAN as id "
            // ",$PAYMENT_METHOD_NAME as name "
            "from $PAYMENT_TRANSACTION_TABLE_NAME ptt "
            // "left join $PAYMENT_METHOD_TABLE_NAME pmt "
            // "on pmt.$PAYMENT_METHOD_ID = ptt.$PAYMENT_METHOD_ID_TRAN "
            // "left join $ORDER_HISTORY_TABLE_NAME oht "
            // "on oht.$ORDER_HISTORY_ID = $ORDER_ID_IN_TRAN "
            "where ptt.$SESSION_ID_IN_TRAN=$sessionId "
            // "and oht.$ORDER_CONDITION<>'${OrderCondition.sync.text}' "
            // " where order_id =1 "
            "group by $PAYMENT_METHOD_ID_TRAN");

    // List<Map<String, double>> convertedList = maps.map((originalMap) {
    //   return originalMap.map((key, value) {
    //     return MapEntry(key,
    //         value is double ? value : double.tryParse(value.toString()) ?? 0.0);
    //   });
    // }).toList();

    return maps;
  }

  static Future<List<Map<String, dynamic>>> getTotalTransactionSummaryWithName(
      int sessionId) async {
    final Database db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select sum($AMOUNT_IN_TRAN) as tPaid, "
            "$PAYMENT_METHOD_ID_TRAN as id "
            ",$PAYMENT_METHOD_NAME as name "
            "from $PAYMENT_TRANSACTION_TABLE_NAME ptt "
            "left join $PAYMENT_METHOD_TABLE_NAME pmt "
            "on pmt.$PAYMENT_METHOD_ID = ptt.$PAYMENT_METHOD_ID_TRAN "
            // "left join $ORDER_HISTORY_TABLE_NAME oht "
            // "on oht.$ORDER_HISTORY_ID = $ORDER_ID_IN_TRAN "
            "where ptt.$SESSION_ID_IN_TRAN=$sessionId "
            // "and oht.$ORDER_CONDITION<>'${OrderCondition.sync.text}' "
            // " where order_id =1 "
            "group by $PAYMENT_METHOD_ID_TRAN");

    // List<Map<String, double>> convertedList = maps.map((originalMap) {
    //   return originalMap.map((key, value) {
    //     return MapEntry(key,
    //         value is double ? value : double.tryParse(value.toString()) ?? 0.0);
    //   });
    // }).toList();

    return maps;
  }

  static Future<Map<int, PaymentTransaction>>
      getPaymentTransactionListByOrderId(int orderId) async {
    final Database db = await DatabaseHelper().db;
    String query = "select pt.*, pm.$PAYMENT_METHOD_NAME "
        "from $PAYMENT_TRANSACTION_TABLE_NAME pt "
        "left join $PAYMENT_METHOD_TABLE_NAME pm "
        "on pm.$PAYMENT_METHOD_ID = pt.$PAYMENT_METHOD_ID_TRAN "
        "where pt.$ORDER_ID_IN_TRAN=$orderId";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    Map<int, PaymentTransaction> map = {};
    List.generate(maps.length, (i) {
      PaymentTransaction paymentTransaction =
          PaymentTransaction.fromJson(maps[i]);
      paymentTransaction.paymentMethodName = maps[i][PAYMENT_METHOD_NAME];
      map[paymentTransaction.paymentMethodId ?? 0] = paymentTransaction;
    });

    return map;
  }
}
