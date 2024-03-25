import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

class Promotion {
  int? id;
  String? name;
  bool? active;
  int? ruleId;
  String? ruleDateFrom;
  String? ruleDateTo;
  int? rewardId;
  String? discountType;
  String? rewardType;
  int? rewardProductId;
  int? rewardProductQuantity;
  Product? rewardProduct;
  Product? freeProduct;
  int? discountFixedAmount;
  String? discountApplyOn;
  int? discountMaxAmount;
  int? discountLineProductId;
  double? discountPercentage;
  List<DiscountSpecificProductIds>? discountSpecificProductIds;
  List<Product>? discountSpecificProducts;
  int? sequence;
  int? maximumUseNumber;
  String? programType;
  String? promoCodeUsage;
  String? promoCode;
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
  PromotionRule? promotionRule;

  Promotion({
    this.id,
    this.name,
    this.active,
    this.ruleId,
    this.ruleDateFrom,
    this.ruleDateTo,
    this.rewardId,
    this.discountType,
    this.rewardType,
    this.rewardProductId,
    this.rewardProductQuantity,
    this.rewardProduct,
    this.freeProduct,
    this.discountFixedAmount,
    this.discountApplyOn,
    this.discountMaxAmount,
    this.discountLineProductId,
    this.discountPercentage,
    this.discountSpecificProductIds,
    this.discountSpecificProducts,
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
    this.excludePosOrder,
    this.promotionRule,
  });

  Promotion.fromJson(
    Map<String, dynamic> json, {
    int? promoId,
    String? promoName,
    bool? removeKey,
  }) {
    id = promoId ?? json['id'];
    name = promoName ?? json['name'];
    active = bool.tryParse(json['active']?.toString() ?? '');
    ruleId = json['rule_id'];
    ruleDateFrom = json['rule_date_from'];
    ruleDateTo = json['rule_date_to'];
    rewardId = json['reward_id'];
    discountType = json['discount_type'];
    rewardType = json['reward_type'];
    rewardProductId = json['reward_product_id'];
    rewardProductQuantity = json['reward_product_quantity'];
    discountFixedAmount =
        double.tryParse(json['discount_fixed_amount']?.toString() ?? '')
            ?.toInt();
    discountApplyOn = json['discount_apply_on'];
    discountMaxAmount =
        double.tryParse(json['discount_max_amount']?.toString() ?? '')?.toInt();
    discountLineProductId = json['discount_line_product_id'];
    discountPercentage =
        double.tryParse(json['discount_percentage']?.toString() ?? '');
    if (removeKey != true && json['discount_specific_product_ids'] != null) {
      discountSpecificProductIds = <DiscountSpecificProductIds>[];
      json['discount_specific_product_ids'].forEach((v) {
        discountSpecificProductIds!.add(DiscountSpecificProductIds.fromJson(v));
      });
    }
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
    combinePromotion =
        bool.tryParse(json['combine_promotion']?.toString() ?? '');
    breakMultiple = bool.tryParse(json['break_multiple']?.toString() ?? '');
    ownPercent = json['own_percent'];
    dealName = json['deal_name'];
    dealDetail = json['deal_detail'];
    storeType = json['store_type'];
    appSequence = json['app_sequence'];
    videoUrl = json['video_url'];
    excludePosOrder =
        bool.tryParse(json['exclude_pos_order']?.toString() ?? '');
  }

  Map<String, dynamic> toJson({bool? removeKey}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active?.toString() ?? 'false';
    data['rule_id'] = ruleId;
    data['rule_date_from'] = ruleDateFrom;
    data['rule_date_to'] = ruleDateTo;
    data['reward_id'] = rewardId;
    data['discount_type'] = discountType;
    data['reward_type'] = rewardType;
    data['reward_product_id'] = rewardProductId;
    data['reward_product_quantity'] = rewardProductQuantity;
    data['discount_fixed_amount'] = discountFixedAmount;
    data['discount_apply_on'] = discountApplyOn;
    data['discount_max_amount'] = discountMaxAmount;
    data['discount_line_product_id'] = discountLineProductId;
    data['discount_percentage'] = discountPercentage;
    if (removeKey != true && discountSpecificProductIds != null) {
      data["discount_specific_product_ids"] =
          jsonEncode(discountSpecificProductIds);
    }
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
    data['combine_promotion'] = combinePromotion?.toString() ?? 'false';
    data['break_multiple'] = breakMultiple?.toString() ?? 'false';
    data['own_percent'] = ownPercent;
    data['deal_name'] = dealName;
    data['deal_detail'] = dealDetail;
    data['store_type'] = storeType;
    data['app_sequence'] = appSequence;
    data['video_url'] = videoUrl;
    data['exclude_pos_order'] = excludePosOrder?.toString() ?? 'false';
    return data;
  }
}

class DiscountSpecificProductIds {
  int? productId;

  DiscountSpecificProductIds({this.productId});

  DiscountSpecificProductIds.fromJson(Map<String, dynamic> json) {
    productId = json['product_product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_product_id'] = productId;
    return data;
  }
}
