class PriceListItem {
  int? id;
  int? productTmplId;
  double? minQuantity;
  String? appliedOn;
  int? currencyId;
  String? dateStart;
  String? dateEnd;
  double? computePrice;
  double? fixedPrice;
  double? percentPrice;
  String? writeDate;
  int? writeUid;

  PriceListItem(
      {this.id,
      this.productTmplId,
      this.minQuantity,
      this.appliedOn,
      this.currencyId,
      this.dateStart,
      this.dateEnd,
      this.computePrice,
      this.fixedPrice,
      this.percentPrice,
      this.writeDate,
      this.writeUid});

  PriceListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productTmplId = json['product_tmpl_id'];
    minQuantity = double.tryParse(json['min_quantity'].toString());
    appliedOn = json['applied_on'];
    currencyId = json['currency_id'];
    dateStart = json['date_start'];
    dateEnd = json['date_end'];
    computePrice = double.tryParse(json['compute_price'].toString());
    fixedPrice = double.tryParse(json['fixed_price'].toString());
    percentPrice = double.tryParse(json['percent_price'].toString());
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_tmpl_id'] = productTmplId;
    data['min_quantity'] = minQuantity;
    data['applied_on'] = appliedOn;
    data['currency_id'] = currencyId;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    data['compute_price'] = computePrice;
    data['fixed_price'] = fixedPrice;
    data['percent_price'] = percentPrice;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    return data;
  }
}
