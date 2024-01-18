// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

const ORDER_AND_ORDER_LINE_TABLE_NAME = "order_and_order_line_table";
const ORDER_AND_ORDER_LINE_ID = "id";
const ORDER_ID_IN_OL = "order_id";
const LINE_IN_OL = "line_id";

class OrderAndOrderLineTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_AND_ORDER_LINE_TABLE_NAME("
        "$ORDER_AND_ORDER_LINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ORDER_ID_IN_OL INTEGER NOT NULL,"
        "$LINE_IN_OL INTEGER NOT NULL"
        ")");
  }

  static Future<int> insert(final Database db, int orderId, int lineId) async {
    String sql = "INSERT INTO $ORDER_AND_ORDER_LINE_TABLE_NAME("
        "$ORDER_ID_IN_OL, $LINE_IN_OL"
        ")"
        " VALUES("
        "$orderId, $lineId"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }
}
