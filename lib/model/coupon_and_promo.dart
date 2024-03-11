class CouponAndPromo {
  List<PromoProgramIds>? promoProgramIds;
  List<CouponProgramIds>? couponProgramIds;

  CouponAndPromo({this.promoProgramIds, this.couponProgramIds});

  CouponAndPromo.fromJson(Map<String, dynamic> json) {
    if (json['promo_program_ids'] != null) {
      promoProgramIds = <PromoProgramIds>[];
      json['promo_program_ids'].forEach((v) {
        promoProgramIds!.add(PromoProgramIds.fromJson(v));
      });
    }
    if (json['coupon_program_ids'] != null) {
      couponProgramIds = <CouponProgramIds>[];
      json['coupon_program_ids'].forEach((v) {
        couponProgramIds!.add(CouponProgramIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (promoProgramIds != null) {
      data['promo_program_ids'] =
          promoProgramIds!.map((v) => v.toJson()).toList();
    }
    if (couponProgramIds != null) {
      data['coupon_program_ids'] =
          couponProgramIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromoProgramIds {
  int? id;
  String? name;
  bool? active;
  RuleId? ruleId;
  int? rewardId;
  int? sequence;
  int? maximumUseNumber;
  String? programType;
  String? promoCodeUsage;
  int? promoCode;
  String? promoApplicability;
  int? companyId;
  int? validityDuration;
  int? createUid;
  String? createDate;
  int? writeUid;
  String? writeDate;
  String? promoBarcode;
  int? websiteId;
  bool? combinePromotion;
  bool? breakMultiple;
  int? ownPercent;
  String? dealName;
  String? dealDetail;
  String? storeType;
  int? appSequence;
  String? videoUrl;
  bool? excludePosOrder;

  PromoProgramIds(
      {this.id,
      this.name,
      this.active,
      this.ruleId,
      this.rewardId,
      this.sequence,
      this.maximumUseNumber,
      this.programType,
      this.promoCodeUsage,
      this.promoCode,
      this.promoApplicability,
      this.companyId,
      this.validityDuration,
      this.createUid,
      this.createDate,
      this.writeUid,
      this.writeDate,
      this.promoBarcode,
      this.websiteId,
      this.combinePromotion,
      this.breakMultiple,
      this.ownPercent,
      this.dealName,
      this.dealDetail,
      this.storeType,
      this.appSequence,
      this.videoUrl,
      this.excludePosOrder});

  PromoProgramIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
    ruleId = json['rule_id'] != null ? RuleId.fromJson(json['rule_id']) : null;
    rewardId = json['reward_id'];
    sequence = json['sequence'];
    maximumUseNumber = json['maximum_use_number'];
    programType = json['program_type'];
    promoCodeUsage = json['promo_code_usage'];
    promoCode = json['promo_code'];
    promoApplicability = json['promo_applicability'];
    companyId = json['company_id'];
    validityDuration = json['validity_duration'];
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
    promoBarcode = json['promo_barcode'];
    websiteId = json['website_id'];
    combinePromotion = json['combine_promotion'];
    breakMultiple = json['break_multiple'];
    ownPercent = json['own_percent'];
    dealName = json['deal_name'];
    dealDetail = json['deal_detail'];
    storeType = json['store_type'];
    appSequence = json['app_sequence'];
    videoUrl = json['video_url'];
    excludePosOrder = json['exclude_pos_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active;
    if (ruleId != null) {
      data['rule_id'] = ruleId!.toJson();
    }
    data['reward_id'] = rewardId;
    data['sequence'] = sequence;
    data['maximum_use_number'] = maximumUseNumber;
    data['program_type'] = programType;
    data['promo_code_usage'] = promoCodeUsage;
    data['promo_code'] = promoCode;
    data['promo_applicability'] = promoApplicability;
    data['company_id'] = companyId;
    data['validity_duration'] = validityDuration;
    data['create_uid'] = createUid;
    data['create_date'] = createDate;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    data['promo_barcode'] = promoBarcode;
    data['website_id'] = websiteId;
    data['combine_promotion'] = combinePromotion;
    data['break_multiple'] = breakMultiple;
    data['own_percent'] = ownPercent;
    data['deal_name'] = dealName;
    data['deal_detail'] = dealDetail;
    data['store_type'] = storeType;
    data['app_sequence'] = appSequence;
    data['video_url'] = videoUrl;
    data['exclude_pos_order'] = excludePosOrder;
    return data;
  }
}

class RuleId {
  int? id;
  String? ruleDateFrom;
  String? ruleDateTo;
  String? rulePartnersDomain;
  String? ruleProductsDomain;
  int? ruleMinimumAmount;
  String? ruleMinimumAmountTaxInclusion;

  RuleId(
      {this.id,
      this.ruleDateFrom,
      this.ruleDateTo,
      this.rulePartnersDomain,
      this.ruleProductsDomain,
      this.ruleMinimumAmount,
      this.ruleMinimumAmountTaxInclusion});

  RuleId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ruleDateFrom = json['rule_date_from'];
    ruleDateTo = json['rule_date_to'];
    rulePartnersDomain = json['rule_partners_domain'];
    ruleProductsDomain = json['rule_products_domain'];
    ruleMinimumAmount = json['rule_minimum_amount'];
    ruleMinimumAmountTaxInclusion = json['rule_minimum_amount_tax_inclusion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rule_date_from'] = ruleDateFrom;
    data['rule_date_to'] = ruleDateTo;
    data['rule_partners_domain'] = rulePartnersDomain;
    data['rule_products_domain'] = ruleProductsDomain;
    data['rule_minimum_amount'] = ruleMinimumAmount;
    data['rule_minimum_amount_tax_inclusion'] = ruleMinimumAmountTaxInclusion;
    return data;
  }
}

class CouponProgramIds {
  int? id;
  String? name;

  CouponProgramIds({this.id, this.name});

  CouponProgramIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
