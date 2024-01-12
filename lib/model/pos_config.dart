class POSConfig {
  int? id;
  String? name;
  int? pricelistId;
  bool? shDisplayStock;
  bool? shShowQtyLocation;
  int? shPosLocation;
  List<int>? paymentMethodIds;

  POSConfig(
      {this.id,
      this.name,
      this.pricelistId,
      this.shDisplayStock,
      this.shShowQtyLocation,
      this.shPosLocation,
      this.paymentMethodIds});

  POSConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pricelistId = json['pricelist_id'];
    shDisplayStock = json['sh_display_stock'];
    shShowQtyLocation = json['sh_show_qty_location'];
    shPosLocation = json['sh_pos_location'];
    paymentMethodIds = json['payment_method_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pricelist_id'] = pricelistId;
    data['sh_display_stock'] = shDisplayStock;
    data['sh_show_qty_location'] = shShowQtyLocation;
    data['sh_pos_location'] = shPosLocation;
    data['payment_method_ids'] = paymentMethodIds;
    return data;
  }
}
