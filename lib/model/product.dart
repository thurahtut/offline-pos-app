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
  List<int>? productVariantIds;
  String? barcode;
  double? onhandQuantity;
  PriceListItem? priceListItem;

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
    this.productVariantIds,
    this.barcode,
    this.onhandQuantity,
    this.priceListItem,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
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
    barcode = json['barcode'];
    onhandQuantity = double.tryParse(json['onhand_quantity'].toString());
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
    if (productVariantIds != null) {
      data['product_variant_ids'] = jsonEncode(productVariantIds);
    }
    data['barcode'] = barcode;
    data['onhand_quantity'] = onhandQuantity.toString();
    return data;
  }
}
