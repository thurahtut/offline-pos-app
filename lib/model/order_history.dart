import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/order_line_id.dart';

class OrderHistory {
  int? id;
  String? name;
  int? sessionId;
  String? dateOrder;
  int? employeeId;
  int? partnerId;
  String? createDate;
  int? createUid;
  int? configId;
  int? amountTotal;
  String? sequenceNumber;
  String? writeDate;
  int? writeUid;
  String? receiptNumber;
  String? state;
  String? orderCondition;
  String? partnerName;
  String? employeeName;
  int? amountPaid;
  int? amountReturn;
  double? amountTax;
  int? loyaltyPoints;
  int? nbPrint;
  String? pointsWon;
  int? pricelistId;
  String? qrDt;
  String? returnStatus;
  int? tipAmount;
  bool? toInvoice;
  bool? toShip;
  int? totalItem;
  int? totalQty;
  int? userId;
  int? sequenceId;
  List<OrderLineID>? lineIds;
  List<PaymentTransaction>? paymentIds;
  int? sequenceLineId;

  OrderHistory({
    this.id,
    this.name,
    this.sessionId,
    this.dateOrder,
    this.employeeId,
    this.partnerId,
    this.createDate,
    this.createUid,
    this.configId,
    // this.companyId,
    this.amountTotal,
    this.sequenceNumber,
    this.writeDate,
    this.writeUid,
    this.lineIds,
    this.paymentIds,
    this.receiptNumber,
    this.state,
    this.orderCondition,
    this.partnerName,
    this.employeeName,
    this.amountPaid,
    this.amountReturn,
    this.amountTax,
    this.loyaltyPoints,
    this.nbPrint,
    this.pointsWon,
    this.pricelistId,
    this.qrDt,
    this.returnStatus,
    this.tipAmount,
    this.toInvoice,
    this.toShip,
    this.totalItem,
    this.totalQty,
    this.userId,
    this.sequenceId,
    this.sequenceLineId,
  });

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    sessionId = int.tryParse(json['session_id']?.toString() ?? '');
    dateOrder = json['date_order'];
    employeeId = int.tryParse(json['employee_id']?.toString() ?? '');
    partnerId = int.tryParse(json['partner_id']?.toString() ?? '');
    createDate = json['create_date'];
    createUid = int.tryParse(json['create_uid']?.toString() ?? '');
    configId = int.tryParse(json['config_id']?.toString() ?? '');
    // companyId = int.tryParse(json['company_id'].toString());
    amountTotal = int.tryParse(json['amount_total']?.toString() ?? '');
    sequenceNumber = json['sequence_number']?.toString();
    writeDate = json['write_date']?.toString();
    writeUid = int.tryParse(json['write_uid']?.toString() ?? '');
    receiptNumber = json["pos_reference"];
    state = json["state"];
    orderCondition = json["order_condition"];
    amountPaid = int.tryParse(json['amount_paid']?.toString() ?? '');
    amountReturn = int.tryParse(json['amount_return']?.toString() ?? '');
    amountTax = double.tryParse(json['amount_tax']?.toString() ?? '');
    loyaltyPoints = int.tryParse(json['loyalty_points']?.toString() ?? '');
    nbPrint = int.tryParse(json['nb_print']?.toString() ?? '');
    pointsWon = json['points_won'];
    pricelistId = int.tryParse(json['pricelist_id']?.toString() ?? '');
    qrDt = json['qr_dt'];
    returnStatus = json['return_status'];
    tipAmount = int.tryParse(json['tip_amount']?.toString() ?? '');
    toInvoice = bool.tryParse(json['to_invoice']?.toString() ?? '');
    toShip = bool.tryParse(json['to_ship']?.toString() ?? '');
    totalItem = int.tryParse(json['total_item']?.toString() ?? '');
    totalQty = int.tryParse(json['total_qty']?.toString() ?? '');
    userId = int.tryParse(json['user_id']?.toString() ?? '');
    sequenceId = int.tryParse(json['sequence_id']?.toString() ?? '');
    sequenceLineId = int.tryParse(json['sequence_line_id']?.toString() ?? ''); 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['session_id'] = sessionId;
    data['date_order'] = dateOrder;
    data['employee_id'] = employeeId;
    data['partner_id'] = partnerId;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['config_id'] = configId;
    // data['company_id'] = companyId;
    data['amount_total'] = amountTotal;
    data['sequence_number'] = sequenceNumber;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    data["pos_reference"] = receiptNumber;
    data["state"] = state;
    data["order_condition"] = orderCondition;
    data['amount_paid'] = amountPaid;
    data['amount_return'] = amountReturn;
    data['amount_tax'] = amountTax;
    data['loyalty_points'] = loyaltyPoints;
    data['nb_print'] = nbPrint;
    data['points_won'] = pointsWon;
    data['pricelist_id'] = pricelistId;
    data['qr_dt'] = qrDt;
    data['return_status'] = returnStatus;
    data['tip_amount'] = tipAmount;
    data['to_invoice'] = toInvoice.toString();
    data['to_ship'] = toShip.toString();
    data['total_item'] = totalItem;
    data['total_qty'] = totalQty;
    data['user_id'] = userId;
    data['sequence_id'] = sequenceId;
    data['sequence_line_id'] = sequenceLineId;
    return data;
  }
}
