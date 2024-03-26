class OrderLineID {
  int? id;
  int? orderId;
  int? productId;
  double? qty;
  double? priceUnit;
  double? priceSubtotal;
  double? priceSubtotalIncl;
  String? fullProductName;
  String? createDate;
  int? createUid;
  int? discount;
  String? writeDate;
  int? writeUid;
  String? barcode;
  int? parentPromotionId;
  bool? isPromoItem;
  bool? onOrderPromo;

  OrderLineID({
    this.id,
    this.orderId,
    this.productId,
    this.qty,
    this.priceUnit,
    this.priceSubtotal,
    this.priceSubtotalIncl,
    this.fullProductName,
    this.createDate,
    this.createUid,
    this.discount,
    this.writeDate,
    this.writeUid,
    this.barcode,
    this.parentPromotionId,
    this.isPromoItem,
    this.onOrderPromo,
  });

  OrderLineID.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    orderId = int.tryParse(json['order_id']?.toString() ?? '');
    productId = int.tryParse(json['product_id']?.toString() ?? '');
    qty = double.tryParse(json['qty']?.toString() ?? '');
    priceUnit = double.tryParse(json['price_unit']?.toString() ?? '');
    priceSubtotal = double.tryParse(json['price_subtotal']?.toString() ?? '');
    priceSubtotalIncl =
        double.tryParse(json['price_subtotal_incl']?.toString() ?? '');
    fullProductName = json["full_product_name"];
    createDate = json['create_date'];
    createUid = int.tryParse(json['create_uid']?.toString() ?? '');
    discount = int.tryParse(json['discount']?.toString() ?? '');
    writeDate = json['write_date'];
    writeUid = int.tryParse(json['write_uid']?.toString() ?? '');
    barcode = json["barcode"];
  }

  Map<String, dynamic> toJson({bool? isOnlyForDatabase}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id?.toString();
    data['order_id'] = orderId?.toString();
    data['product_id'] = productId?.toString();
    data['full_product_name'] = fullProductName;
    data['qty'] = qty?.toString();
    data['price_unit'] = priceUnit?.toString();
    data['price_subtotal'] = priceSubtotal?.toString();
    data['price_subtotal_incl'] = priceSubtotalIncl?.toString();
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['discount'] = discount;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    if (isOnlyForDatabase == true) {
      data["parent_promotion_id"] = parentPromotionId;
      data["is_promo_item"] = isPromoItem?.toString();
      data["on_order_item"] = onOrderPromo?.toString();
    }
    return data;
  }
}
