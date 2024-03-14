class PromotionRuleMapping {
  int? ruleId;
  int? productId;
  String? productName;

  PromotionRuleMapping({
    this.ruleId,
    this.productId,
    this.productName,
  });

  PromotionRuleMapping.fromJson(Map<String, dynamic> json) {
    ruleId = json['rule_id'];
    productId = json['product_id'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rule_id'] = ruleId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    return data;
  }
}
