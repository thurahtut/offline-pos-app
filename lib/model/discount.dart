class Discount {
  int? id;
  String? shDiscountName;
  String? shDiscountCode;
  double? shDiscountValue;
  int? createUid;
  String? createDate;
  int? writeUid;
  String? writeDate;

  Discount(
      {this.id,
      this.shDiscountName,
      this.shDiscountCode,
      this.shDiscountValue,
      this.createUid,
      this.createDate,
      this.writeUid,
      this.writeDate});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shDiscountName = json['sh_discount_name'];
    shDiscountCode = json['sh_discount_code'];
    shDiscountValue =
        double.tryParse(json['sh_discount_value']?.toString() ?? '');
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sh_discount_name'] = shDiscountName;
    data['sh_discount_code'] = shDiscountCode;
    data['sh_discount_value'] = shDiscountValue;
    data['create_uid'] = createUid;
    data['create_date'] = createDate;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    return data;
  }
}
