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
  double? discount;
  String? writeDate;
  int? writeUid;
  String? barcode;
  int? parentPromotionId;
  bool? isPromoItem;
  bool? onOrderPromo;
  String? shDiscountCode;
  String? shDiscountReason;
  int? referenceOrderlineId;
  int? refundedOrderLineId;
  int? odooOrderLineId;
  String? packaging;
  int? packageId;
  String? packageQty;

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
    this.shDiscountCode,
    this.shDiscountReason,
    this.referenceOrderlineId,
    this.refundedOrderLineId,
    this.odooOrderLineId,
    this.packaging,
    this.packageId,
    this.packageQty,
  });

  OrderLineID.fromJson(Map<String, dynamic> json, {bool? isOnlyForDatabase}) {
    id = int.tryParse(json['f_id']?.toString() ?? '');
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
    discount = double.tryParse(json['discount']?.toString() ?? '');
    writeDate = json['write_date'];
    writeUid = int.tryParse(json['write_uid']?.toString() ?? '');
    barcode = json["barcode"];
    if (isOnlyForDatabase == true) {
      parentPromotionId =
          int.tryParse(json["parent_promotion_id"]?.toString() ?? '');
      isPromoItem = bool.tryParse(json["is_promo_item"]?.toString() ?? '');
      onOrderPromo = bool.tryParse(json["on_order_item"]?.toString() ?? '');
    }
    shDiscountCode = json['sh_discount_code'];
    shDiscountReason = json['sh_discount_reason'];
    referenceOrderlineId = json['reference_orderline_id'];
    refundedOrderLineId = json['refunded_orderline_id'];
    odooOrderLineId = json['odoo_order_line_id'];
    packaging = json["packaging"];
    packageId = json["package_id"];
    packageQty = json["package_qty"];
  }

  Map<String, dynamic> toJson({bool? isOnlyForDatabase}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_id'] = id?.toString();
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
    data['sh_discount_code'] = shDiscountCode;
    data['sh_discount_reason'] = shDiscountReason;
    data['reference_orderline_id'] = referenceOrderlineId;
    data['refunded_orderline_id'] = refundedOrderLineId;
    data['odoo_order_line_id'] = odooOrderLineId;
    data["packaging"] = packaging;
    data["package_id"] = packageId;
    data["package_qty"] = packageQty;
    return data;
  }
}
