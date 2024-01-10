import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

class AppConfig {
  String? themeBodyColor;
  Uint8List? logo;
  String? dbVersion;

  AppConfig({this.themeBodyColor, this.logo, this.dbVersion});

  AppConfig.fromJson(Map<String, dynamic> json) {
    themeBodyColor = json['theme_body_color'];
    if (json['logo'] != null && json['logo'] != "") {
      try {
        // String s = String.fromCharCodes(json['logo']);
        var outputAsUint8List = Uint8List.fromList(base64Decode(json['logo']));
        logo = outputAsUint8List;
      } catch (_) {}
    }
    // logo = json['logo'];
    dbVersion = json['db_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['theme_body_color'] = themeBodyColor;
    if (logo != null && logo!.isNotEmpty) {
      data['logo'] = base64Encode(logo!);
    }
    // data['logo'] = logo;
    data['db_version'] = dbVersion;
    return data;
  }
}
