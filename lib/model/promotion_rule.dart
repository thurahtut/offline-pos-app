class PromotionRule {
  int? id;
  String? ruleDateFrom;
  String? ruleDateTo;
  String? rulePartnersDomain;
  String? ruleProductsDomain;
  int? ruleMinQuantity;
  int? ruleMinimumAmount;
  String? ruleMinimumAmountTaxInclusion;
  int? createUid;
  String? createDate;
  int? writeUid;
  String? writeDate;
  bool? isAny;

  PromotionRule(
      {this.id,
      this.ruleDateFrom,
      this.ruleDateTo,
      this.rulePartnersDomain,
      this.ruleProductsDomain,
      this.ruleMinQuantity,
      this.ruleMinimumAmount,
      this.ruleMinimumAmountTaxInclusion,
      this.createUid,
      this.createDate,
      this.writeUid,
      this.writeDate,
      this.isAny});

  PromotionRule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ruleDateFrom = json['rule_date_from'];
    ruleDateTo = json['rule_date_to'];
    rulePartnersDomain = json['rule_partners_domain'];
    ruleProductsDomain = json['rule_products_domain'];
    ruleMinQuantity = json['rule_min_quantity'];
    ruleMinimumAmount = json['rule_minimum_amount'];
    ruleMinimumAmountTaxInclusion = json['rule_minimum_amount_tax_inclusion'];
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
    isAny = json['is_any'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rule_date_from'] = ruleDateFrom;
    data['rule_date_to'] = ruleDateTo;
    data['rule_partners_domain'] = rulePartnersDomain;
    data['rule_products_domain'] = ruleProductsDomain;
    data['rule_min_quantity'] = ruleMinQuantity;
    data['rule_minimum_amount'] = ruleMinimumAmount;
    data['rule_minimum_amount_tax_inclusion'] = ruleMinimumAmountTaxInclusion;
    data['create_uid'] = createUid;
    data['create_date'] = createDate;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    data['is_any'] = isAny?.toString() ?? 'false';
    return data;
  }
}
