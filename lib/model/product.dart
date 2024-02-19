import 'dart:convert';

import 'package:offline_pos/model/price_list_item.dart';

class Product {
  int? productId;
  String? productName;
  int? categoryId;
  bool? isRoundingProduct;
  bool? shIsBundle;
  int? shSecondaryUom;
  int? posCategId;
  int? writeUid;
  String? writeDate;
  String? productType;
  List<int>? productVariantIds;
  List<int>? taxesId;
  String? barcode;
  int? onhandQuantity;
  PriceListItem? priceListItem;
  bool? firstTime;
  int? taxPercent;

  Product({
    this.productId,
    this.productName,
    this.categoryId,
    this.isRoundingProduct,
    this.shIsBundle,
    this.shSecondaryUom,
    this.posCategId,
    this.writeUid,
    this.writeDate,
    this.productType,
    this.productVariantIds,
    this.taxesId,
    this.barcode,
    this.onhandQuantity,
    this.priceListItem,
    this.firstTime,
    this.taxPercent,
  });

  Product.fromJson(Map<String, dynamic> json, {int? pId}) {
    productId = pId ?? json['id'];
    productName = json['name'];
    categoryId = int.tryParse(json['categ_id'].toString());
    isRoundingProduct =
        json['is_rounding_product'] == 1 || json['is_rounding_product'] == true
            ? true
            : false;
    shIsBundle = json['sh_is_bundle'] == 1 || json['sh_is_bundle'] == true
        ? true
        : false;
    shSecondaryUom = json['sh_secondary_uom'];
    posCategId = int.tryParse(json['pos_categ_id'].toString());
    writeUid = int.tryParse(json['write_uid'].toString());
    writeDate = json['write_date'];
    productType = json['type'];
    if ((json['product_variant_ids']?.isNotEmpty ?? false) &&
        json['product_variant_ids'] != "null") {
      if (json['product_variant_ids'] is List) {
        try {
          productVariantIds = json['product_variant_ids'].cast<int>();
        } catch (_) {}
      } else if (json['product_variant_ids'] is String) {
        productVariantIds = jsonDecode(json['product_variant_ids']).cast<int>();
      }
    }
    if ((json['taxes_id']?.isNotEmpty ?? false) && json['taxes_id'] != "null") {
      if (json['taxes_id'] is List) {
        try {
          taxesId = json['taxes_id'].cast<int>();
        } catch (_) {}
      } else if (json['taxes_id'] is String) {
        taxesId = jsonDecode(json['taxes_id']).cast<int>();
      }
    }
    barcode = json['barcode'];
    onhandQuantity =
        double.tryParse(json['onhand_quantity'].toString())?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = productId;
    data['name'] = productName;
    data['categ_id'] = categoryId;
    data['is_rounding_product'] = isRoundingProduct;
    data['sh_is_bundle'] = shIsBundle;
    data['sh_secondary_uom'] = shSecondaryUom;
    data['pos_categ_id'] = posCategId;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    data['type'] = productType;
    if (productVariantIds != null) {
      data['product_variant_ids'] = jsonEncode(productVariantIds);
    }
    if (taxesId != null) {
      data['taxes_id'] = jsonEncode(taxesId);
    }
    data['barcode'] = barcode;
    data['onhand_quantity'] = onhandQuantity?.toString();
    return data;
  }

Product cloneProduct() {
    return Product.fromJson(jsonDecode(jsonEncode(this)));
  }
}
