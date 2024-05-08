// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const ORDER_LINE_ID_TABLE_NAME = "order_line_id_table";
const ORDER_LINE_ID = "f_id";
const ORDER_ID_IN_LINE = "order_id";
const PRODUCT_ID_IN_LINE = "product_id";
const QTY_IN_LINE = "qty";
const PRICE_UNIT = "price_unit";
const PRICE_SUBTOTAL = "price_subtotal";
const PRICE_SUBTOTAL_INCL = "price_subtotal_incl";
const FULL_PRODUCT_NAME = "full_product_name";
const CREATE_DATE_IN_LINE = "create_date";
const CREATE_UID_IN_LINE = "create_uid";
const DISCOUNT_IN_LINE = "discount";
const WRITE_DATE_IN_LINE = "write_date";
const WRITE_UID_IN_LINE = "write_uid";
const PARENT_PROMOTION_ID = "parent_promotion_id";
const IS_PROMO_ITEM = "is_promo_item";
const ON_ORDER_ITEM = "on_order_item";
const SH_DISCOUNT_CODE = "sh_discount_code";
const SH_DISCOUNT_REASON = "sh_discount_reason";
const REFERENCE_ORDER_LINE_ID = "reference_orderline_id";
const REFUNDED_ORDER_LINE_ID = "refunded_orderline_id";
const ODOO_ORDER_LINE_ID = "odoo_order_line_id";

class OrderLineIdTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_LINE_ID_TABLE_NAME("
        "$ORDER_LINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ORDER_ID_IN_LINE INTEGER NOT NULL,"
        "$PRODUCT_ID_IN_LINE INTEGER NOT NULL,"
        "$QTY_IN_LINE INTEGER NOT NULL,"
        "$PRICE_UNIT REAL NOT NULL,"
        "$PRICE_SUBTOTAL REAL NOT NULL,"
        "$PRICE_SUBTOTAL_INCL REAL NOT NULL,"
        "$FULL_PRODUCT_NAME TEXT NOT NULL,"
        "$CREATE_DATE_IN_LINE TEXT NOT NULL,"
        "$CREATE_UID_IN_LINE INTEGER NOT NULL,"
        "$DISCOUNT_IN_LINE INTEGER,"
        "$WRITE_DATE_IN_LINE TEXT,"
        "$WRITE_UID_IN_LINE INTEGER,"
        "$PARENT_PROMOTION_ID INTEGER,"
        "$IS_PROMO_ITEM TEXT,"
        "$ON_ORDER_ITEM TEXT,"
        "$SH_DISCOUNT_CODE TEXT,"
        "$SH_DISCOUNT_REASON TEXT,"
        "$REFERENCE_ORDER_LINE_ID INTEGER,"
        "$REFUNDED_ORDER_LINE_ID INTEGER,"
        "$ODOO_ORDER_LINE_ID INTEGER"
        ")");
  }

  static Future<int> insert(
      {Database? db, required OrderLineID orderLine}) async {
    Database db = await DatabaseHelper().db;
    return db.insert(
        ORDER_LINE_ID_TABLE_NAME, orderLine.toJson(isOnlyForDatabase: true));
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

  static Future<int> update(
      {Database? db, required OrderLineID orderLineID}) async {
    db ??= await DatabaseHelper().db;

    return db.update(
      ORDER_LINE_ID_TABLE_NAME,
      orderLineID.toJson(isOnlyForDatabase: true),
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

  static Future<int> deleteByOrderId({
    Database? db,
    Transaction? txn,
    required int orderID,
  }) async {
    if (txn != null) {
      return txn.delete(
        ORDER_LINE_ID_TABLE_NAME,
        where: "$ORDER_ID_IN_LINE=?",
        whereArgs: [orderID],
      );
    } else {
      db ??= await DatabaseHelper().db;
      return db.delete(
        ORDER_LINE_ID_TABLE_NAME,
        where: "$ORDER_ID_IN_LINE=?",
        whereArgs: [orderID],
      );
    }
  }

  static Future<void> insertOrUpdateBatch(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
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

  static Future<bool> checkRowExist(
    Database? db,
    int orderLineId,
  ) async {
    db ??= await DatabaseHelper().db;
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        ORDER_LINE_ID_TABLE_NAME,
        where: "$ORDER_LINE_ID=?",
        whereArgs: [orderLineId]);
    isExist = maps.isNotEmpty;
    return isExist;
  }

  static Future<int> insertOrUpdate(
      {Database? db, required OrderLineID orderLineID}) async {
    if (await checkRowExist(db, orderLineID.id ?? 0)) {
      return update(db: db, orderLineID: orderLineID);
    } else {
      return insert(db: db, orderLine: orderLineID);
    }
  }

  static Future<Map<String, dynamic>?> getDiscountAmtAndFOC(
      {Database? db, required int sessionId}) async {
    db ??= await DatabaseHelper().db;
    String query = "select "
        "sum(case when olt.$DISCOUNT_IN_LINE <> 100 then (CAST(olt.$PRICE_UNIT AS REAL) * (CAST(olt.$DISCOUNT_IN_LINE AS REAL)/100)) else 0 end ) as disco, "
        "sum(case when olt.$DISCOUNT_IN_LINE <> 100 then 0 else (CAST(olt.$PRICE_UNIT AS REAL) * (CAST(olt.$DISCOUNT_IN_LINE AS REAL)/100)) end ) as foc "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join $ORDER_LINE_ID_TABLE_NAME olt "
        "on olt.$ORDER_ID_IN_LINE = ot.$ORDER_HISTORY_ID "
        "where ot.$SESSION_ID=$sessionId "
        "and ot.$STATE_IN_OT='${OrderState.paid.text}' ";

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return maps.isEmpty ? null : maps.first;
  }

  static Future<int> updateValue({
    Database? db,
    required String whereColumnName,
    int? whereValue,
    required String columnName,
    int? value,
  }) async {
    db ??= await DatabaseHelper().db;
    String sql = "UPDATE $ORDER_LINE_ID_TABLE_NAME "
        "SET $columnName = $value"
        " Where $whereColumnName = $whereValue";
    return db.rawInsert(sql);
  }
}
