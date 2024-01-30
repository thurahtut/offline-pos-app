// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const POS_SESSION_TABLE_NAME = "pos_session_table";
const POS_SESSION_NAME = "name";
const POS_SESSION_VALUE = "value";
const POS_SESSION_ID = "id";
const SESSION_NAME = "name";
const SESSION_USER_ID = "user_id";
const SESSION_CONFIG_ID = "config_id";
const START_AT = "start_at";
const STOP_AT = "stop_at";
const SESSION_SEQUENCE_NUMBER = "sequence_number";
const CASH_REGISTER_ID = "cash_register_id";
const SESSION_STATE = "state";
const UPDATE_STOCK_AT_CLOSING = "update_stock_at_closing";
const SESSION_PAYMENT_METHOD_IDS = "payment_method_ids";

class POSSessionTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $POS_SESSION_TABLE_NAME("
        "$POS_SESSION_NAME TEXT,"
        "$POS_SESSION_VALUE TEXT"
        ")");
  }

  static Future<int> insert(
      final Database db, String columnName, String? value) async {
    String sql = "INSERT INTO $POS_SESSION_TABLE_NAME("
        "$POS_SESSION_NAME, $POS_SESSION_VALUE"
        ")"
        " VALUES("
        "'$columnName','$value'"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }

  static Future<POSSession?> getAppSession() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      POS_SESSION_TABLE_NAME,
    );
    return convertPOSSession(maps);
  }

  static Future<bool> checkRowExist(
    final Database db,
    String columnName,
  ) async {
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        POS_SESSION_TABLE_NAME,
        where: "$POS_SESSION_NAME=?",
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
      String sql = "UPDATE $POS_SESSION_TABLE_NAME "
          "SET $POS_SESSION_NAME = '$columnName',"
          " $POS_SESSION_VALUE = '$value'";
      return db.rawInsert(sql);
    } else {
      return insert(db, columnName, value);
    }
  }

  static Future<void> insertOrUpdatePOSSession(POSSession posConfig) async {
    final Database db = await DatabaseHelper().db;
    return insertOrUpdatePOSSessionWithDB(db, posConfig);
  }

  static Future<void> insertOrUpdatePOSSessionWithDB(
      final Database db, POSSession posConfig) async {
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

  static POSSession convertPOSSession(List<Map<String, dynamic>> maps) {
    POSSession posSession = POSSession();
    for (var data in maps) {
      if (data[POS_SESSION_VALUE] != null &&
          data[POS_SESSION_VALUE] != "" &&
          data[POS_SESSION_VALUE] != "null") {
        if (data[POS_SESSION_NAME] == POS_SESSION_ID) {
          posSession.id = int.tryParse(data[POS_SESSION_VALUE]);
        } else if (data[POS_SESSION_NAME] == SESSION_NAME) {
          posSession.name = data[POS_SESSION_VALUE];
        } else if (data[POS_SESSION_NAME] == SESSION_USER_ID) {
          posSession.userId = int.tryParse(data[POS_SESSION_VALUE]);
        } else if (data[POS_SESSION_NAME] == SESSION_CONFIG_ID) {
          posSession.configId = int.tryParse(data[POS_SESSION_VALUE]);
        } else if (data[POS_SESSION_NAME] == START_AT) {
          posSession.startAt = data[POS_SESSION_VALUE];
        } else if (data[POS_SESSION_NAME] == STOP_AT) {
          posSession.stopAt = data[POS_SESSION_VALUE];
        } else if (data[POS_SESSION_NAME] == SESSION_SEQUENCE_NUMBER) {
          posSession.sequenceNumber = int.tryParse(data[POS_SESSION_VALUE]);
        } else if (data[POS_SESSION_NAME] == CASH_REGISTER_ID) {
          posSession.cashRegisterId = int.tryParse(data[POS_SESSION_VALUE]);
        } else if (data[POS_SESSION_NAME] == SESSION_STATE) {
          posSession.state = data[POS_SESSION_VALUE];
        } else if (data[POS_SESSION_NAME] == UPDATE_STOCK_AT_CLOSING) {
          posSession.updateStockAtClosing =
              bool.tryParse(data[POS_SESSION_VALUE]);
        } else if (data[POS_SESSION_NAME] == SESSION_PAYMENT_METHOD_IDS) {
          posSession.paymentMethodIds =
              jsonDecode(data[POS_SESSION_VALUE])?.cast<int>();
        }
      }
    }

    return posSession;
  }
}
