class PaymentTransaction {
  int? id;
  int? orderId;
  String? paymentDate;
  int? paymentMethodId;
  String? amount;
  bool? firstTime;
  String? paymentMethodName;
  String? cardType;
  String? cardholderName;
  String? createDate;
  int? createUid;
  bool? isChange;
  String? paymentStatus;
  int? sessionId;
  String? ticket;
  String? transactionId;
  String? writeDate;
  int? writeUid;
  String? payingAmount;

  PaymentTransaction({
    this.id,
    this.orderId,
    this.paymentDate,
    this.paymentMethodId,
    this.amount,
    this.firstTime = true,
    this.paymentMethodName,
    this.cardType,
    this.cardholderName,
    this.createDate,
    this.createUid,
    this.isChange,
    this.paymentStatus,
    this.sessionId,
    this.ticket,
    this.transactionId,
    this.writeDate,
    this.writeUid,
    this.payingAmount,
  });

  PaymentTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = int.tryParse(json['order_id']?.toString() ?? '');
    paymentDate = json['payment_date'];
    paymentMethodId = int.tryParse(json['payment_method_id']?.toString() ?? '');
    amount = json['amount'].toString();
    paymentMethodName = json["name"];
    cardType = json['card_type'];
    cardholderName = json['cardholder_name'];
    createDate = json['create_date'];
    createUid = int.tryParse(json['create_uid']?.toString() ?? '');
    isChange = bool.tryParse(json['is_change']?.toString() ?? '');
    paymentStatus = json['payment_status'];
    sessionId = int.tryParse(json['session_id']?.toString() ?? '');
    ticket = json['ticket'];
    transactionId = json['transaction_id'];
    writeDate = json['write_date'];
    writeUid = int.tryParse(json['write_uid']?.toString() ?? '');
  }

  Map<String, dynamic> toJson({bool? includedOtherField}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['payment_date'] = paymentDate;
    data['payment_method_id'] = paymentMethodId;
    data['name'] = paymentMethodName;
    data['amount'] = amount;
    data['card_type'] = cardType;
    data['cardholder_name'] = cardholderName;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['is_change'] = isChange?.toString();
    data['payment_status'] = paymentStatus;
    data['session_id'] = sessionId;
    data['ticket'] = ticket;
    data['transaction_id'] = transactionId;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    return data;
  }
}
