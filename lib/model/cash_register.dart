class CashRegister {
  int? configId;
  String? openingNotes;
  String? createDate;
  int? createUid;
  String? date;
  String? name;
  String? state;
  int? userId;
  String? writeDate;
  int? writeUid;
  int? posSessionId;
  double? balanceStart;
  double? balanceEnd;
  double? difference;
  double? balanceEndReal;

  CashRegister(
      {this.configId,
      this.openingNotes,
      this.createDate,
      this.createUid,
      this.date,
      this.name,
      this.state,
      this.userId,
      this.writeDate,
      this.writeUid,
      this.posSessionId,
      this.balanceStart,
      this.balanceEnd,
      this.difference,
      this.balanceEndReal});

  CashRegister.fromJson(Map<String, dynamic> json) {
    configId = json['config_id'];
    openingNotes = json['opening_notes'];
    createDate = json['create_date'];
    createUid = json['create_uid'];
    date = json['date'];
    name = json['name'];
    state = json['state'];
    userId = json['user_id'];
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
    posSessionId = json['pos_session_id'];
    balanceStart = json['balance_start'];
    balanceEnd = json['balance_end'];
    difference = json['difference'];
    balanceEndReal = json['balance_end_real'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['config_id'] = configId;
    data['opening_notes'] = openingNotes;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['date'] = date;
    data['name'] = name;
    data['state'] = state;
    data['user_id'] = userId;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    data['pos_session_id'] = posSessionId;
    data['balance_start'] = balanceStart;
    data['balance_end'] = balanceEnd;
    data['difference'] = difference;
    data['balance_end_real'] = balanceEndReal;
    return data;
  }
}
