class POSSession {
  int? id;
  String? name;
  int? userId;
  int? configId;
  String? startAt;
  String? stopAt;
  int? sequenceNumber;
  int? cashRegisterId;
  String? state;
  bool? updateStockAtClosing;
  List<int>? paymentMethodIds;

  POSSession(
      {this.id,
      this.name,
      this.userId,
      this.configId,
      this.startAt,
      this.stopAt,
      this.sequenceNumber,
      this.cashRegisterId,
      this.state,
      this.updateStockAtClosing,
      this.paymentMethodIds});

  POSSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    configId = json['config_id'];
    startAt = json['start_at'];
    stopAt = json['stop_at'];
    sequenceNumber = json['sequence_number'];
    cashRegisterId = json['cash_register_id'];
    state = json['state'];
    updateStockAtClosing = json['update_stock_at_closing'];
    paymentMethodIds = json['payment_method_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['config_id'] = configId;
    data['start_at'] = startAt;
    data['stop_at'] = stopAt;
    data['sequence_number'] = sequenceNumber;
    data['cash_register_id'] = cashRegisterId;
    data['state'] = state;
    data['update_stock_at_closing'] = updateStockAtClosing;
    data['payment_method_ids'] = paymentMethodIds;
    return data;
  }
}
