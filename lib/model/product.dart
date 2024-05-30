import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

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
  int? productVariantIds;
  List<int>? taxesId;
  String? barcode;
  int? onhandQuantity;
  int? refundQuantity;
  int? refundedQuantity;
  PriceListItem? priceListItem;
  bool? firstTime;
  AmountTax? amountTax;
  List<Promotion>? promotionList;
  int? parentPromotionId;
  bool? isPromoItem;
  bool? onOrderPromo;
  double? discount;
  String? shDiscountCode;
  String? shDiscountReason;
  Promotion? validPromotion;
  int? lineId;
  int? refundedOrderLineId;
  int? odooOrderLineId;
  String? packaging;
  int? packageId;
  String? packageQty;

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
    this.amountTax,
    this.promotionList,
    this.parentPromotionId,
    this.isPromoItem,
    this.onOrderPromo,
    this.discount,
    this.shDiscountCode,
    this.shDiscountReason,
    this.validPromotion,
    this.refundQuantity,
    this.refundedQuantity,
    this.lineId,
    this.refundedOrderLineId,
    this.odooOrderLineId,
    this.packaging,
    this.packageId,
    this.packageQty,
  });

  Product.fromJson(Map<String, dynamic> json,
      {int? pId, String? pName, bool? includedOtherField}) {
    productId = pId ?? json['id'];
    productName = pName ?? json['name'];
    categoryId = int.tryParse(json['categ_id']?.toString() ?? '');
    isRoundingProduct =
        json['is_rounding_product'] == 1 || json['is_rounding_product'] == true
            ? true
            : false;
    shIsBundle = json['sh_is_bundle'] == 1 || json['sh_is_bundle'] == true
        ? true
        : false;
    shSecondaryUom = json['sh_secondary_uom'];
    posCategId = int.tryParse(json['pos_categ_id']?.toString() ?? '');
    writeUid = int.tryParse(json['write_uid']?.toString() ?? '');
    writeDate = json['write_date'];
    productType = json['type'];
    if (json['product_variant_ids'] != null &&
        json['product_variant_ids'] != "null") {
      if (json['product_variant_ids'] is int) {
        productVariantIds = json['product_variant_ids'];
      } else if (json['product_variant_ids'] is List) {
        try {
          productVariantIds = json['product_variant_ids'][0];
        } catch (_) {}
      } else if (json['product_variant_ids'] is String) {
        List list = jsonDecode(json['product_variant_ids']).cast<int>();
        productVariantIds = list[0];
      }
    }
    if ((json['taxes_id']?.isNotEmpty ?? false) && json['taxes_id'] != "null") {
      if (json['taxes_id'] is List) {
        try {
          taxesId = json['taxes_id'].map((e) => e ?? 0).toList().cast<int>();
          // json['product_variant_ids'].cast<int>();
        } catch (_) {}
      } else if (json['taxes_id'] is String) {
        taxesId = jsonDecode(json['taxes_id'])
            .map((e) => e ?? 0)
            .toList()
            .cast<int>();
      }
    }
    barcode = json['barcode'];
    onhandQuantity =
        double.tryParse(json['onhand_quantity'].toString())?.toInt() ?? 0;
    if (includedOtherField == true) {
      if (json['priceListItem'] != null) {
        priceListItem = PriceListItem.fromJson(json['priceListItem']);
      }
      if (json['amountTax'] != null) {
        amountTax = AmountTax.fromJson(json['amountTax']);
      }
      parentPromotionId =
          int.tryParse(json['parentPromotionId']?.toString() ?? '');
      isPromoItem = bool.tryParse(json['isPromoItem']?.toString() ?? '');
      onOrderPromo = bool.tryParse(json['onOrderPromo']?.toString() ?? '');
      discount = json['discount'];
      shDiscountCode = json['shDiscountCode'];
      shDiscountReason = json['shDiscountReason'];
      if (json['validPromotion'] != null) {
        validPromotion = Promotion.fromJson(json['validPromotion']);
      }
      refundQuantity =
          double.tryParse(json['refundQuantity'].toString())?.toInt() ?? 0;
      refundedQuantity =
          double.tryParse(json['refundedQuantity'].toString())?.toInt() ?? 0;
      lineId = json['orderId'];
      refundedOrderLineId = json['refundedOrderLineId'];
      odooOrderLineId = json['odooOrderLineId'];
      packaging = json["packaging"];
      packageId = json["packageId"];
      packageQty = json['packageQty'];
    }
  }

  Map<String, dynamic> toJson({bool? removed}) {
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
    data['product_variant_ids'] = productVariantIds;
    if (taxesId != null && taxesId!.isNotEmpty) {
      data['taxes_id'] = jsonEncode(taxesId);
    }
    data['barcode'] = barcode;
    data['onhand_quantity'] = onhandQuantity?.toString();
    if (removed != true) {
      data["priceListItem"] = priceListItem?.toJson();
      data["amountTax"] = amountTax?.toJson();
      data["parentPromotionId"] = parentPromotionId;
      data["isPromoItem"] = isPromoItem;
      data["onOrderPromo"] = onOrderPromo;
      data['discount'] = discount;
      data['shDiscountCode'] = shDiscountCode;
      data['shDiscountReason'] = shDiscountReason;
      data['validPromotion'] = validPromotion?.toJson();
      data['refundQuantity'] = refundQuantity?.toString();
      data['refundedQuantity'] = refundedQuantity?.toString();
      data['orderId'] = lineId;
      data['refundedOrderLineId'] = refundedOrderLineId;
      data['odooOrderLineId'] = odooOrderLineId;
      data['packaging'] = packaging;
      data['packageId'] = packageId;
      data['packageQty'] = packageQty;
    }
    return data;
  }

  Product cloneProduct() {
    return Product.fromJson(jsonDecode(jsonEncode(this)));
  }
}
