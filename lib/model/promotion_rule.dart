import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

class PromotionRule {
  int? id;
  String? ruleDateFrom;
  String? ruleDateTo;
  String? rulePartnersDomain;
  int? ruleMinQuantity;
  int? ruleMinimumAmount;
  String? ruleMinimumAmountTaxInclusion;
  int? createUid;
  String? createDate;
  int? writeUid;
  String? writeDate;
  bool? isAny;
  List<IdAndName>? validProductIds;

  PromotionRule({
    this.id,
    this.ruleDateFrom,
    this.ruleDateTo,
    this.rulePartnersDomain,
    this.ruleMinQuantity,
    this.ruleMinimumAmount,
    this.ruleMinimumAmountTaxInclusion,
    this.createUid,
    this.createDate,
    this.writeUid,
    this.writeDate,
    this.isAny,
    this.validProductIds,
  });

  PromotionRule.fromJson(Map<String, dynamic> json, {int? ruleId}) {
    id = ruleId ?? json['id'];
    ruleDateFrom = json['rule_date_from'];
    ruleDateTo = json['rule_date_to'];
    rulePartnersDomain = json['rule_partners_domain'];
    ruleMinQuantity = int.tryParse(json['rule_min_quantity']?.toString() ?? '');
    ruleMinimumAmount =
        int.tryParse(json['rule_minimum_amount']?.toString() ?? '');
    ruleMinimumAmountTaxInclusion = json['rule_minimum_amount_tax_inclusion'];
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
    isAny = bool.tryParse(json['is_any']?.toString() ?? '');
    if (json['valid_product_ids'] != null) {
      validProductIds = <IdAndName>[];
      if (json['valid_product_ids'] is String) {
        jsonDecode(json['valid_product_ids']).forEach((v) {
          validProductIds!.add(IdAndName.fromJson(v));
        });
      } else {
        json['valid_product_ids'].forEach((v) {
          validProductIds!.add(IdAndName.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rule_date_from'] = ruleDateFrom;
    data['rule_date_to'] = ruleDateTo;
    data['rule_partners_domain'] = rulePartnersDomain;
    data['rule_min_quantity'] = ruleMinQuantity;
    data['rule_minimum_amount'] = ruleMinimumAmount;
    data['rule_minimum_amount_tax_inclusion'] = ruleMinimumAmountTaxInclusion;
    data['create_uid'] = createUid;
    data['create_date'] = createDate;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    data['is_any'] = isAny?.toString() ?? 'false';
    if (validProductIds != null) {
      data['valid_product_ids'] = jsonEncode(validProductIds);
    }
    return data;
  }
}
