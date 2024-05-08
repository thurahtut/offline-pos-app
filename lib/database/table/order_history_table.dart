// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const ORDER_HISTORY_TABLE_NAME = "order_history_table";
const ORDER_HISTORY_ID = "id";
const NAME_IN_OH = "name";
const SESSION_ID = "session_id";
const SESSION_NAME_IN_OH = "session_name";
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
const AMOUNT_PAID = "amount_paid";
const AMOUNT_RETURN = "amount_return";
const AMOUNT_TAX = "amount_tax";
const AMOUNT_UNTAXED = "amount_untaxed";
const LOYALTY_POINTS = "loyalty_points";
const NB_PRINT = "nb_print";
const POINTS_WON = "points_won";
const PRICELIST_ID = "pricelist_id";
const QR_DT = "qr_dt";
const RETURN_STATUS = "return_status";
const TIP_AMOUNT = "tip_amount";
const TO_INVOICE = "to_invoice";
const TO_SHIP = "to_ship";
const TOTAL_ITEM = "total_item";
const TOTAL_QTY = "total_qty";
const USER_ID = "user_id";
const SEQUENCE_ID = "sequence_id";
const SEQUENCE_LINE_ID = "sequence_line_id";
const IS_RETURN_ORDER = "is_return_order";

class OrderHistoryTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_HISTORY_TABLE_NAME("
        "$ORDER_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$NAME_IN_OH TEXT NOT NULL,"
        "$SESSION_ID INTEGER NOT NULL,"
        "$SESSION_NAME_IN_OH TEXT NOT NULL,"
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
        "$AMOUNT_PAID REAL NOT NULL,"
        "$AMOUNT_RETURN REAL,"
        "$AMOUNT_TAX REAL,"
        "$AMOUNT_UNTAXED REAL,"
        "$LOYALTY_POINTS REAL,"
        "$NB_PRINT INTEGER,"
        "$POINTS_WON TEXT,"
        "$PRICELIST_ID INTEGER NOT NULL,"
        "$QR_DT TEXT,"
        "$RETURN_STATUS TEXT,"
        "$TIP_AMOUNT INTEGER,"
        "$TO_INVOICE TEXT,"
        "$TO_SHIP TEXT,"
        "$TOTAL_ITEM INTEGER,"
        "$TOTAL_QTY INTEGER,"
        "$USER_ID INTEGER,"
        "$SEQUENCE_ID INTEGER,"
        "$SEQUENCE_LINE_ID INTEGER,"
        "$IS_RETURN_ORDER TEXT,"
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
    int id = 0;
    if (await checkRowExist(db, orderHistory.id ?? 0)) {
      await update(db, orderHistory);
      id = orderHistory.id ?? 0;
    } else {
      id = await insert(db, orderHistory);
    }
    return id;
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

  static Future<int> deleteByOrderId({
    Database? db,
    Transaction? txn,
    required int orderHistoryId,
  }) async {
    if (txn != null) {
      return txn.delete(
        ORDER_HISTORY_TABLE_NAME,
        where: "$ORDER_HISTORY_ID=?",
        whereArgs: [orderHistoryId],
      );
    } else {
      db ??= await DatabaseHelper().db;

      return db.delete(
        ORDER_HISTORY_TABLE_NAME,
        where: "$ORDER_HISTORY_ID=?",
        whereArgs: [orderHistoryId],
      );
    }
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

  static Future<int> updateValue({
    Database? db,
    required String whereColumnName,
    String? whereValue,
    required String columnName,
    String? value,
  }) async {
    db ??= await DatabaseHelper().db;
    String sql = "UPDATE $ORDER_HISTORY_TABLE_NAME "
        "SET $columnName = '$value'"
        " Where $whereColumnName = $whereColumnName";
    return db.rawInsert(sql);
  }

  static Future<List<OrderHistory>> getOrderHistorysFiltering({
    String? filter,
    int? limit,
    int? offset,
    String? typeFilter,
    String? dateFilter,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    String query =
        "select ot.*, ct.$CUSTOMER_NAME as customer_name, emt.$NAME_IN_ET as employee_name "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join $CUSTOMER_TABLE_NAME ct "
        "on ct.$CUSTOMER_ID_IN_CT=ot.$PARTNER_ID "
        "left join $EMPLOYEE_TABLE_NAME emt "
        "on emt.$EMPLOYEE_ID=ot.$EMPLOYEE_ID_IN_OH "
        "where 1=1 "
        "${(filter != null && filter.isNotEmpty ? "and ($SEQUENCE_NUMBER LIKE '%$filter%' or lower(ot.$NAME_IN_OH) LIKE '%${filter.toLowerCase()}%' or lower(ot.$RECEIPT_NUMBER) LIKE '%${filter.toLowerCase()}%') " : "")}"
        "${(typeFilter != null && typeFilter.isNotEmpty ? "and $STATE_IN_OT='$typeFilter' " : "")}"
        "${dateFilter != null ? "and strftime('%Y-%m-%d', ot.$CREATE_DATE_IN_OH)=strftime('%Y-%m-%d', '$dateFilter') " : ""}"
        "group by ot.$ORDER_HISTORY_ID "
        "order by ot.$ORDER_HISTORY_ID DESC"
        "${limit != null ? " limit $limit " : " "}"
        "${offset != null ? " offset $offset " : " "}";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      OrderHistory orderHistory = OrderHistory.fromJson(maps[i]);
      orderHistory.partnerName = maps[i]["customer_name"];
      orderHistory.employeeName = maps[i]["employee_name"];
      return orderHistory;
    });
  }

  static Future<int> getAllOrderHistoryCount({
    String? filter,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    filter = filter?.toLowerCase();
    // Query the table for all The Categories.
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM $ORDER_HISTORY_TABLE_NAME '
        '${filter != null && filter.isNotEmpty ? 'Where $SEQUENCE_NUMBER Like ? or lower($NAME_IN_OH) Like ?' : ''}',
        filter != null && filter.isNotEmpty
            ? ['%$filter%', '%${filter.toLowerCase()}%']
            : null);
    final count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  static String getOrderHistorySelectKeys({
    String? initialKey,
    List<String>? toRemoveKeys,
  }) {
    Map<String, dynamic> map = OrderHistory().toJson();
    for (var data in toRemoveKeys ?? []) {
      map.remove(data);
    }
    List<String> list = initialKey != null
        ? map.keys.map((e) => "$initialKey$e").toList()
        : map.keys.toList();

    String str = list.join(",");
    return str;
  }

  static String getOrderHistoryQuery({
    int? orderHistoryId,
    int? sessionId,
    bool? includedCustomerName = true,
    bool? includedEmployeeName = true,
    bool? includedPaymentMethodName = true,
    String? orderHistoryKeys,
    bool? isCloseSession,
    bool? isReturnOrder,
  }) {
    return "select ${orderHistoryKeys ?? "ot.*"}, "
        "${includedCustomerName == true ? "ct.$CUSTOMER_NAME as customer_name, " : ""}"
        "${includedEmployeeName == true ? "emt.$NAME_IN_ET as employee_name, " : ""}"
        "json_group_array(distinct json_extract(json_object("
        "'$ORDER_LINE_ID', olt.$ORDER_LINE_ID, "
        "${isCloseSession != true ? "'$ORDER_ID_IN_LINE', olt.$ORDER_ID_IN_LINE, " : ""}"
        "'$PRODUCT_ID_IN_LINE' , olt.$PRODUCT_ID_IN_LINE, '$FULL_PRODUCT_NAME', ${getValueWithCase("olt.$FULL_PRODUCT_NAME")}, "
        "'$QTY_IN_LINE' , olt.$QTY_IN_LINE, '$PRICE_UNIT', olt.$PRICE_UNIT, '$PRICE_SUBTOTAL', olt.$PRICE_SUBTOTAL, '$PRICE_SUBTOTAL_INCL', olt.$PRICE_SUBTOTAL_INCL, "
        "'$DISCOUNT_IN_LINE', olt.$DISCOUNT_IN_LINE, '$CREATE_DATE_IN_LINE', olt.$CREATE_DATE_IN_LINE, '$CREATE_UID_IN_LINE', olt.$CREATE_UID_IN_LINE "
        "${isCloseSession != true ? ", '$IS_PROMO_ITEM' , olt.$IS_PROMO_ITEM, '$PARENT_PROMOTION_ID', olt.$PARENT_PROMOTION_ID, '$ON_ORDER_ITEM', olt.$ON_ORDER_ITEM" : ""}"
        ",'$SH_DISCOUNT_CODE' , olt.$SH_DISCOUNT_CODE,'$SH_DISCOUNT_REASON' , olt.$SH_DISCOUNT_REASON"
        "${isReturnOrder != true ? ", '$REFUNDED_ORDER_LINE_ID', olt.$REFUNDED_ORDER_LINE_ID" : ""}"
        "), '\$' )) as line_ids, " //'$BARCODE_IN_PT', olt.$BARCODE_IN_PT ,
        "${isCloseSession == true ? "case when ptt.$PAYMENT_TRANSACTION_ID is not null then " : ""}"
        "json_group_array("
        "distinct json_extract("
        "json_object("
        "${isCloseSession != true ? "'$PAYMENT_TRANSACTION_ID', ptt.$PAYMENT_TRANSACTION_ID, '$ORDER_ID_IN_TRAN', ptt.$ORDER_ID_IN_TRAN, " : ""}"
        "'$PAYMENT_DATE' , ptt.$PAYMENT_DATE, '$PAYMENT_METHOD_ID_TRAN', ptt.$PAYMENT_METHOD_ID_TRAN, "
        "${includedPaymentMethodName == true ? "'name', ${getValueWithCase("pmt.$PAYMENT_METHOD_NAME")}, " : ""}"
        "'$AMOUNT_IN_TRAN', ptt.$AMOUNT_IN_TRAN, '$CARD_TYPE', ${getValueWithCase("ptt.$CARD_TYPE")}, '$CARD_HOLDER_NAME', ${getValueWithCase("ptt.$CARD_HOLDER_NAME")}, "
        "'$CREATE_DATE_IN_TRAN', ptt.$CREATE_DATE_IN_TRAN, '$CREATE_UID_IN_TRAN', ptt.$CREATE_UID_IN_TRAN, '$TICKET', ${getValueWithCase("ptt.$TICKET")}, "
        "'$PAYMENT_STATUS', ${getValueWithCase("ptt.$PAYMENT_STATUS")}, '$SESSION_ID_IN_TRAN', ptt.$SESSION_ID_IN_TRAN, '$TRANSACTION_ID', '', "
        "'$IS_CHANGE', null)"
        ", '\$' )"
        ")"
        "${isCloseSession == true ? " else '' end" : ""}"
        " as payment_ids "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join "
        "$ORDER_LINE_ID_TABLE_NAME olt "
        // "("
        // "select olt.* , "
        // // "pt.$PRODUCT_NAME as product_name, "
        // "pt.$BARCODE_IN_PT as $BARCODE_IN_PT "
        // "from $ORDER_LINE_ID_TABLE_NAME olt "
        // "left join $PRODUCT_TABLE_NAME pt "
        // "on pt.$PRODUCT_ID = olt.$PRODUCT_ID_IN_LINE "
        // ") olt "
        // "$ORDER_LINE_ID_TABLE_NAME olt "
        "on olt.$ORDER_ID_IN_LINE = ot.$ORDER_HISTORY_ID "
        "${orderHistoryId != null ? "and olt.$ORDER_ID_IN_LINE = $orderHistoryId " : ""}"
        "left join $PAYMENT_TRANSACTION_TABLE_NAME ptt "
        "on ptt.$ORDER_ID_IN_TRAN = ot.$ORDER_HISTORY_ID "
        "${orderHistoryId != null ? "and ptt.$ORDER_ID_IN_TRAN = $orderHistoryId " : ""}"
        "${sessionId != null ? "and ptt.$SESSION_ID_IN_TRAN = $sessionId " : ""}"
        "${includedCustomerName == true ? "left join $CUSTOMER_TABLE_NAME ct "
            "on ct.$CUSTOMER_ID_IN_CT=ot.$PARTNER_ID " : " "}"
        "${includedEmployeeName == true ? "left join $EMPLOYEE_TABLE_NAME emt "
            "on emt.$EMPLOYEE_ID=ot.$EMPLOYEE_ID_IN_OH " : " "}"
        "${includedPaymentMethodName == true ? "left join $PAYMENT_METHOD_TABLE_NAME pmt "
            "on pmt.$PAYMENT_METHOD_ID=ptt.$PAYMENT_METHOD_ID_TRAN " : ""}"
        " where 1=1 "
        "${orderHistoryId != null ? " and ot.$ORDER_HISTORY_ID = $orderHistoryId " : ""}"
        "${isCloseSession == true ? " and ot.$STATE_IN_OT='${OrderState.paid.text}' " : ""}"
        "${isCloseSession == true ? " and ot.$ORDER_CONDITION<>'${OrderCondition.sync.text}' " : ""}"
        "${sessionId != null ? " and ot.$SESSION_ID=$sessionId " : ""}"
        "${isReturnOrder != null ? " and ot.$IS_RETURN_ORDER=${isReturnOrder == true ? "'true'" : "'false'"} " : ""}"
        "group by ot.$ORDER_HISTORY_ID "
        "order by ot.$ORDER_HISTORY_ID ";
  }

  static String getValueWithCase(String trt) {
    return "case when $trt is not null then $trt else '' end ";
  }

  static Future<OrderHistory?> getOrderById(int? orderHistoryId) async {
    final Database db = await DatabaseHelper().db;
    String query = getOrderHistoryQuery(orderHistoryId: orderHistoryId);
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    OrderHistory? orderHistory;
    if (maps.isNotEmpty) {
      orderHistory = OrderHistory.fromJson(maps.first);
      orderHistory.partnerName = maps.first["customer_name"];
      orderHistory.employeeName = maps.first["employee_name"];
      List<OrderLineID> orderLines = [];
      List<dynamic>? list = jsonDecode(maps.first["line_ids"]);
      for (var data in list ?? []) {
        OrderLineID orderLineID =
            OrderLineID.fromJson(data, isOnlyForDatabase: true);

        // if (orderLines.indexWhere((element) => element.id == orderLineID.id) <
        //     0) {
        orderLines.add(orderLineID);
        // }
      }
      if (orderLines.isNotEmpty) {
        orderHistory.lineIds ??= orderLines;
      }

      List<PaymentTransaction> paymentLines = [];
      list = jsonDecode(maps.first["payment_ids"]);
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

  static Future<List<Map<String, dynamic>>> getOrderHistoryList({
    Database? db,
    int? orderHistoryId,
    int? sessionId,
    bool? isCloseSession,
    bool? isReturnOrder,
  }) async {
    db ??= await DatabaseHelper().db;
    String ohKeys = getOrderHistorySelectKeys(
      initialKey: "ot.",
      toRemoveKeys: [
        ORDER_HISTORY_ID,
        NAME_IN_OH,
        ORDER_CONDITION,
        SEQUENCE_NUMBER,
        WRITE_DATE_IN_OH,
        WRITE_UID_IN_OH,
        SESSION_NAME_IN_OH,
        if (isReturnOrder != true) IS_RETURN_ORDER,
      ],
    );
    String query = getOrderHistoryQuery(
      orderHistoryId: orderHistoryId,
      sessionId: sessionId,
      orderHistoryKeys: ohKeys,
      includedCustomerName: false,
      includedEmployeeName: false,
      includedPaymentMethodName: true,
      isCloseSession: isCloseSession,
      isReturnOrder: isReturnOrder,
    );
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    List<Map<String, dynamic>> cloneMaps =
        jsonDecode(jsonEncode(maps)).cast<Map<String, dynamic>>();
    for (var cloneMap in cloneMaps) {
      cloneMap["line_ids"] =
          cloneMap["line_ids"] != "" ? jsonDecode(cloneMap["line_ids"]) : [];
      cloneMap["payment_ids"] = cloneMap["payment_ids"] != ""
          ? jsonDecode(cloneMap["payment_ids"])
          : [];
      for (Map<String, dynamic> tran in cloneMap["payment_ids"] ?? []) {
        tran['is_change'] = bool.tryParse(tran['is_change'] ?? '') ?? false;
      }
      cloneMap[TO_INVOICE] = bool.tryParse(cloneMap[TO_INVOICE]) ?? false;
      cloneMap[TO_SHIP] = bool.tryParse(cloneMap[TO_SHIP]) ?? false;
    }
    // List<OrderHistory> orderHistoryList = [];
    // OrderHistory? orderHistory;
    // if (maps.isNotEmpty) {
    //   for (var data in maps) {
    //     orderHistory = OrderHistory.fromJson(data);
    //     List<OrderLineID> orderLines = [];
    //     List<dynamic>? list = jsonDecode(data["orderLines"]);
    //     for (var data in list ?? []) {
    //       orderLines.add(OrderLineID.fromJson(data));
    //     }
    //     if (orderLines.isNotEmpty) {
    //       orderHistory.lineIds ??= orderLines;
    //     }
    //     List<PaymentTransaction> paymentLines = [];
    //     list = jsonDecode(data["paymentLines"]);
    //     for (var data in list ?? []) {
    //       paymentLines.add(PaymentTransaction.fromJson(data));
    //     }
    //     if (paymentLines.isNotEmpty) {
    //       orderHistory.paymentIds ??= paymentLines;
    //     }
    //   }
    // }
    return cloneMaps;
  }

  static Future<Map<String, double>> getTotalSummary(int sessionId) async {
    final Database db = await DatabaseHelper().db;
    String query =
        "select sum(ptt.tPaid) totalPaid, sum(oht.$AMOUNT_TOTAL) as totalAmt, "
        "count(oht.$ORDER_HISTORY_ID) as totalOrderHistory, "
        "sum(CASE WHEN oht.$PARTNER_ID is not null AND oht.$PARTNER_ID<>'' THEN ptt.tPaid ELSE 0 END) as totalCustomerAmt "
        "from $ORDER_HISTORY_TABLE_NAME oht "
        "left join "
        "( "
        "	select sum($AMOUNT_IN_TRAN) as tPaid , $ORDER_ID_IN_TRAN"
        "	from $PAYMENT_TRANSACTION_TABLE_NAME"
        "	where $SESSION_ID_IN_TRAN=$sessionId"
        // " where order_id = 1 "
        "	group by $ORDER_ID_IN_TRAN"
        ") ptt "
        "on ptt.$ORDER_ID_IN_TRAN=oht.$ORDER_HISTORY_ID "
        "where oht.$SESSION_ID=$sessionId "
        // "and oht.$ORDER_CONDITION<>'${OrderCondition.sync.text}'"
        ;

    List<Map<String, dynamic>> maps = [];
    try {
      maps = await db.rawQuery(query
          // [sessionId, sessionId]
          );
    } catch (e) {
      print(e.toString());
    }

    Map<String, double> totalSummary = maps.isEmpty
        ? {}
        : maps.first.map((key, value) =>
            MapEntry(key, double.tryParse(value?.toString() ?? '') ?? 0));
    return totalSummary;
  }

  static Future<bool> isExistDraftOrders({Database? db, int? sessionId}) async {
    db ??= await DatabaseHelper().db;
    String query = "select count() "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join $ORDER_LINE_ID_TABLE_NAME olt "
        "on ot.$ORDER_HISTORY_ID = olt.$ORDER_ID_IN_LINE "
        "where ot.$STATE_IN_OT='${OrderState.draft.text}' "
        "and ot.$SESSION_ID=$sessionId "
        "and olt.$ORDER_LINE_ID is not null";
    final result = await db.rawQuery(query);

    int? count = Sqflite.firstIntValue(result);
    return (count ?? 0) > 0;
  }

  static Future<List<Map<String, dynamic>>> getTotalAmountByCategory({
    Database? db,
    int? sessionId,
  }) async {
    db ??= await DatabaseHelper().db;
    String query =
        "select sum(case when ot.$AMOUNT_PAID is not null then ot.$AMOUNT_PAID else 0 end) as totalAmt,"
        "sum(case when ot.$AMOUNT_TAX is not null then ot.$AMOUNT_TAX else 0 end) as totalTax,"
        "cat.$POS_CATEGORY_ID,cat.$POS_CATEGORY_NAME "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join $ORDER_LINE_ID_TABLE_NAME olt "
        "on olt.$ORDER_ID_IN_LINE = ot.$ORDER_HISTORY_ID "
        "left join $PRODUCT_TABLE_NAME pt "
        "on pt.$PRODUCT_VARIANT_IDS = olt.$PRODUCT_ID_IN_LINE "
        "left join $POS_CATEGORY_TABLE_NAME cat "
        "on cat.$POS_CATEGORY_ID = pt.$POS_CATEG_ID_IN_PT "
        "where ot.$SESSION_ID =$sessionId "
        "group by cat.$POS_CATEGORY_ID";

    List<Map<String, dynamic>> maps = [];
    try {
      maps = await db.rawQuery(query);
    } catch (e) {
      print(e.toString());
    }

    return maps;
  }
}
