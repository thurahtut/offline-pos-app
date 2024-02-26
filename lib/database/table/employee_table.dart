// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const EMPLOYEE_TABLE_NAME = "employee_table";
const EMPLOYEE_ID = "id";
const NAME_IN_ET = "name";
const PIN = "pin";
const WORK_EMAIL = "work_email";
const WORK_PHONE = "work_phone";
const JOB_TITLE = "job_title";

class EmployeeTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $EMPLOYEE_TABLE_NAME("
        "$EMPLOYEE_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$NAME_IN_ET TEXT,"
        "$PIN TEXT,"
        "$WORK_EMAIL TEXT,"
        "$WORK_PHONE TEXT,"
        "$JOB_TITLE TEXT"
        ")");
  }

  static Future<int> insert(Employee employee) async {
    final Database db = await DatabaseHelper().db;
    return db.insert(EMPLOYEE_TABLE_NAME, employee.toJson());
  }

  static Future<void> insertOrUpdateWithDB(
      final Database db, List<dynamic> data) async {
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      Employee employee =
          element is Employee ? element : Employee.fromJson(element);
      batch.insert(
        EMPLOYEE_TABLE_NAME,
        employee.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (index % 1000 == 0) {
        await batch.commit(noResult: true);
        batch = db.batch();
      }
      index++;
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Employee>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      EMPLOYEE_TABLE_NAME,
      orderBy: '$EMPLOYEE_ID DESC',
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Employee.fromJson(maps[i]);
    });
  }

  static Future<List<Employee>> getEmployeeWithFilter(String filter) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $EMPLOYEE_TABLE_NAME "
            "where $NAME_IN_ET like '%$filter%'");

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Employee.fromJson(maps[i]);
    });
  }

  static Future<Employee?> getEmployeeByEmployeeId(int employeeId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      EMPLOYEE_TABLE_NAME,
      where: "$EMPLOYEE_ID=?",
      whereArgs: [employeeId],
      limit: 1,
    );

    return Employee.fromJson(maps.first);
  }

  static Future<Employee?> checkEmployeeWithIdAndPassword(
      int employeeId, String password) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $EMPLOYEE_TABLE_NAME "
            "where $EMPLOYEE_ID='$employeeId' "
            "and $PIN='$password'");

    return maps.isEmpty ? null : Employee.fromJson(maps.first);
  }

  static Future<int> delete(int employeeId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      EMPLOYEE_TABLE_NAME,
      where: "$EMPLOYEE_ID=?",
      whereArgs: [employeeId],
    );
  }

  static Future<int> update(Employee employee) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      EMPLOYEE_TABLE_NAME,
      employee.toJson(),
      where: "$EMPLOYEE_ID=?",
      whereArgs: [employee.id],
    );
  }
}
