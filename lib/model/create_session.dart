class CreateSession {
  PosSession? posSession;
  MailMessage? mailMessage;

  CreateSession({this.posSession, this.mailMessage});

  CreateSession.fromJson(Map<String, dynamic> json) {
    posSession = json['pos_session'] != null
        ? PosSession.fromJson(json['pos_session'])
        : null;
    mailMessage = json['mail_message'] != null
        ? MailMessage.fromJson(json['mail_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (posSession != null) {
      data['pos_session'] = posSession!.toJson();
    }
    if (mailMessage != null) {
      data['mail_message'] = mailMessage!.toJson();
    }
    return data;
  }
}

class PosSession {
  int? configId;
  String? createDate;
  int? createUid;
  bool? finishedCogs;
  int? loginNumber;
  bool? running;
  int? sequenceNumber;
  String? state;
  String? startAt;
  bool? toRunCogs;
  bool? updateStockAtClosing;
  int? userId;

  PosSession(
      {this.configId,
      this.createDate,
      this.createUid,
      this.finishedCogs,
      this.loginNumber,
      this.running,
      this.sequenceNumber,
      this.state,
      this.startAt,
      this.toRunCogs,
      this.updateStockAtClosing,
      this.userId});

  PosSession.fromJson(Map<String, dynamic> json) {
    configId = json['config_id'];
    createDate = json['create_date'];
    createUid = json['create_uid'];
    finishedCogs = json['finished_cogs'];
    loginNumber = json['login_number'];
    running = json['running'];
    sequenceNumber = json['sequence_number'];
    state = json['state'];
    startAt = json['start_at'];
    toRunCogs = json['to_run_cogs'];
    updateStockAtClosing = json['update_stock_at_closing'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['config_id'] = configId;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['finished_cogs'] = finishedCogs;
    data['login_number'] = loginNumber;
    data['running'] = running;
    data['sequence_number'] = sequenceNumber;
    data['state'] = state;
    data['start_at'] = startAt;
    data['to_run_cogs'] = toRunCogs;
    data['update_stock_at_closing'] = updateStockAtClosing;
    data['user_id'] = userId;
    return data;
  }
}

class MailMessage {
  bool? addSign;
  int? authorId;
  String? body;
  String? createDate;
  int? createUid;
  String? date;
  String? emailFrom;
  bool? isInternal;
  String? messageType;
  String? model;
  String? replyTo;

  MailMessage(
      {this.addSign,
      this.authorId,
      this.body,
      this.createDate,
      this.createUid,
      this.date,
      this.emailFrom,
      this.isInternal,
      this.messageType,
      this.model,
      this.replyTo});

  MailMessage.fromJson(Map<String, dynamic> json) {
    addSign = json['add_sign'];
    authorId = json['author_id'];
    body = json['body'];
    createDate = json['create_date'];
    createUid = json['create_uid'];
    date = json['date'];
    emailFrom = json['email_from'];
    isInternal = json['is_internal'];
    messageType = json['message_type'];
    model = json['model'];
    replyTo = json['reply_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['add_sign'] = addSign;
    data['author_id'] = authorId;
    data['body'] = body;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['date'] = date;
    data['email_from'] = emailFrom;
    data['is_internal'] = isInternal;
    data['message_type'] = messageType;
    data['model'] = model;
    data['reply_to'] = replyTo;
    return data;
  }
}
