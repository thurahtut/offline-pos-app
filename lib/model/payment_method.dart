class PaymentMethod {
  int? id;
  String? name;
  int? outstandingAccountId;
  int? receivableAccountId;
  bool? isCashCount;
  int? journalId;
  bool? splitTransactions;
  int? companyId;
  bool? usePaymentTerminal;
  bool? active;
  int? createUid;
  String? createDate;
  int? writeUid;
  String? writeDate;
  bool? walletMethod;
  bool? forPoints;

  PaymentMethod(
      {this.id,
      this.name,
      this.outstandingAccountId,
      this.receivableAccountId,
      this.isCashCount,
      this.journalId,
      this.splitTransactions,
      this.companyId,
      this.usePaymentTerminal,
      this.active,
      this.createUid,
      this.createDate,
      this.writeUid,
      this.writeDate,
      this.walletMethod,
      this.forPoints});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    outstandingAccountId = json['outstanding_account_id'];
    receivableAccountId = json['receivable_account_id'];
    isCashCount = bool.tryParse(json['is_cash_count'].toString());
    journalId = json['journal_id'];
    splitTransactions = bool.tryParse(json['split_transactions'].toString());
    companyId = json['company_id'];
    usePaymentTerminal = bool.tryParse(json['use_payment_terminal'].toString());
    active = bool.tryParse(json['active'].toString());
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
    walletMethod = bool.tryParse(json['wallet_method'].toString());
    forPoints = bool.tryParse(json['for_points'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['outstanding_account_id'] = outstandingAccountId;
    data['receivable_account_id'] = receivableAccountId;
    data['is_cash_count'] = isCashCount?.toString();
    data['journal_id'] = journalId;
    data['split_transactions'] = splitTransactions?.toString();
    data['company_id'] = companyId;
    data['use_payment_terminal'] = usePaymentTerminal?.toString();
    data['active'] = active?.toString();
    data['create_uid'] = createUid;
    data['create_date'] = createDate;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    data['wallet_method'] = walletMethod?.toString();
    data['for_points'] = forPoints?.toString();
    return data;
  }
}
