// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const LOGIN_USER_TABLE_NAME = "login_user_table";
const LOGIN_NAME = "name";
const LOGIN_VALUE = "value";
const USER_DATA = "user_data";
const PARTNER_DATA = "partner_data";
const EMPLOYEE_DATA = "employee_data";
const CONFIG_DATA = "config_data";

class LoginUserTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $LOGIN_USER_TABLE_NAME("
        "$LOGIN_NAME TEXT,"
        "$LOGIN_VALUE TEXT"
        ")");
  }

  static Future<int> insert(
      final Database db, String columnName, String? value) async {
    String sql = "INSERT INTO $LOGIN_USER_TABLE_NAME("
        "$LOGIN_NAME, $LOGIN_VALUE"
        ")"
        " VALUES("
        "'$columnName','$value'"
        ")";
    int inq = await db.rawInsert(sql);
    return inq;
  }

  static Future<User?> getLoginUser() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      LOGIN_USER_TABLE_NAME,
    );
    return convertUser(maps);
  }

  static Future<bool> checkRowExist(
    String columnName,
  ) async {
    final Database db = await DatabaseHelper().db;
    return checkRowExistWithDb(db, columnName);
  }

  static Future<bool> checkRowExistWithDb(
    final Database db,
    String columnName,
  ) async {
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        LOGIN_USER_TABLE_NAME,
        where: "$LOGIN_NAME=?",
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
    if (await checkRowExistWithDb(db, columnName)) {
      String sql = "UPDATE $LOGIN_USER_TABLE_NAME "
          "SET $LOGIN_NAME = '$columnName',"
          " $LOGIN_VALUE = '$value'";
      return db.rawInsert(sql);
    } else {
      return insert(db, columnName, value);
    }
  }

  static Future<void> insertOrUpdateUser(User user) async {
    final Database db = await DatabaseHelper().db;
    Map<String, dynamic> jsonOfUser = user.toJson();
    for (MapEntry<String, dynamic> element in jsonOfUser.entries) {
      int result = await insertOrUpdateWithDB(db, element.key,
          element.value != null ? jsonEncode(element.value) : null);
      log(result.toString());
    }
  }

  static Future<void> insertOrUpdateUserWithDB(
      final Database db, User user) async {
    Map<String, dynamic> jsonOfUser = user.toJson();
    for (MapEntry<String, dynamic> element in jsonOfUser.entries) {
      insertOrUpdateWithDB(db, element.key,
          element.value != null ? jsonEncode(element.value) : null);
    }
  }

  static User convertUser(List<Map<String, dynamic>> maps) {
    User loginUser = User();
    for (var data in maps) {
      if (data[LOGIN_VALUE] != null &&
          data[LOGIN_VALUE] != "" &&
          data[LOGIN_VALUE] != "null") {
        if (data[LOGIN_NAME] == USER_DATA) {
          loginUser.userData = UserData.fromJson(jsonDecode(data[LOGIN_VALUE]));
        } else if (data[LOGIN_NAME] == PARTNER_DATA) {
          loginUser.partnerData =
              PartnerData.fromJson(jsonDecode(data[LOGIN_VALUE]));
        } else if (data[LOGIN_NAME] == EMPLOYEE_DATA) {
          loginUser.employeeData =
              Employee.fromJson(jsonDecode(data[LOGIN_VALUE]));
        } else if (data[LOGIN_NAME] == CONFIG_DATA) {
          loginUser.configData = [];
          jsonDecode(data[LOGIN_VALUE]).forEach((v) {
            loginUser.configData!.add(ConfigData.fromJson(v));
          });
        }
      }
    }
    return loginUser;
  }
}
