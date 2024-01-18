// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

const ORDER_AND_PAYMENT_TRANSACTION_TABLE_NAME = "order_and_pay_tran_table";
const ORDER_AND_PAYMENT_TRANSACTION_ID = "id";
const ORDER_ID_IN_OL = "order_id";
const TRANSACTION_IN_OL = "tran_id";

class OrderAndPaymentTransactionTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_AND_PAYMENT_TRANSACTION_TABLE_NAME("
        "$ORDER_AND_PAYMENT_TRANSACTION_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ORDER_ID_IN_OL INTEGER NOT NULL,"
        "$TRANSACTION_IN_OL INTEGER NOT NULL"
        ")");
  }

  static Future<int> insert(final Database db, int orderId, int tranId) async {
    String sql = "INSERT INTO $ORDER_AND_PAYMENT_TRANSACTION_TABLE_NAME("
        "$ORDER_ID_IN_OL, $TRANSACTION_IN_OL"
        ")"
        " VALUES("
        "$orderId, $tranId"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }
}
