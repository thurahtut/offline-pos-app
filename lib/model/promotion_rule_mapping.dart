class PromotionRuleMapping {
  int? ruleId;
  int? productId;

  PromotionRuleMapping({
    this.ruleId,
    this.productId,
  });

  PromotionRuleMapping.fromJson(Map<String, dynamic> json) {
    ruleId = json['rule_id'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rule_id'] = ruleId;
    data['product_id'] = productId;
    return data;
  }
}
