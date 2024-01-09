class Customer {
  int? id;
  String? name;
  int? blockingStage;
  String? street;
  String? city;
  int? stateId;
  int? countryId;
  String? vat;
  String? lang;
  String? phone;
  String? zip;
  String? mobile;
  String? email;
  int? companyId;
  List? propertyProductPricelist;
  String? barcode;
  int? propertyAccountPositionId;

  Customer(
    this.id, {
    this.name,
      this.blockingStage,
    this.street,
      this.city,
    this.stateId,
      this.countryId,
    this.vat,
    this.lang,
      this.phone,
    this.zip,
    this.mobile,
    this.email,
    this.companyId,
      this.propertyProductPricelist,
    this.barcode,
    this.propertyAccountPositionId,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    blockingStage = int.tryParse(json['blocking_stage'].toString());
    street = json['street'];
    city = json['city'];
    stateId = int.tryParse(json['state_id'].toString());
    countryId = int.tryParse(json['country_id'].toString());
    vat = json['vat'];
    lang = json['lang'];
    phone = json['phone'];
    zip = json['zip'];
    mobile = json['mobile'];
    email = json['email'];
    companyId = int.tryParse(json['company_id'].toString());
    propertyProductPricelist = json['property_product_pricelist'];
    barcode = json['barcode'];
    propertyAccountPositionId =
        int.tryParse(json['property_account_position_id'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['blocking_stage'] = blockingStage;
    data['street'] = street;
    data['city'] = city;
    data['state_id'] = stateId;
    data['country_id'] = countryId;
    data['vat'] = vat;
    data['lang'] = lang;
    data['phone'] = phone;
    data['zip'] = zip;
    data['mobile'] = mobile;
    data['email'] = email;
    data['company_id'] = companyId;
    data['property_product_pricelist'] = propertyProductPricelist;
    data['barcode'] = barcode;
    data['property_account_position_id'] = propertyAccountPositionId;
    return data;
  }
}
