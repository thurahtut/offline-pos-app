import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

class AppConfig {
  String? themeBodyColor;
  Uint8List? logo;
  String? dbVersion;
  String? productLastSyncDate;
  String? priceLastSyncDate;
  String? customerLastSyncDate;
  String? packagingLastSyncDate;
  bool? rememberPassword;

  AppConfig({
    this.themeBodyColor,
    this.logo,
    this.dbVersion,
    this.rememberPassword,
    this.priceLastSyncDate,
    this.productLastSyncDate,
    this.customerLastSyncDate,
    this.packagingLastSyncDate,
  });

  AppConfig.fromJson(Map<String, dynamic> json) {
    themeBodyColor = json['theme_body_color'];
    if (json['logo'] != null && json['logo'] != "") {
      try {
        var outputAsUint8List = Uint8List.fromList(base64Decode(json['logo']));
        logo = outputAsUint8List;
      } catch (_) {}
    }
    dbVersion = json['db_version'];
    productLastSyncDate = json['product_last_sync_date'];
    priceLastSyncDate = json['price_last_sync_date'];
    customerLastSyncDate = json['customer_last_sync_date'];
    packagingLastSyncDate = json['packaging_last_sync_date'];
    rememberPassword = bool.tryParse(json['remember_password']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['theme_body_color'] = themeBodyColor;
    if (logo != null && logo!.isNotEmpty) {
      data['logo'] = base64Encode(logo!);
    }
    data['db_version'] = dbVersion;
    data['product_last_sync_date'] = productLastSyncDate;
    data['price_last_sync_date'] = priceLastSyncDate;
    data['customer_last_sync_date'] = customerLastSyncDate;
    data['packaging_last_sync_date'] = packagingLastSyncDate;
    data['remember_password'] = rememberPassword.toString();
    return data;
  }
}
