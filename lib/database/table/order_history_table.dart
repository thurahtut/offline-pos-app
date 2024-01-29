// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/order_line_id_table.dart';
import 'package:offline_pos/model/order_line_id.dart';
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
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select ot.*, ct.$CUSTOMER_NAME, "
        "json_group_array(distinct json_extract(json_object('$ORDER_LINE_ID', olt.$ORDER_LINE_ID, '$ORDER_ID_IN_LINE', olt.$ORDER_ID_IN_LINE, '$PRODUCT_ID_IN_LINE' , olt.$PRODUCT_ID_IN_LINE, 'product_name', olt.product_name , '$BARCODE_IN_PT', olt.$BARCODE_IN_PT , '$QTY_IN_LINE' , olt.$QTY_IN_LINE, '$PRICE_UNIT', olt.$PRICE_UNIT, '$PRICE_SUBTOTAL', olt.$PRICE_SUBTOTAL, '$PRICE_SUBTOTAL_INCL', olt.$PRICE_SUBTOTAL_INCL), '\$' )) as orderLines, "
        "json_group_array(distinct json_extract(json_object('$PAYMENT_TRANSACTION_ID', ptt.$PAYMENT_TRANSACTION_ID, '$ORDER_ID_IN_TRAN', ptt.$ORDER_ID_IN_TRAN, '$PAYMENT_DATE' , ptt.$PAYMENT_DATE, '$PAYMENT_METHOD_ID_TRAN', ptt.$PAYMENT_METHOD_ID_TRAN, 'name', pmt.$PAYMENT_METHOD_NAME, '$AMOUNT_IN_TRAN', ptt.$AMOUNT_IN_TRAN), '\$' )) as paymentLines "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join "
        "("
        "select olt.* , pt.$PRODUCT_NAME as product_name, pt.$BARCODE_IN_PT as $BARCODE_IN_PT "
        "from $ORDER_LINE_ID_TABLE_NAME olt "
        "left join $PRODUCT_TABLE_NAME pt "
        "on pt.$PRODUCT_ID = olt.$PRODUCT_ID_IN_LINE "
        ") olt "
        // "$ORDER_LINE_ID_TABLE_NAME olt "
        "on olt.$ORDER_ID_IN_LINE = ot.$ORDER_HISTORY_ID "
        "and olt.$ORDER_ID_IN_LINE = $orderHistoryId "
        "left join $PAYMENT_TRANSACTION_TABLE_NAME ptt "
        "on ptt.$ORDER_ID_IN_TRAN = ot.$ORDER_HISTORY_ID "
        "and ptt.$ORDER_ID_IN_TRAN = $orderHistoryId "
        "left join $CUSTOMER_TABLE_NAME ct "
        "on ct.$CUSTOMER_ID_IN_CT=ot.$PARTNER_ID "
        "left join $PAYMENT_METHOD_TABLE_NAME pmt "
        "on pmt.$PAYMENT_METHOD_ID=ptt.$PAYMENT_METHOD_ID_TRAN "
        "where ot.$ORDER_HISTORY_ID = $orderHistoryId "
        "group by ot.$ORDER_HISTORY_ID ");

    OrderHistory? orderHistory;
    if (maps.isNotEmpty) {
      orderHistory = OrderHistory.fromJson(maps.first);
      orderHistory.partnerName = maps.first[CUSTOMER_NAME];
      List<OrderLineID> orderLines = [];
      List<dynamic>? list = jsonDecode(maps.first["orderLines"]);
      for (var data in list ?? []) {
        OrderLineID orderLineID = OrderLineID.fromJson(data);

        // if (orderLines.indexWhere((element) => element.id == orderLineID.id) <
        //     0) {
        orderLines.add(orderLineID);
        // }
      }
      if (orderLines.isNotEmpty) {
        orderHistory.lineIds ??= orderLines;
      }

      List<PaymentTransaction> paymentLines = [];
      list = jsonDecode(maps.first["paymentLines"]);
      for (var data in list ?? []) {
        PaymentTransaction paymentLine = PaymentTransaction.fromJson(data);

        // if (paymentLines.indexWhere((element) => element.id == paymentLine.id) <
        //     0) {
        paymentLines.add(paymentLine);
        // }
      }
      if (paymentLines.isNotEmpty) {
        orderHistory.paymentIds ??= paymentLines;
      }
    }
    return orderHistory;
  }
}
