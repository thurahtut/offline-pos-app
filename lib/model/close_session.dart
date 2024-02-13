class CloseSession {
  int? configId;
  AccountBankStatement? accountBankStatement;
  ClosePosSession? posSession;

  CloseSession({this.configId, this.accountBankStatement, this.posSession});

  CloseSession.fromJson(Map<String, dynamic> json) {
    configId = json['config_id'];
    accountBankStatement = json['account_bank_statement'] != null
        ? AccountBankStatement.fromJson(json['account_bank_statement'])
        : null;
    posSession = json['pos_session'] != null
        ? ClosePosSession.fromJson(json['pos_session'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['config_id'] = configId;
    if (accountBankStatement != null) {
      data['account_bank_statement'] = accountBankStatement!.toJson();
    }
    if (posSession != null) {
      data['pos_session'] = posSession!.toJson();
    }
    return data;
  }
}

class AccountBankStatement {
  String? balanceEnd;
  String? balanceEndReal;
  String? difference;
  String? writeDate;
  int? writeUid;

  AccountBankStatement(
      {this.balanceEnd,
      this.balanceEndReal,
      this.difference,
      this.writeDate,
      this.writeUid});

  AccountBankStatement.fromJson(Map<String, dynamic> json) {
    balanceEnd = json['balance_end'];
    balanceEndReal = json['balance_end_real'];
    difference = json['difference'];
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance_end'] = balanceEnd;
    data['balance_end_real'] = balanceEndReal;
    data['difference'] = difference;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    return data;
  }
}

class ClosePosSession {
  String? state;
  String? stopAt;
  String? writeDate;
  int? writeUid;

  ClosePosSession({this.state, this.stopAt, this.writeDate, this.writeUid});

  ClosePosSession.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    stopAt = json['stop_at'];
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['stop_at'] = stopAt;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    return data;
  }
}
