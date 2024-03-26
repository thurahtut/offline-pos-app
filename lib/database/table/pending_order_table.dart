// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const PENDING_ORDER_TABLE_NAME = "pending_order_table";
const PENDING_NAME = "name";
const PENDING_VALUE = "value";
const PENDING_ORDER = "pending_order";
const CURRENT_ORDERS_LIST = "current_orders_list";

class PendingOrderTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PENDING_ORDER_TABLE_NAME("
        "$PENDING_NAME TEXT,"
        "$PENDING_VALUE TEXT"
        ")");
  }

  static Future<int> insert(
    final Database db,
    String columnName,
    String? value,
  ) async {
    String sql = "INSERT INTO $PENDING_ORDER_TABLE_NAME("
        "$PENDING_NAME, $PENDING_VALUE"
        ")"
        " VALUES("
        "'$columnName','$value'"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }

  static Future<OrderHistory?> getPendingOrder() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
        PENDING_ORDER_TABLE_NAME,
        columns: [PENDING_VALUE],
        where: "$PENDING_NAME=?",
        whereArgs: [PENDING_ORDER]);

    if (maps.isEmpty || maps.first[PENDING_VALUE] == "[]") {
      return null;
    }
    return OrderHistory.fromJson(jsonDecode(maps.first[PENDING_VALUE]));
  }

  static Future<List<Product>> getPendingCurrentOrderList() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
        PENDING_ORDER_TABLE_NAME,
        columns: [PENDING_VALUE],
        where: "$PENDING_NAME=?",
        whereArgs: [CURRENT_ORDERS_LIST]);

    if (maps.isEmpty) {
      return [];
    }
    List<dynamic> result = jsonDecode(maps.first[PENDING_VALUE]);
    return List.generate(result.length, (i) {
      Product product = Product.fromJson(result[i]);
      PriceListItem? priceListItem =
          PriceListItem.fromJson(result[i]["priceListItem"]);
      product.priceListItem = priceListItem;
      return product;
    });
  }

  static Future<bool> checkRowExist(
    Database? db,
    String name,
  ) async {
    db ??= await DatabaseHelper().db;
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        PENDING_ORDER_TABLE_NAME,
        where: "$PENDING_NAME=?",
        whereArgs: [name]);
    isExist = maps.isNotEmpty;
    return isExist;
  }

  static Future<int> insertOrUpdatePendingOrderWithDB({
    Database? db,
    required String value,
  }) async {
    db ??= await DatabaseHelper().db;
    if (await checkRowExist(db, PENDING_ORDER)) {
      String sql = "UPDATE $PENDING_ORDER_TABLE_NAME "
          "SET $PENDING_VALUE = '$value' "
          "WHERE $PENDING_NAME='$PENDING_ORDER'";
      return db.rawInsert(sql);
    } else {
      return insert(db, PENDING_ORDER, value);
    }
  }

  static Future<int> insertOrUpdateCurrentOrderListWithDB({
    Database? db,
    required String productList,
  }) async {
    db ??= await DatabaseHelper().db;
    if (await checkRowExist(db, CURRENT_ORDERS_LIST)) {
      String sql = "UPDATE $PENDING_ORDER_TABLE_NAME "
          "SET $PENDING_VALUE = '$productList' "
          "WHERE $PENDING_NAME='$CURRENT_ORDERS_LIST'";
      return db.rawInsert(sql);
    } else {
      return insert(db, CURRENT_ORDERS_LIST, productList);
    }
  }
}
