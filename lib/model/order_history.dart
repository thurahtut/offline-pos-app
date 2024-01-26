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
  String? configName;
  // int? companyId;
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
    this.configName,
    // this.companyId,
    this.amountTotal,
    this.sequenceNumber,
    this.writeDate,
    this.writeUid,
    this.lineIds,
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
    return data;
  }
}
