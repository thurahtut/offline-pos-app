class OrderHistory {
  int? orderHistoryId;
  String? accountMove;
  double? amountPaid;
  double? amountReturn;
  double? amountTax;
  double? amountTotal;
  String? amountUntaxed;
  String? appliedProgramIds;
  String? cashier;
  int? companyId;
  int? configId;
  String? createDate;
  int? createUid;
  int? currencyId;
  double? currencyRate;
  String? dateOrder;
  String? displayName;
  int? employeeId;
  String? failedPickings;
  int? fiscalPositionId;
  String? generatedCouponIds;
  String? hasRefundableLines;
  String? invoiceGroup;
  String? isInvoiced;
  String? isRefunded;
  String? isReturnOrder;
  String? isTipped;
  String? isTotalCostComputed;
  String? lastUpdate;
  String? lines;
  double? loyaltyPoints;
  double? margin;
  int? marginPercent;
  String? name;
  String? nbPrint;
  String? note;
  int? partnerId;
  String? paymentIds;
  int? pickingCount;
  String? pickingIds;
  int? pickingTypeId;
  double? pointsWon;
  String? posReference;
  int? pricelistId;
  int? procurementGroupId;
  int? rating;
  String? refundedOrderIds;
  int? refundedOrdersCount;
  int? refundOrdersCount;
  String? saleJournal;
  int? sequenceNumber;
  int? sessionId;
  int? sessionMoveId;
  String? state;
  double? tipAmount;
  String? toInvoice;
  String? toShip;
  String? usedCouponIds;
  int? userId;
  String? writeDate;
  int? writeUid;

  OrderHistory(
      {this.orderHistoryId,
      this.accountMove,
      this.amountPaid,
      this.amountReturn,
      this.amountTax,
      this.amountTotal,
      this.amountUntaxed,
      this.appliedProgramIds,
      this.cashier,
      this.companyId,
      this.configId,
      this.createDate,
      this.createUid,
      this.currencyId,
      this.currencyRate,
      this.dateOrder,
      this.displayName,
      this.employeeId,
      this.failedPickings,
      this.fiscalPositionId,
      this.generatedCouponIds,
      this.hasRefundableLines,
      this.invoiceGroup,
      this.isInvoiced,
      this.isRefunded,
      this.isReturnOrder,
      this.isTipped,
      this.isTotalCostComputed,
      this.lastUpdate,
      this.lines,
      this.loyaltyPoints,
      this.margin,
      this.marginPercent,
      this.name,
      this.nbPrint,
      this.note,
      this.partnerId,
      this.paymentIds,
      this.pickingCount,
      this.pickingIds,
      this.pickingTypeId,
      this.pointsWon,
      this.posReference,
      this.pricelistId,
      this.procurementGroupId,
      this.rating,
      this.refundedOrderIds,
      this.refundedOrdersCount,
      this.refundOrdersCount,
      this.saleJournal,
      this.sequenceNumber,
      this.sessionId,
      this.sessionMoveId,
      this.state,
      this.tipAmount,
      this.toInvoice,
      this.toShip,
      this.usedCouponIds,
      this.userId,
      this.writeDate,
      this.writeUid});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    orderHistoryId = json['order_history_id'];
    accountMove = json['account_move'];
    amountPaid = json['amount_paid'];
    amountReturn = json['amount_return'];
    amountTax = json['amount_tax'];
    amountTotal = json['amount_total'];
    amountUntaxed = json['amount_untaxed'];
    appliedProgramIds = json['applied_program_ids'];
    cashier = json['cashier'];
    companyId = json['company_id'];
    configId = json['config_id'];
    createDate = json['create_date'];
    createUid = json['create_uid'];
    currencyId = json['currency_id'];
    currencyRate = json['currency_rate'];
    dateOrder = json['date_order'];
    displayName = json['display_name'];
    employeeId = json['employee_id'];
    failedPickings = json['failed_pickings'];
    fiscalPositionId = json['fiscal_position_id'];
    generatedCouponIds = json['generated_coupon_ids'];
    hasRefundableLines = json['has_refundable_lines'];
    invoiceGroup = json['invoice_group'];
    isInvoiced = json['is_invoiced'];
    isRefunded = json['is_refunded'];
    isReturnOrder = json['is_return_order'];
    isTipped = json['is_tipped'];
    isTotalCostComputed = json['is_total_cost_computed'];
    lastUpdate = json['last_update'];
    lines = json['lines'];
    loyaltyPoints = json['loyalty_points'];
    margin = json['margin'];
    marginPercent = json['margin_percent'];
    name = json['name'];
    nbPrint = json['nb_print'];
    note = json['note'];
    partnerId = json['partner_id'];
    paymentIds = json['payment_ids'];
    pickingCount = json['picking_count'];
    pickingIds = json['picking_ids'];
    pickingTypeId = json['picking_type_id'];
    pointsWon = json['points_won'];
    posReference = json['pos_reference'];
    pricelistId = json['pricelist_id'];
    procurementGroupId = json['procurement_group_id'];
    rating = json['rating'];
    refundedOrderIds = json['refunded_order_ids'];
    refundedOrdersCount = json['refunded_orders_count'];
    refundOrdersCount = json['refund_orders_count'];
    saleJournal = json['sale_journal'];
    sequenceNumber = json['sequence_number'];
    sessionId = json['session_id'];
    sessionMoveId = json['session_move_id'];
    state = json['state'];
    tipAmount = json['tip_amount'];
    toInvoice = json['to_invoice'];
    toShip = json['to_ship'];
    usedCouponIds = json['used_coupon_ids'];
    userId = json['user_id'];
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_history_id'] = orderHistoryId;
    data['account_move'] = accountMove;
    data['amount_paid'] = amountPaid;
    data['amount_return'] = amountReturn;
    data['amount_tax'] = amountTax;
    data['amount_total'] = amountTotal;
    data['amount_untaxed'] = amountUntaxed;
    data['applied_program_ids'] = appliedProgramIds;
    data['cashier'] = cashier;
    data['company_id'] = companyId;
    data['config_id'] = configId;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['currency_id'] = currencyId;
    data['currency_rate'] = currencyRate;
    data['date_order'] = dateOrder;
    data['display_name'] = displayName;
    data['employee_id'] = employeeId;
    data['failed_pickings'] = failedPickings;
    data['fiscal_position_id'] = fiscalPositionId;
    data['generated_coupon_ids'] = generatedCouponIds;
    data['has_refundable_lines'] = hasRefundableLines;
    data['invoice_group'] = invoiceGroup;
    data['is_invoiced'] = isInvoiced;
    data['is_refunded'] = isRefunded;
    data['is_return_order'] = isReturnOrder;
    data['is_tipped'] = isTipped;
    data['is_total_cost_computed'] = isTotalCostComputed;
    data['last_update'] = lastUpdate;
    data['lines'] = lines;
    data['loyalty_points'] = loyaltyPoints;
    data['margin'] = margin;
    data['margin_percent'] = marginPercent;
    data['name'] = name;
    data['nb_print'] = nbPrint;
    data['note'] = note;
    data['partner_id'] = partnerId;
    data['payment_ids'] = paymentIds;
    data['picking_count'] = pickingCount;
    data['picking_ids'] = pickingIds;
    data['picking_type_id'] = pickingTypeId;
    data['points_won'] = pointsWon;
    data['pos_reference'] = posReference;
    data['pricelist_id'] = pricelistId;
    data['procurement_group_id'] = procurementGroupId;
    data['rating'] = rating;
    data['refunded_order_ids'] = refundedOrderIds;
    data['refunded_orders_count'] = refundedOrdersCount;
    data['refund_orders_count'] = refundOrdersCount;
    data['sale_journal'] = saleJournal;
    data['sequence_number'] = sequenceNumber;
    data['session_id'] = sessionId;
    data['session_move_id'] = sessionMoveId;
    data['state'] = state;
    data['tip_amount'] = tipAmount;
    data['to_invoice'] = toInvoice;
    data['to_ship'] = toShip;
    data['used_coupon_ids'] = usedCouponIds;
    data['user_id'] = userId;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    return data;
  }
}
