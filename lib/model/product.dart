class Product {
  int? productId;
  String? productName;
  int? categoryId;
  bool? isRoundingProduct;
  bool? shIsBundle;
  int? shSecondaryUom;
  String? internalRef;
  double? qty;

  Product({
    this.productId,
    this.productName,
    this.categoryId,
    this.isRoundingProduct,
    this.shIsBundle,
    this.shSecondaryUom,
    this.internalRef,
    this.qty,
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
    internalRef = json['internal_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = productId;
    data['name'] = productName;
    data['categ_id'] = categoryId;
    data['is_rounding_product'] = isRoundingProduct;
    data['sh_is_bundle'] = shIsBundle;
    data['sh_secondary_uom'] = shSecondaryUom;
    data['internal_ref'] = internalRef;
    return data;
  }
}
