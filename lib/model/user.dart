import '../components/export_files.dart';

class User {
  UserData? userData;
  PartnerData? partnerData;
  Employee? employeeData;
  List<ConfigData>? configData;

  User({this.userData, this.partnerData, this.employeeData, this.configData});

  User.fromJson(Map<String, dynamic> json) {
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    partnerData = json['partner_data'] != null
        ? PartnerData.fromJson(json['partner_data'])
        : null;
    employeeData = json['employee_data'] != null
        ? Employee.fromJson(json['employee_data'])
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
