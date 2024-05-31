// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const APP_CONFIG_TABLE_NAME = "app_config_table";
const APP_CONFIG_NAME = "name";
const APP_CONFIG_VALUE = "value";
const THEME_BODY_COLOR = "theme_body_color";
const LOGO = "logo";
const DB_VERSION = "db_version";
const PRODUCT_LAST_SYNC_DATE = "product_last_sync_date";
const PRICE_LAST_SYNC_DATE = "price_last_sync_date";
const CUSTOMER_LAST_SYNC_DATE = "customer_last_sync_date";
const PACKAGING_LAST_SYNC_DATE = "packaging_last_sync_date";
const REMEMBER_PASSWORD = "remember_password";
const STORAGE_START_DATE = "storage_start_date";

class AppConfigTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $APP_CONFIG_TABLE_NAME("
        "$APP_CONFIG_NAME TEXT UNIQUE,"
        "$APP_CONFIG_VALUE TEXT"
        ")");
  }

  static Future<int> insert(
      final Database db, String columnName, String? value) async {
    String sql = "INSERT INTO $APP_CONFIG_TABLE_NAME("
        "$APP_CONFIG_NAME, $APP_CONFIG_VALUE"
        ")"
        " VALUES("
        "'$columnName','$value'"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }

  static Future<AppConfig?> getAppConfig() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      APP_CONFIG_TABLE_NAME,
    );
    return convertAppConfig(maps);
  }

  static Future<bool> checkRowExist(
    final Database db,
    String columnName,
  ) async {
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        APP_CONFIG_TABLE_NAME,
        where: "$APP_CONFIG_NAME=?",
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
      String sql = "UPDATE $APP_CONFIG_TABLE_NAME "
          "SET $APP_CONFIG_VALUE = '$value' "
          "WHERE $APP_CONFIG_NAME = '$columnName'";
      return db.rawInsert(sql);
    } else {
      return insert(db, columnName, value);
    }
  }

  static AppConfig convertAppConfig(List<Map<String, dynamic>> maps) {
    AppConfig appConfig = AppConfig();
    for (var data in maps) {
      if (data[APP_CONFIG_NAME] == THEME_BODY_COLOR) {
        appConfig.themeBodyColor = data[APP_CONFIG_VALUE];
      } else if (data[APP_CONFIG_NAME] == LOGO) {
        if (data[APP_CONFIG_VALUE] != null && data[APP_CONFIG_VALUE] != "") {
          try {
            var outputAsUint8List =
                Uint8List.fromList(base64Decode(data[APP_CONFIG_VALUE]));
            appConfig.logo = outputAsUint8List;
          } catch (_) {}
        }
      } else if (data[APP_CONFIG_NAME] == DB_VERSION) {
        appConfig.dbVersion = data[APP_CONFIG_VALUE];
      } else if (data[APP_CONFIG_NAME] == STORAGE_START_DATE) {
        appConfig.storageStartDate = data[APP_CONFIG_VALUE];
      }
    }
    return appConfig;
  }

  static Future<void> deleteByColumnName(String columnName) async {
    final Database db = await DatabaseHelper().db;
    db.rawQuery(
        "delete from $APP_CONFIG_TABLE_NAME where $APP_CONFIG_NAME='$columnName';");
  }
}
