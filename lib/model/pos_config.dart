class POSConfig {
  int? id;
  String? name;
  int? pricelistId;
  bool? shDisplayStock;
  bool? shShowQtyLocation;
  int? shPosLocation;
  List<int>? paymentMethodIds;
  String? receiptHeader;
  String? receiptFooter;
  int? sequenceLineId;
  int? sequenceId;
  double? startingAmt;
  List<int>? posCategoryIds;

  POSConfig({
    this.id,
    this.name,
    this.pricelistId,
    this.shDisplayStock,
    this.shShowQtyLocation,
    this.shPosLocation,
    this.paymentMethodIds,
    this.receiptHeader,
    this.receiptFooter,
    this.sequenceLineId,
    this.sequenceId,
    this.startingAmt,
    this.posCategoryIds,
  });

  POSConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pricelistId = json['pricelist_id'];
    shDisplayStock = json['sh_display_stock'];
    shShowQtyLocation = json['sh_show_qty_location'];
    shPosLocation = json['sh_pos_location'];
    paymentMethodIds = json['payment_method_ids']?.cast<int>();
    receiptHeader = json['receipt_header'];
    receiptFooter = json['receipt_footer'];
    sequenceLineId = json["sequence_line_id"];
    sequenceId = json["sequence_id"];
    startingAmt = double.tryParse(json["starting_amt"]?.toString() ?? '');
    posCategoryIds = json['pos_category_ids']?.cast<int>();
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
    data['receipt_header'] = receiptHeader;
    data['receipt_footer'] = receiptFooter;
    data["sequence_line_id"] = sequenceLineId;
    data['sequence_id'] = sequenceId;
    data["starting_amt"] = startingAmt;
    data['pos_category_ids'] = posCategoryIds;
    return data;
  }
}
