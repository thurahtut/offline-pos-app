class OrderLineID {
  int? id;
  int? orderId;
  int? productId;
  int? qty;
  int? priceUnit;
  int? priceSubtotal;
  int? priceSubtotalIncl;

  OrderLineID(
      {this.id,
      this.orderId,
      this.productId,
      this.qty,
      this.priceUnit,
      this.priceSubtotal,
      this.priceSubtotalIncl});

  OrderLineID.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    orderId = int.tryParse(json['order_id'].toString());
    productId = int.tryParse(json['product_id'].toString());
    qty = int.tryParse(json['qty'].toString());
    priceUnit = int.tryParse(json['price_unit'].toString());
    priceSubtotal = int.tryParse(json['price_subtotal'].toString());
    priceSubtotalIncl = int.tryParse(json['price_subtotal_incl'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id?.toString();
    data['order_id'] = orderId?.toString();
    data['product_id'] = productId?.toString();
    data['qty'] = qty?.toString();
    data['price_unit'] = priceUnit?.toString();
    data['price_subtotal'] = priceSubtotal?.toString();
    data['price_subtotal_incl'] = priceSubtotalIncl?.toString();
    return data;
  }
}
