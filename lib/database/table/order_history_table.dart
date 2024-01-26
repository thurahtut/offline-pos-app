// ignore_for_file: constant_identifier_names
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/order_line_id_table.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const ORDER_HISTORY_TABLE_NAME = "order_history_table";
const ORDER_HISTORY_ID = "id";
const NAME_IN_OH = "name";
const SESSION_ID = "session_id";
const DATE_ORDER = "date_order";
const EMPLOYEE_ID_IN_OH = "employee_id";
const PARTNER_ID = "partner_id";
// const COMPANY_ID_IN_OH = "company_id";
const CONFIG_ID = "config_id";
const CREATE_DATE_IN_OH = "create_date";
const CREATE_UID_IN_OH = "create_uid";
const AMOUNT_TOTAL = "amount_total";
const WRITE_DATE_IN_OH = "write_date";
const WRITE_UID_IN_OH = "write_uid";
const SEQUENCE_NUMBER = "sequence_number";
const RECEIPT_NUMBER = "pos_reference";
const STATE_IN_OT = "state";
const ORDER_CONDITION = "order_condition";

class OrderHistoryTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_HISTORY_TABLE_NAME("
        "$ORDER_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$NAME_IN_OH TEXT NOT NULL,"
        "$SESSION_ID INTEGER NOT NULL,"
        "$DATE_ORDER TEXT NOT NULL,"
        "$EMPLOYEE_ID_IN_OH INTEGER NOT NULL,"
        "$PARTNER_ID INTEGER,"
        "$AMOUNT_TOTAL REAL NOT NULL,"
        // "$COMPANY_ID_IN_OH INTEGER NOT NULL,"
        "$CONFIG_ID INTEGER NOT NULL,"
        "$CREATE_DATE_IN_OH TEXT NOT NULL,"
        "$CREATE_UID_IN_OH INTEGER NOT NULL,"
        "$WRITE_DATE_IN_OH TEXT,"
        "$WRITE_UID_IN_OH INTEGER,"
        "$SEQUENCE_NUMBER INTEGER NOT NULL,"
        "$RECEIPT_NUMBER TEXT,"
        "$STATE_IN_OT TEXT,"
        "$ORDER_CONDITION TEXT,"
        "unique ($NAME_IN_OH, $SESSION_ID, $SEQUENCE_NUMBER)"
        ")");
  }

  static Future<int> insert(
      final Database db, OrderHistory orderHistory) async {
    return db.insert(ORDER_HISTORY_TABLE_NAME, orderHistory.toJson());
  }

  static Future<List<OrderHistory>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      ORDER_HISTORY_TABLE_NAME,
      orderBy: '$ORDER_HISTORY_ID DESC',
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return OrderHistory.fromJson(maps[i]);
    });
  }

  static Future<int> insertOrUpdate(
      final Database db, OrderHistory orderHistory) async {
    if (await checkRowExist(db, orderHistory.id ?? 0)) {
      return update(db, orderHistory);
    } else {
      return insert(db, orderHistory);
    }
  }

  static Future<bool> checkRowExist(
    final Database db,
    int orderHistoryId,
  ) async {
    bool isExist = false;

    final List<Map<String, dynamic>> maps = await db.query(
        ORDER_HISTORY_TABLE_NAME,
        where: "$ORDER_HISTORY_ID=?",
        whereArgs: [orderHistoryId]);
    isExist = maps.isNotEmpty;
    return isExist;
  }

  static Future<int> delete(int orderHistoryId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      ORDER_HISTORY_TABLE_NAME,
      where: "$ORDER_HISTORY_ID=?",
      whereArgs: [orderHistoryId],
    );
  }

  static Future<int> update(
      final Database db, OrderHistory orderHistory) async {
    return db.update(
      ORDER_HISTORY_TABLE_NAME,
      orderHistory.toJson(),
      where: "$ORDER_HISTORY_ID=?",
      whereArgs: [orderHistory.id],
    );
  }

  static Future<int> updateValue(
      final Database db, int orderId, String columnName, String? value) async {
    String sql = "UPDATE $ORDER_HISTORY_TABLE_NAME "
        "SET $columnName = '$value'"
        " Where $ORDER_HISTORY_ID = $orderId";
    return db.rawInsert(sql);
  }

  static Future<List<OrderHistory>> getOrderHistorysFiltering({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      ORDER_HISTORY_TABLE_NAME,
      where: filter != null
          ? "$SEQUENCE_NUMBER LIKE ? or lower($NAME_IN_OH) LIKE ?"
          : null,
      whereArgs:
          filter != null ? ['%$filter%', '%${filter.toLowerCase()}%'] : null,
      // where: "$PRODUCT_NAME=?",
      // whereArgs: [filter],
      orderBy: '$ORDER_HISTORY_ID DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return OrderHistory.fromJson(maps[i]);
    });
  }

  static Future<OrderHistory?> getOrderById(int orderHistoryId) async {
    final Database db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps = await db.rawQuery("select ot.* "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join $ORDER_LINE_ID_TABLE_NAME olt "
        "on olt.$ORDER_ID_IN_LINE = ot.$ORDER_HISTORY_ID "
        "left join $PAYMENT_TRANSACTION_TABLE_NAME ptt "
        "on ptt.$ORDER_ID_IN_TRAN = ot.$ORDER_HISTORY_ID "
        "group by ot.$ORDER_HISTORY_ID ");
    return maps.isNotEmpty ? OrderHistory.fromJson(maps.first) : null;
  }

}
