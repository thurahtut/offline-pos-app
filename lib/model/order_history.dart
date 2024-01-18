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
  int? companyId;
  int? amountTotal;
  String? sequenceNumber;
  String? writeDate;
  int? writeUid;
  List<OrderLineID>? lineIds;

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
    this.companyId,
    this.amountTotal,
    this.sequenceNumber,
    this.writeDate,
    this.writeUid,
    this.lineIds,
  });

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sessionId = json['session_id'];
    dateOrder = json['date_order'];
    employeeId = json['employee_id'];
    partnerId = json['partner_id'];
    createDate = json['create_date'];
    createUid = json['create_uid'];
    configId = json['config_id'];
    companyId = json['company_id'];
    amountTotal = json['amount_total'];
    sequenceNumber = json['sequence_number'];
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
    lineIds = json["line_ids"];
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
    data['company_id'] = companyId;
    data['amount_total'] = amountTotal;
    data['sequence_number'] = sequenceNumber;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    data["line_ids"] = lineIds;
    return data;
  }
}
