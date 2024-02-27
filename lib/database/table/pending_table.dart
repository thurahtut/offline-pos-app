// // ignore_for_file: constant_identifier_names

// import 'package:offline_pos/components/export_files.dart';
// import 'package:sqflite/sqflite.dart';

// const PENDING_ORDER_TABLE_NAME = "pending_order_table";
// const PENDING_NAME = "name";
// const PENDING_VALUE = "value";
// const PENDING_ORDER = "pending_order";

// class POSConfigTable {
//   static Future<void> onCreate(Database db, int version) async {
//     await db.execute("CREATE TABLE $PENDING_ORDER_TABLE_NAME("
//         "$PENDING_NAME TEXT,"
//         "$PENDING_VALUE TEXT"
//         ")");
//   }

//   static Future<int> insert(
//     final Database db,
//     String columnName,
//     String? value,
//   ) async {
//     String sql = "INSERT INTO $PENDING_ORDER_TABLE_NAME("
//         "$PENDING_NAME, $PENDING_VALUE"
//         ")"
//         " VALUES("
//         "'$columnName','$value'"
//         ")";
//     int inq = await db.rawInsert(sql);
//     return inq;
//   }

//   static Future<POSConfig?> getAppConfig() async {
//     // Get a reference to the database.
//     final Database db = await DatabaseHelper().db;

//     // Query the table for all The Categories.
//     final List<Map<String, dynamic>> maps = await db.query(
//       PENDING_ORDER_TABLE_NAME,
//     );
//     return convertPosConfig(maps);
//   }

//   static Future<bool> checkRowExist(
//     Database? db,
//   ) async {
//     db ??= await DatabaseHelper().db;
//     bool isExist = false;

//     final List<Map<String, dynamic>> maps = await db.query(
//         PENDING_ORDER_TABLE_NAME,
//         where: "$PENDING_NAME=?",
//         whereArgs: ["'$PENDING_ORDER'"]);
//     isExist = maps.isNotEmpty;
//     return isExist;
//   }

//   static Future<int> insertOrUpdateWithDB(
//       {Database? db, required String value}) async {
//     db ??= await DatabaseHelper().db;
//     if (await checkRowExist(db)) {
//       String sql = "UPDATE $PENDING_ORDER_TABLE_NAME "
//           "SET $PENDING_VALUE = '$value' "
//           "WHERE $PENDING_NAME='$PENDING_ORDER'";
//       return db.rawInsert(sql);
//     } else {
//       return insert(db, PENDING_ORDER, value);
//     }
//   }
// }
