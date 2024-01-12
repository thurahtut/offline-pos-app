class User {
  UserData? userData;
  PartnerData? partnerData;
  EmployeeData? employeeData;
  List<ConfigData>? configData;

  User({this.userData, this.partnerData, this.employeeData, this.configData});

  User.fromJson(Map<String, dynamic> json) {
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    partnerData = json['partner_data'] != null
        ? PartnerData.fromJson(json['partner_data'])
        : null;
    employeeData = json['employee_data'] != null
        ? EmployeeData.fromJson(json['employee_data'])
        : null;
    if (json['config_data'] != null) {
      configData = <ConfigData>[];
      json['config_data'].forEach((v) {
        configData!.add(ConfigData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    if (partnerData != null) {
      data['partner_data'] = partnerData!.toJson();
    }
    if (employeeData != null) {
      data['employee_data'] = employeeData!.toJson();
    }
    if (configData != null) {
      data['config_data'] = configData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? login;

  UserData({this.id, this.login});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    return data;
  }
}

class PartnerData {
  int? id;
  String? name;

  PartnerData({this.id, this.name});

  PartnerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class EmployeeData {
  int? id;
  String? name;
  String? pin;
  String? workEmail;
  String? workPhone;
  String? jobTitle;

  EmployeeData(
      {this.id,
      this.name,
      this.pin,
      this.workEmail,
      this.workPhone,
      this.jobTitle});

  EmployeeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pin = json['pin'];
    workEmail = json['work_email'];
    workPhone = json['work_phone'];
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pin'] = pin;
    data['work_email'] = workEmail;
    data['work_phone'] = workPhone;
    data['job_title'] = jobTitle;
    return data;
  }
}

class ConfigData {
  int? id;
  String? name;

  ConfigData({this.id, this.name});

  ConfigData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
