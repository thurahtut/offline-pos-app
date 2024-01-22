// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/order_line_id.dart';
import 'package:sqflite/sqflite.dart';

const ORDER_LINE_ID_TABLE_NAME = "order_line_id_table";
const ORDER_LINE_ID = "id";
const ORDER_ID_IN_LINE = "order_id";
const PRODUCT_ID_IN_LINE = "product_id";
const QTY_IN_LINE = "qty";
const PRICE_UNIT = "price_unit";
const PRICE_SUBTOTAL = "price_subtotal";
const PRICE_SUBTOTAL_INCL = "price_subtotal_incl";

class OrderLineIdTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_LINE_ID_TABLE_NAME("
        "$ORDER_LINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ORDER_ID_IN_LINE INTEGER NOT NULL,"
        "$PRODUCT_ID_IN_LINE INTEGER NOT NULL,"
        "$QTY_IN_LINE INTEGER NOT NULL,"
        "$PRICE_UNIT REAL NOT NULL,"
        "$PRICE_SUBTOTAL REAL NOT NULL,"
        "$PRICE_SUBTOTAL_INCL REAL NOT NULL"
        ")");
  }

  static Future<int> insert(OrderLineID orderLine) async {
    final Database db = await DatabaseHelper().db;
    String sql = "INSERT INTO $ORDER_LINE_ID_TABLE_NAME("
        "${orderLine.id != null && orderLine.id != 0 ? "$ORDER_LINE_ID," : ""}"
        "$ORDER_ID_IN_LINE,"
        "$PRODUCT_ID_IN_LINE,"
        "$QTY_IN_LINE,"
        "$PRICE_UNIT,"
        "$PRICE_SUBTOTAL,"
        "$PRICE_SUBTOTAL_INCL"
        ")"
        " VALUES("
        "${orderLine.id != null && orderLine.id != 0 ? "${orderLine.id}," : ""}"
        "${orderLine.orderId}, "
        "${orderLine.productId}, "
        "${orderLine.qty}, "
        "${orderLine.priceUnit}, "
        "${orderLine.priceSubtotal}, "
        "${orderLine.priceSubtotalIncl}"
        ")";

    return db.rawInsert(sql);
  }

  static Future<List<OrderLineID>?> getOrderLinesByOrderId(int orderId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      ORDER_LINE_ID_TABLE_NAME,
      where: "$ORDER_ID_IN_LINE=?",
      whereArgs: [orderId],
      limit: 1,
    );

    return List.generate(maps.length, (i) {
      return OrderLineID.fromJson(maps[i]);
    });
  }

  static Future<int> update(OrderLineID orderLineID) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      ORDER_LINE_ID_TABLE_NAME,
      orderLineID.toJson(),
      where: "$ORDER_LINE_ID=?",
      whereArgs: [orderLineID.id],
    );
  }

  static Future<int> deleteByOrderIdAndPId(int orderID, int productId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      ORDER_LINE_ID_TABLE_NAME,
      where: "$ORDER_ID_IN_LINE=? and $PRODUCT_ID_IN_LINE=?",
      whereArgs: [orderID, productId],
    );
  }

  static Future<int> deleteByOrderId(final Database db, int orderID) async {
    return db.delete(
      ORDER_LINE_ID_TABLE_NAME,
      where: "$ORDER_ID_IN_LINE=?",
      whereArgs: [orderID],
    );
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    // var time = DateTime.now();
    int index = 0;
    for (final element in data) {
      OrderLineID orderLineId =
          element is OrderLineID ? element : OrderLineID.fromJson(element);
      batch.insert(
        ORDER_LINE_ID_TABLE_NAME,
        orderLineId.toJson(),
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
