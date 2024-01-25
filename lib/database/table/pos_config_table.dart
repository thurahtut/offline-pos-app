// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const POS_CONFIG_TABLE_NAME = "pos_config_table";
const POS_CONFIG_NAME = "name";
const POS_CONFIG_VALUE = "value";
const POS_CONFIG_ID = "id";
const CONFIG_NAME = "name";
const CONFIG_PRICELIST_ID = "pricelist_id";
const SH_DISPLAY_STOCK = "sh_display_stock";
const SH_SHOW_QTY_LOCATION = "sh_show_qty_location";
const SH_POS_LOCATION = "sh_pos_location";
const CONFIG_PAYMENT_METHOD_IDS = "payment_method_ids";

class POSConfigTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $POS_CONFIG_TABLE_NAME("
        "$POS_CONFIG_NAME TEXT,"
        "$POS_CONFIG_VALUE TEXT"
        ")");
  }

  static Future<int> insert(
      final Database db, String columnName, String? value) async {
    String sql = "INSERT INTO $POS_CONFIG_TABLE_NAME("
        "$POS_CONFIG_NAME, $POS_CONFIG_VALUE"
        ")"
        " VALUES("
        "'$columnName','$value'"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }

  static Future<POSConfig?> getAppConfig() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      POS_CONFIG_TABLE_NAME,
    );
    return convertPosConfig(maps);
  }

  static Future<bool> checkRowExist(
    final Database db,
    String columnName,
  ) async {
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        POS_CONFIG_TABLE_NAME,
        where: "$POS_CONFIG_NAME=?",
        whereArgs: [columnName]);
    isExist = maps.isNotEmpty;
    return isExist;
  }

  static Future<int> insertOrUpdate(String columnName, String? value) async {
    final Database db = await DatabaseHelper().db;
    return insertOrUpdateWithDB(db, columnName, value);
  }

  static Future<int> insertOrUpdateWithDB(
      final Database db, String columnName, String? value) async {
    if (await checkRowExist(db, columnName)) {
      String sql = "UPDATE $POS_CONFIG_TABLE_NAME "
          "SET $POS_CONFIG_NAME = '$columnName',"
          " $POS_CONFIG_VALUE = '$value'";
      return db.rawInsert(sql);
    } else {
      return insert(db, columnName, value);
    }
  }

  static Future<void> insertOrUpdatePosConfigWithDB(
      final Database db, POSConfig posConfig) async {
    Map<String, dynamic> jsonOfConfig = posConfig.toJson();
    for (MapEntry<String, dynamic> element in jsonOfConfig.entries) {
      if (element.value is int ||
          element.value is double ||
          element.value is bool) {
        insertOrUpdateWithDB(db, element.key, element.value?.toString());
      } else if (element.value is List ||
          element.value is Map<String, dynamic>) {
        insertOrUpdateWithDB(db, element.key,
            element.value != null ? jsonEncode(element.value) : null);
      } else {
        insertOrUpdateWithDB(db, element.key, element.value);
      }
    }
  }

  static POSConfig convertPosConfig(List<Map<String, dynamic>> maps) {
    POSConfig posConfig = POSConfig();
    for (var data in maps) {
      if (data[POS_CONFIG_VALUE] != null &&
          data[POS_CONFIG_VALUE] != "" &&
          data[POS_CONFIG_VALUE] != "null") {
        if (data[POS_CONFIG_NAME] == POS_CONFIG_ID) {
          posConfig.id = int.tryParse(data[POS_CONFIG_VALUE]);
        } else if (data[POS_CONFIG_NAME] == CONFIG_NAME) {
          posConfig.name = data[POS_CONFIG_VALUE];
        } else if (data[POS_CONFIG_NAME] == CONFIG_PRICELIST_ID) {
          posConfig.pricelistId = int.tryParse(data[POS_CONFIG_VALUE]);
        } else if (data[POS_CONFIG_NAME] == SH_DISPLAY_STOCK) {
          posConfig.shDisplayStock = bool.tryParse(data[POS_CONFIG_VALUE]);
        } else if (data[POS_CONFIG_NAME] == SH_SHOW_QTY_LOCATION) {
          posConfig.shShowQtyLocation = bool.tryParse(data[POS_CONFIG_VALUE]);
        } else if (data[POS_CONFIG_NAME] == SH_POS_LOCATION) {
          posConfig.shPosLocation = int.tryParse(data[POS_CONFIG_VALUE]);
        } else if (data[POS_CONFIG_NAME] == CONFIG_PAYMENT_METHOD_IDS) {
          posConfig.paymentMethodIds =
              jsonDecode(data[POS_CONFIG_VALUE])?.cast<int>();
        }
      }
    }

    return posConfig;
  }
}
