class PaymentTransaction {
  int? id;
  int? orderId;
  String? paymentDate;
  int? paymentMethodId;
  String? amount;

  PaymentTransaction(
      {this.id,
      this.orderId,
      this.paymentDate,
      this.paymentMethodId,
      this.amount});

  PaymentTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    paymentDate = json['payment_date'];
    paymentMethodId = json['payment_method_id'];
    amount = json['amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['payment_date'] = paymentDate;
    data['payment_method_id'] = paymentMethodId;
    data['amount'] = amount;
    return data;
  }
}
