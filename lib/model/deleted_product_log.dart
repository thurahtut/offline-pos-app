class DeletedProductLog {
  int? productId;
  String? productName;
  int? employeeId;
  int? orderId;
  String? employeeName;
  String? originalQty;
  String? updatedQty;
  int? sessionId;
  String? date;

  DeletedProductLog(
      {
    this.orderId,
    this.productId,
      this.productName,
      this.employeeId,
      this.employeeName,
      this.originalQty,
      this.updatedQty,
      this.sessionId,
    this.date,
  });

  DeletedProductLog.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    originalQty = json['original_qty'];
    updatedQty = json['updated_qty'];
    sessionId = json['session_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['employee_id'] = employeeId;
    data['employee_name'] = employeeName;
    data['original_qty'] = originalQty;
    data['updated_qty'] = updatedQty;
    data['session_id'] = sessionId;
    data['date'] = date;
    return data;
  }
}
