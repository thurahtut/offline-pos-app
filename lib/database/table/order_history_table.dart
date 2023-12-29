// ignore_for_file: constant_identifier_names
import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const ORDER_HISTORY_TABLE_NAME = "order_history_table";
const ORDER_HISTORY_ID = "order_history_id";
const ACCOUNT_MOVE = "account_move";
const AMOUNT_PAID = "amount_paid";
const AMOUNT_RETURN = "amount_return";
const AMOUNT_TAX = "amount_tax";
const AMOUNT_TOTAL = "amount_total";
const AMOUNT_UNTAXED = "amount_untaxed";
const APPLIED_PROGRAM_IDS = "applied_program_ids";
const CASHIER = "cashier";
const COMPANY_ID = "company_id";
const CONFIG_ID = "config_id";
const CREATE_DATE = "create_date";
const CREATE_UID = "create_uid";
const CURRENCY_ID = "currency_id";
const CURRENCY_RATE = "currency_rate";
const DATE_ORDER = "date_order";
const DISPLAY_NAME = "display_name";
const EMPLOYEE_ID = "employee_id";
const FAILED_PICKINGS = "failed_pickings";
const FISCAL_POSITION_ID = "fiscal_position_id";
const GENERATED_COUPON_IDS = "generated_coupon_ids";
const HAS_REFUNDABLE_LINES = "has_refundable_lines";
const INVOICE_GROUP = "invoice_group";
const IS_INVOICED = "is_invoiced";
const IS_REFUNDED = "is_refunded";
const IS_TIPPED = "is_tipped";
const IS_TOTAL_COST_COMPUTED = "is_total_cost_computed";
const LAST_UPDATE = "last_update";
const LINES = "lines";
const LOYALTY_POINTS = "loyalty_points";
const MARGIN = "margin";
const MARGIN_PERCENT = "margin_percent";
const NAME = "name";
const PARTNER_ID = "partner_id";
const PAYMENT_IDS = "payment_ids";
const PICKING_COUNT = "picking_count";
const PICKING_IDS = "picking_ids";
const PICKING_TYPE_ID = "picking_type_id";
const POINTS_WON = "points_won";
const POS_REFERENCE = "pos_reference";
const PRICELIST_ID = "pricelist_id";
const PROCUREMENT_GROUP_ID = "procurement_group_id";
const RATING = "rating";
const REFUNDED_ORDER_IDS = "refunded_order_ids";
const REFUNDED_ORDERS_COUNT = "refunded_orders_count";
const REFUND_ORDERS_COUNT = "refund_orders_count";
const SALE_JOURNAL = "sale_journal";
const SEQUENCE_NUMBER = "sequence_number";
const SESSION_ID = "session_id";
const SESSION_MOVE_ID = "session_move_id";
const STATE = "state";
const TIP_AMOUNT = "tip_amount";
const TO_INVOICE = "to_invoice";
const TO_SHIP = "to_ship";
const USED_COUPON_IDS = "used_coupon_ids";
const USER_ID = "user_id";
const WRITE_DATE = "write_date";
const WRITE_UID = "write_uid";

class OrderHistoryTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ORDER_HISTORY_TABLE_NAME("
        "$ORDER_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ACCOUNT_MOVE TEXT NOT NULL,"
        "$AMOUNT_PAID REAL NOT NULL,"
        "$AMOUNT_RETURN REAL NOT NULL,"
        "$AMOUNT_TAX REAL NOT NULL,"
        "$AMOUNT_TOTAL REAL NOT NULL,"
        "$AMOUNT_UNTAXED TEXT NOT NULL,"
        "$APPLIED_PROGRAM_IDS TEXT NOT NULL,"
        "$CASHIER TEXT NOT NULL,"
        "$COMPANY_ID INTEGER NOT NULL,"
        "$CONFIG_ID INTEGER NOT NULL,"
        "$CREATE_DATE TEXT NOT NULL,"
        "$CREATE_UID INTEGER NOT NULL,"
        "$CURRENCY_ID INTEGER NOT NULL,"
        "$CURRENCY_RATE REAL NOT NULL,"
        "$DATE_ORDER TEXT NOT NULL,"
        "$DISPLAY_NAME TEXT NOT NULL,"
        "$EMPLOYEE_ID INTEGER NOT NULL,"
        "$FAILED_PICKINGS TEXT NOT NULL,"
        "$FISCAL_POSITION_ID INTEGER NOT NULL,"
        "$GENERATED_COUPON_IDS TEXT NOT NULL,"
        "$HAS_REFUNDABLE_LINES TEXT NOT NULL,"
        "$INVOICE_GROUP TEXT NOT NULL,"
        "$IS_INVOICED TEXT NOT NULL,"
        "$IS_REFUNDED TEXT NOT NULL,"
        "$IS_TIPPED TEXT NOT NULL,"
        "$IS_TOTAL_COST_COMPUTED TEXT NOT NULL,"
        "$LAST_UPDATE TEXT NOT NULL,"
        "$LINES TEXT NOT NULL,"
        "$LOYALTY_POINTS REAL NOT NULL,"
        "$MARGIN REAL NOT NULL,"
        "$MARGIN_PERCENT TEXT NOT NULL,"
        "$NAME TEXT NOT NULL,"
        "$PARTNER_ID INTEGER NOT NULL,"
        "$PAYMENT_IDS TEXT NOT NULL,"
        "$PICKING_COUNT INTEGER NOT NULL,"
        "$PICKING_IDS TEXT NOT NULL,"
        "$PICKING_TYPE_ID INTEGER NOT NULL,"
        "$POINTS_WON REAL NOT NULL,"
        "$POS_REFERENCE TEXT NOT NULL,"
        "$PRICELIST_ID INTEGER NOT NULL,"
        "$PROCUREMENT_GROUP_ID INTEGER NOT NULL,"
        "$RATING INTEGER NOT NULL,"
        "$REFUNDED_ORDER_IDS TEXT NOT NULL,"
        "$REFUNDED_ORDERS_COUNT INTEGER NOT NULL,"
        "$REFUND_ORDERS_COUNT INTEGER NOT NULL,"
        "$SALE_JOURNAL TEXT NOT NULL,"
        "$SEQUENCE_NUMBER INTEGER NOT NULL,"
        "$SESSION_ID INTEGER NOT NULL,"
        "$SESSION_MOVE_ID INTEGER NOT NULL,"
        "$STATE TEXT NOT NULL,"
        "$TIP_AMOUNT REAL NOT NULL,"
        "$TO_INVOICE TEXT NOT NULL,"
        "$TO_SHIP TEXT NOT NULL,"
        "$USED_COUPON_IDS TEXT NOT NULL,"
        "$USER_ID INTEGER NOT NULL,"
        "$WRITE_DATE TEXT NOT NULL,"
        "$WRITE_UID INTEGER NOT NULL"
        ")");
  }

  static Future<int> insert(OrderHistory orderHistory) async {
    final Database db = await DatabaseHelper().db;
    String sql = "INSERT INTO $ORDER_HISTORY_TABLE_NAME("
        "$ACCOUNT_MOVE, $AMOUNT_PAID, $AMOUNT_RETURN, $AMOUNT_TAX, "
        "$AMOUNT_TOTAL, $AMOUNT_UNTAXED, $APPLIED_PROGRAM_IDS, $CASHIER, "
        "$COMPANY_ID, $CONFIG_ID, $CREATE_DATE, $CREATE_UID, "
        "$CURRENCY_ID, $CURRENCY_RATE, $DATE_ORDER, $DISPLAY_NAME, "
        "$EMPLOYEE_ID, $FAILED_PICKINGS, $FISCAL_POSITION_ID, $GENERATED_COUPON_IDS, "
        "$HAS_REFUNDABLE_LINES, $INVOICE_GROUP, $IS_INVOICED, $IS_REFUNDED, "
        "$IS_TIPPED, $IS_TOTAL_COST_COMPUTED, $LAST_UPDATE, $LINES, "
        "$LOYALTY_POINTS, $MARGIN, $MARGIN_PERCENT, $NAME, "
        "$PARTNER_ID, $PAYMENT_IDS, $PICKING_COUNT, $PICKING_IDS, "
        "$PICKING_TYPE_ID, $POINTS_WON, $POS_REFERENCE, $PRICELIST_ID, "
        "$PROCUREMENT_GROUP_ID, $RATING, $REFUNDED_ORDERS_COUNT, $REFUND_ORDERS_COUNT, "
        "$SALE_JOURNAL, $SEQUENCE_NUMBER, $SESSION_ID, $SESSION_MOVE_ID, "
        "$STATE, $TIP_AMOUNT, $TO_INVOICE, $TO_SHIP, $USED_COUPON_IDS, "
        "$USER_ID, $WRITE_DATE, $WRITE_UID"
        ")"
        " VALUES("
        "'${orderHistory.accountMove}', '${orderHistory.amountPaid}', '${orderHistory.amountReturn}', '${orderHistory.amountTax}', "
        "'${orderHistory.amountTotal}', '${orderHistory.amountUntaxed}', '${orderHistory.appliedProgramIds}', '${orderHistory.cashier}', "
        "'${orderHistory.companyId}', '${orderHistory.configId}', '${orderHistory.createDate}', '${orderHistory.createUid}', "
        "'${orderHistory.currencyId}', '${orderHistory.currencyRate}', '${orderHistory.dateOrder}', '${orderHistory.displayName}', "
        "'${orderHistory.employeeId}', '${orderHistory.failedPickings}', '${orderHistory.fiscalPositionId}', '${orderHistory.generatedCouponIds}', "
        "'${orderHistory.hasRefundableLines}', '${orderHistory.invoiceGroup}', '${orderHistory.isInvoiced}', '${orderHistory.isRefunded}', "
        "'${orderHistory.isTipped}', '${orderHistory.isTotalCostComputed}', '${orderHistory.lastUpdate}', '${orderHistory.lines}', "
        "'${orderHistory.loyaltyPoints}', '${orderHistory.margin}', '${orderHistory.marginPercent}', '${orderHistory.name}', "
        "'${orderHistory.partnerId}', '${orderHistory.paymentIds}', '${orderHistory.pickingCount}', '${orderHistory.pickingIds}', "
        "'${orderHistory.pickingTypeId}', '${orderHistory.pointsWon}', '${orderHistory.posReference}', '${orderHistory.pricelistId}', "
        "'${orderHistory.procurementGroupId}', '${orderHistory.rating}', '${orderHistory.refundedOrdersCount}', '${orderHistory.refundOrdersCount}', "
        "'${orderHistory.saleJournal}', '${orderHistory.sequenceNumber}', '${orderHistory.sessionId}', '${orderHistory.sessionMoveId}', "
        "'${orderHistory.state}', '${orderHistory.tipAmount}', '${orderHistory.toInvoice}', '${orderHistory.toShip}', '${orderHistory.usedCouponIds}', "
        "'${orderHistory.userId}', '${orderHistory.writeDate}', '${orderHistory.writeUid}'"
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
      whereArgs: [orderHistory.orderHistoryId],
    );
  }
}
