// ignore_for_file: constant_identifier_names
import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const ORDER_HISTORY_TABLE_NAME = "order_history_table";
const ORDER_HISTORY_ID = "order_history_id";
const NAME_IN_OH = "name";
const SESSION_ID = "session_id";
const DATE_ORDER = "date_order";
const EMPLOYEE_ID_IN_OH = "employee_id";
const PARTNER_ID = "partner_id";
const COMPANY_ID_IN_OH = "company_id";
const CONFIG_ID = "config_id";
const CREATE_DATE_IN_OH = "create_date";
const CREATE_UID_IN_OH = "create_uid";
const AMOUNT_TOTAL = "amount_total";
const WRITE_DATE_IN_OH = "write_date";
const WRITE_UID_IN_OH = "write_uid";
const SEQUENCE_NUMBER = "sequence_number";

class OrderHistoryTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_HISTORY_TABLE_NAME("
        "$ORDER_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$NAME_IN_OH TEXT NOT NULL,"
        "$SESSION_ID INTEGER NOT NULL,"
        "$DATE_ORDER TEXT NOT NULL,"
        "$EMPLOYEE_ID_IN_OH INTEGER NOT NULL,"
        "$PARTNER_ID INTEGER NOT NULL,"
        "$AMOUNT_TOTAL REAL NOT NULL,"
        "$COMPANY_ID_IN_OH INTEGER NOT NULL,"
        "$CONFIG_ID INTEGER NOT NULL,"
        "$CREATE_DATE_IN_OH TEXT NOT NULL,"
        "$CREATE_UID_IN_OH INTEGER NOT NULL,"
        "$WRITE_DATE_IN_OH TEXT NOT NULL,"
        "$WRITE_UID_IN_OH INTEGER NOT NULL,"
        "$SEQUENCE_NUMBER INTEGER NOT NULL"
        ")");
  }

  static Future<int> insert(OrderHistory orderHistory) async {
    final Database db = await DatabaseHelper().db;
    String sql = "INSERT INTO $ORDER_HISTORY_TABLE_NAME("
        "$AMOUNT_TOTAL,"
        "$COMPANY_ID_IN_OH, $CONFIG_ID, $CREATE_DATE_IN_OH, $CREATE_UID_IN_OH, "
        "$DATE_ORDER,  "
        "$EMPLOYEE_ID_IN_OH, "
        "$NAME_IN_OH, "
        "$PARTNER_ID, "
        "$SEQUENCE_NUMBER, $SESSION_ID, "
        "$WRITE_DATE_IN_OH, $WRITE_UID_IN_OH"
        ")"
        " VALUES("
        "'${orderHistory.amountTotal}', "
        "'${orderHistory.companyId}', '${orderHistory.configId}', '${orderHistory.createDate}', '${orderHistory.createUid}', "
        "'${orderHistory.dateOrder}', "
        "'${orderHistory.employeeId}', "
        "'${orderHistory.name}', "
        "'${orderHistory.partnerId}', "
        "'${orderHistory.sequenceNumber}', '${orderHistory.sessionId}', "
        "'${orderHistory.writeDate}', '${orderHistory.writeUid}'"
        ")";
    return db.rawInsert(sql);
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

  static Future<int> delete(int orderHistoryId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      ORDER_HISTORY_TABLE_NAME,
      where: "$ORDER_HISTORY_ID=?",
      whereArgs: [orderHistoryId],
    );
  }

  static Future<int> update(OrderHistory orderHistory) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      ORDER_HISTORY_TABLE_NAME,
      orderHistory.toJson(),
      where: "$ORDER_HISTORY_ID=?",
      whereArgs: [orderHistory.id],
    );
  }
}
