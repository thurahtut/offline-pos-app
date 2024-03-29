import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

class ProductPackaging {
  int? id;
  int? productId;
  String? name;
  IdAndName? packageTypeId;
  String? qty;
  String? barcode;
  bool? sales;
  IdAndName? productUomId;
  PriceListItem? priceListItem;

  ProductPackaging({
    this.id,
    this.productId,
    this.name,
    this.packageTypeId,
    this.qty,
    this.barcode,
    this.sales,
    this.productUomId,
    this.priceListItem,
  });

  ProductPackaging.fromJson(Map<String, dynamic> json, {int? packagingId}) {
    id = packagingId ?? json['id'];
    productId = json['product_id'];
    name = json['name'];
    if (json['package_type_id'] != null && json['package_type_id'] != "null") {
      if (json['package_type_id'] is Map) {
        try {
          packageTypeId = IdAndName.fromJson(json['package_type_id']);
        } catch (_) {}
      } else if (json['package_type_id'] is String) {
        packageTypeId = IdAndName.fromJson(jsonDecode(json['package_type_id']));
      }
    }
    qty = json['qty']?.toString() ?? '';
    // double.tryParse(json['qty']?.toString() ?? '')?.toInt().toString() ??
    //     "0.00";
    barcode = json['barcode'];
    sales = bool.tryParse(json['sales']?.toString() ?? '');
    if (json['product_uom_id'] != null && json['product_uom_id'] != "null") {
      if (json['product_uom_id'] is Object) {
        try {
          productUomId = IdAndName.fromJson(json['product_uom_id']);
        } catch (_) {}
      } else if (json['product_uom_id'] is String) {
        productUomId = IdAndName.fromJson(jsonDecode(json['product_uom_id']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data['product_id'] = productId;
    data['name'] = name;
    if (packageTypeId != null) {
      data['package_type_id'] = jsonEncode(packageTypeId);
    }
    data['qty'] = qty;
    data['barcode'] = barcode;
    data['sales'] = sales?.toString() ?? false;
    if (productUomId != null) {
      data['product_uom_id'] = jsonEncode(productUomId);
    }
    return data;
  }
}
