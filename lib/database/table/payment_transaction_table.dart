// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const PAYMENT_TRANSACTION_TABLE_NAME = "payment_transaction_table";
const PAYMENT_TRANSACTION_ID = "id";
const ORDER_ID_IN_TRAN = "order_id";
const PAYMENT_DATE = "payment_date";
const PAYMENT_METHOD_ID_TRAN = "payment_method_id";
const AMOUNT_IN_TRAN = "amount";

class PaymentTransactionTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PAYMENT_TRANSACTION_TABLE_NAME("
        "$PAYMENT_TRANSACTION_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ORDER_ID_IN_TRAN INTEGER NOT NULL,"
        "$PAYMENT_DATE TEXT NOT NULL,"
        "$PAYMENT_METHOD_ID_TRAN INTEGER NOT NULL,"
        "$AMOUNT_IN_TRAN REAL"
        ")");
  }

  static Future<int> insert(PaymentTransaction paymentTransaction) async {
    final Database db = await DatabaseHelper().db;
    String sql = "INSERT INTO $PAYMENT_TRANSACTION_TABLE_NAME("
        "$ORDER_ID_IN_TRAN, $PAYMENT_DATE, $PAYMENT_METHOD_ID_TRAN, $AMOUNT_IN_TRAN"
        ")"
        " VALUES("
        "${paymentTransaction.orderId}, '${paymentTransaction.paymentDate}', "
        "${paymentTransaction.paymentMethodId}, ${paymentTransaction.amount}"
        ")";

    return db.rawInsert(sql);
  }

  static Future<List<PaymentTransaction>?> getProductByProductId(
      int orderId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PAYMENT_TRANSACTION_TABLE_NAME,
      where: "$ORDER_ID_IN_TRAN=?",
      whereArgs: [orderId],
      limit: 1,
    );

    return List.generate(maps.length, (i) {
      return PaymentTransaction.fromJson(maps[i]);
    });
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

  static Future<int> deleteByOrderId(final Database db, int orderID) async {
    return db.delete(
      PAYMENT_TRANSACTION_TABLE_NAME,
      where: "$ORDER_ID_IN_TRAN=?",
      whereArgs: [orderID],
    );
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    insertOrUpdateWithDB(db, data);
  }

  static Future<void> insertOrUpdateWithDB(
      final Database db, List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    // var time = DateTime.now();
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
}
