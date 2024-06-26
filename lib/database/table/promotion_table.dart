// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/amount_tax_table.dart';
import 'package:offline_pos/database/table/promotion_rules_mapping_table.dart';
import 'package:offline_pos/database/table/promotion_rules_table.dart';
import 'package:sqflite/sqflite.dart';

const PROMOTION_TABLE_NAME = "promotion_table";
const PROMOTION_ID = "id";
const PROMOTION_NAME = "name";
const PROMOTION_ACTIVE = "active";
const RULE_ID = "rule_id";
const RULE_DATE_FROM = "rule_date_from";
const RULE_DATE_TO = "rule_date_to";
const REWARD_ID = "reward_id";
const DISCOUNT_TYPE = "discount_type";
const REWARD_TYPE = "reward_type";
const REWARD_PRODUCT_ID = "reward_product_id";
const REWARD_PRODUCT_QUANTITY = "reward_product_quantity";
const DISCOUNT_FIXED_AMOUNT = "discount_fixed_amount";
const DISCOUNT_APPLY_ON = "discount_apply_on";
const DISCOUNT_MAX_AMOUNT = "discount_max_amount";
const DISCOUNT_LINE_PRODUCT_ID = "discount_line_product_id";
const DISCOUNT_PERCENTAGE = "discount_percentage";
const DISCOUNT_SPECIFIC_PRODUCT_IDS = "discount_specific_product_ids";
const SEQUENCE = "sequence";
const MAXIMUM_USE_NUMBER = "maximum_use_number";
const PROGRAM_TYPE = "program_type";
const PROMO_CODE_USAGE = "promo_code_usage";
const PROMO_CODE = "promo_code";
const PROMO_APPLICABILITY = "promo_applicability";
const PROMOTION_COMPANY_ID = "company_id";
const VALIDITY_DURATION = "validity_duration";
const PROMOTION_CREATE_UID = "create_uid";
const PROMOTION_CREATE_DATE = "create_date";
const PROMTION_WRITE_UID = "write_uid";
const PROMOTION_WRITE_DATE = "write_date";
const PROMO_BARCODE = "promo_barcode";
const WEBSITE_ID = "website_id";
const COMBINE_PROMOTION = "combine_promotion";
const BREAK_MULTIPLE = "break_multiple";
const OWN_PERCENT = "own_percent";
const DEAL_NAME = "deal_name";
const DEAL_DETAIL = "deal_detail";
const STORE_TYPE = "store_type";
const APP_SEQUENCE = "app_sequence";
const VIDEO_URL = "video_url";
const EXCLUDE_POS_ORDER = "exclude_pos_order";

class PromotionTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PROMOTION_TABLE_NAME("
        "$PROMOTION_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PROMOTION_NAME TEXT,"
        "$PROMOTION_ACTIVE TEXT,"
        "$RULE_ID INTEGER,"
        "$RULE_DATE_FROM TEXT,"
        "$RULE_DATE_TO TEXT,"
        "$REWARD_ID INTEGER,"
        "$DISCOUNT_TYPE TEXT,"
        "$REWARD_TYPE TEXT,"
        "$REWARD_PRODUCT_ID INTEGER,"
        "$REWARD_PRODUCT_QUANTITY INTEGER,"
        "$DISCOUNT_FIXED_AMOUNT REAL,"
        "$DISCOUNT_APPLY_ON TEXT,"
        "$DISCOUNT_MAX_AMOUNT REAL,"
        "$DISCOUNT_LINE_PRODUCT_ID INTEGER,"
        "$DISCOUNT_PERCENTAGE REAL,"
        "$DISCOUNT_SPECIFIC_PRODUCT_IDS TEXT,"
        "$SEQUENCE INTEGER,"
        "$MAXIMUM_USE_NUMBER INTEGER,"
        "$PROGRAM_TYPE TEXT,"
        "$PROMO_CODE_USAGE TEXT,"
        "$PROMO_CODE TEXT,"
        "$PROMO_APPLICABILITY TEXT,"
        "$PROMOTION_COMPANY_ID INTEGER,"
        "$VALIDITY_DURATION INTEGER,"
        "$PROMOTION_CREATE_UID INTEGER,"
        "$PROMOTION_CREATE_DATE TEXT,"
        "$PROMTION_WRITE_UID INTEGER,"
        "$PROMOTION_WRITE_DATE TEXT,"
        "$PROMO_BARCODE TEXT,"
        "$WEBSITE_ID INTEGER,"
        "$COMBINE_PROMOTION TEXT,"
        "$BREAK_MULTIPLE TEXT,"
        "$OWN_PERCENT REAL,"
        "$DEAL_NAME TEXT,"
        "$DEAL_DETAIL TEXT,"
        "$STORE_TYPE TEXT,"
        "$APP_SEQUENCE INTEGER,"
        "$VIDEO_URL TEXT,"
        "$EXCLUDE_POS_ORDER TEXT"
        ")");
  }

  static Future<int> insert(Promotion couponAndPromo) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(PROMOTION_TABLE_NAME, couponAndPromo.toJson());
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      Promotion couponAndPromo = Promotion.fromJson(element);
      batch.insert(
        PROMOTION_TABLE_NAME,
        couponAndPromo.toJson(removeKey: true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (index % 1000 == 0) {
        await batch.commit(noResult: true);
        batch = db.batch();
      }
      index++;
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteAll({Database? db}) async {
    db ??= await DatabaseHelper().db;
    db.rawQuery("delete from $PROMOTION_TABLE_NAME");
  }

  static Future<List<Promotion>> getPromotionByProductId(
      int productId, int sessionId) async {
    final Database db = await DatabaseHelper().db;
    // Map<String, String> productReplaceValue = {};
    // productReplaceValue.putIfAbsent(PRODUCT_NAME, () => "pt.productName");

    String query =
        "SELECT *, prot.$PROMOTION_ID as promoId, prot.$PROMOTION_NAME as promoName, prt.$PROMOTION_RULE_ID as ruleId, dpmt.discountSpecificProduct, "
        "json_object("
        "${ProductTable.getProductSelectKeys(initialKey: "pt.", jsonForm: true, removed: true)}"
        ", 'priceListItem', json_object("
        "${PriceListItemTable.getPriceListItemSelectKeys(initialKey: "pli.", jsonForm: true)}"
        ")"
        ", 'amountTax', json_object("
        "${AmountTaxTable.getAmountTaxSelectKeys(initialKey: "amt.", jsonForm: true)}"
        ")"
        ") as rewardProduct, "
        "json_object("
        "${ProductTable.getProductSelectKeys(initialKey: "ptForReward.", jsonForm: true, removed: true)}"
        ", 'priceListItem', json_object("
        "${PriceListItemTable.getPriceListItemSelectKeys(initialKey: "priceForReward.", jsonForm: true)}"
        ")"
        ", 'amountTax', json_object("
        "${AmountTaxTable.getAmountTaxSelectKeys(initialKey: "amtForReward.", jsonForm: true)}"
        ")"
        ") as freeProduct "
        "FROM $PROMOTION_TABLE_NAME prot "
        "left join $PROMOTION_RULE_TABLE_NAME prt "
        "on prot.$RULE_ID = prt.$PROMOTION_RULE_ID "
        "left join "
        "( select  $MAPPING_PROMOTION_ID, "
        "json_group_array(distinct json_extract(json_object("
        "${ProductTable.getProductSelectKeys(initialKey: "pt.", jsonForm: true, removed: true)}"
        ", 'priceListItem', json_object("
        "${PriceListItemTable.getPriceListItemSelectKeys(initialKey: "pli.", jsonForm: true)}"
        ")"
        ", 'amountTax', json_object("
        "${AmountTaxTable.getAmountTaxSelectKeys(initialKey: "amt.", jsonForm: true)}"
        ")"
        "), '\$' )) as discountSpecificProduct "
        "from $DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME dpmt "
        "left join $PRODUCT_TABLE_NAME pt "
        "on dpmt.$DISCOUNT_MAPPING_PRODUCT_ID=pt.$PRODUCT_VARIANT_IDS "
        "${ProductTable.getProductIncludingPriceAndTax(sessionId: sessionId)} "
        "group by $MAPPING_PROMOTION_ID "
        ") dpmt "
        "on prot.$PROMOTION_ID=dpmt.$MAPPING_PROMOTION_ID "
        "left join $PRODUCT_TABLE_NAME pt "
        "on prot.$DISCOUNT_LINE_PRODUCT_ID=pt.$PRODUCT_VARIANT_IDS "
        "${ProductTable.getProductIncludingPriceAndTax(sessionId: sessionId)} "
        "left join $PRODUCT_TABLE_NAME ptForReward "
        "on prot.$REWARD_PRODUCT_ID=ptForReward.$PRODUCT_VARIANT_IDS "
        "${ProductTable.getProductIncludingPriceAndTax(sessionId: sessionId, productTName: "ptForReward", priTName: "priceForReward", amtTName: "amtForReward", lineTName: "lineForReward")} "
        "where prt.$PROMOTION_RULE_ID = "
        "("
        "select $MAPPING_PROMOTION_RULE_ID "
        "from $PROMOTION_RULE_MAPPING_TABLE_NAME "
        "where $MAPPING_PRODUCT_ID in ($productId) "
        ")";

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      Promotion promotion = Promotion.fromJson(maps[i],
          promoId: maps[i]["promoId"], promoName: maps[i]["promoName"]);
      if (maps[i]["rewardProduct"] != null) {
        try {
          Product? rewardProduct = Product.fromJson(
            jsonDecode(maps[i]["rewardProduct"]),
            includedOtherField: true,
          );
          promotion.rewardProduct = rewardProduct;
        } catch (e) {
          log(e.toString());
        }
      }
      if (maps[i]["freeProduct"] != null) {
        try {
          Product? freeProduct = Product.fromJson(
            jsonDecode(maps[i]["freeProduct"]),
            includedOtherField: true,
          );
          promotion.freeProduct = freeProduct;
        } catch (e) {
          log(e.toString());
        }
      }

      if (maps[i]["discountSpecificProduct"] != null) {
        List<dynamic>? list = jsonDecode(maps[i]["discountSpecificProduct"]);
        promotion.discountSpecificProducts ??= [];
        for (int v = 0; v < (list?.length ?? 0); v++) {
          try {
            Product? discountSpecificProduct = Product.fromJson(
              list![v],
              includedOtherField: true,
            );
            promotion.discountSpecificProducts?.add(discountSpecificProduct);
          } catch (e) {
            log(e.toString());
          }
        }
      }

      PromotionRule promotionRule =
          PromotionRule.fromJson(maps[i], ruleId: maps[i]["ruleId"]);
      promotion.promotionRule = promotionRule;
      return promotion;
    });
  }

  static Future<List<Promotion>> getPromotionByFiltering({
    String? filter,
    int? offset,
    int? limit,
  }) async {
    final Database db = await DatabaseHelper().db;
    // Map<String, String> productReplaceValue = {};
    // productReplaceValue.putIfAbsent(PRODUCT_NAME, () => "pt.productName");

    String query =
        "SELECT *, prot.$PROMOTION_ID as promoId, prot.$PROMOTION_NAME as promoName, prt.$PROMOTION_RULE_ID as ruleId, dpmt.discountSpecificProduct, "
        "json_object("
        "${ProductTable.getProductSelectKeys(initialKey: "pt.", jsonForm: true, removed: true)}"
        ", 'priceListItem', json_object("
        "${PriceListItemTable.getPriceListItemSelectKeys(initialKey: "pli.", jsonForm: true)}"
        ")"
        ", 'amountTax', json_object("
        "${AmountTaxTable.getAmountTaxSelectKeys(initialKey: "amt.", jsonForm: true)}"
        ")"
        ") as rewardProduct, "
        "json_object("
        "${ProductTable.getProductSelectKeys(initialKey: "ptForReward.", jsonForm: true, removed: true)}"
        ", 'priceListItem', json_object("
        "${PriceListItemTable.getPriceListItemSelectKeys(initialKey: "priceForReward.", jsonForm: true)}"
        ")"
        ", 'amountTax', json_object("
        "${AmountTaxTable.getAmountTaxSelectKeys(initialKey: "amtForReward.", jsonForm: true)}"
        ")"
        ") as freeProduct "
        "FROM $PROMOTION_TABLE_NAME prot "
        "left join $PROMOTION_RULE_TABLE_NAME prt "
        "on prot.$RULE_ID = prt.$PROMOTION_RULE_ID "
        "left join "
        "( select  $MAPPING_PROMOTION_ID, "
        "json_group_array(distinct json_extract(json_object("
        "${ProductTable.getProductSelectKeys(initialKey: "pt.", jsonForm: true, removed: true)}"
        ", 'priceListItem', json_object("
        "${PriceListItemTable.getPriceListItemSelectKeys(initialKey: "pli.", jsonForm: true)}"
        ")"
        ", 'amountTax', json_object("
        "${AmountTaxTable.getAmountTaxSelectKeys(initialKey: "amt.", jsonForm: true)}"
        ")"
        "), '\$' )) as discountSpecificProduct "
        "from $DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME dpmt "
        "left join $PRODUCT_TABLE_NAME pt "
        "on dpmt.$DISCOUNT_MAPPING_PRODUCT_ID=pt.$PRODUCT_VARIANT_IDS "
        "${ProductTable.getProductIncludingPriceAndTax()} "
        "group by $MAPPING_PROMOTION_ID "
        ") dpmt "
        "on prot.$PROMOTION_ID=dpmt.$MAPPING_PROMOTION_ID "
        "left join $PRODUCT_TABLE_NAME pt "
        "on prot.$DISCOUNT_LINE_PRODUCT_ID=pt.$PRODUCT_VARIANT_IDS "
        "${ProductTable.getProductIncludingPriceAndTax()} "
        "left join $PRODUCT_TABLE_NAME ptForReward "
        "on prot.$REWARD_PRODUCT_ID=ptForReward.$PRODUCT_VARIANT_IDS "
        "${ProductTable.getProductIncludingPriceAndTax(
      productTName: "ptForReward",
      priTName: "priceForReward",
      amtTName: "amtForReward",
      lineTName: "lineForReward",
    )} "
        "where 1=1 "
        "${filter != null && filter.isNotEmpty ? 'and nlower($PRODUCT_NAME) Like ? ' : ''}"
        "Group by prot.$PROMOTION_ID "
        "ORDER by prot.$PROMOTION_ID DESC "
        "${limit != null ? "limit $limit " : " "}"
        "${offset != null ? "offset $offset " : " "}";

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      Promotion promotion = Promotion.fromJson(maps[i],
          promoId: maps[i]["promoId"], promoName: maps[i]["promoName"]);
      if (maps[i]["rewardProduct"] != null) {
        try {
          Product? rewardProduct = Product.fromJson(
            jsonDecode(maps[i]["rewardProduct"]),
            includedOtherField: true,
          );
          promotion.rewardProduct = rewardProduct;
        } catch (e) {
          log(e.toString());
        }
      }
      if (maps[i]["freeProduct"] != null) {
        try {
          Product? freeProduct = Product.fromJson(
            jsonDecode(maps[i]["freeProduct"]),
            includedOtherField: true,
          );
          promotion.freeProduct = freeProduct;
        } catch (e) {
          log(e.toString());
        }
      }

      if (maps[i]["discountSpecificProduct"] != null) {
        List<dynamic>? list = jsonDecode(maps[i]["discountSpecificProduct"]);
        promotion.discountSpecificProducts ??= [];
        for (int v = 0; v < (list?.length ?? 0); v++) {
          try {
            Product? discountSpecificProduct = Product.fromJson(
              list![v],
              includedOtherField: true,
            );
            promotion.discountSpecificProducts?.add(discountSpecificProduct);
          } catch (e) {
            log(e.toString());
          }
        }
      }

      PromotionRule promotionRule =
          PromotionRule.fromJson(maps[i], ruleId: maps[i]["ruleId"]);
      promotion.promotionRule = promotionRule;
      return promotion;
    });
  }

  static Future<int> getAllPromotionCount({
    String? filter,
    // int? categoryId,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    filter = filter?.toLowerCase();
    // Query the table for all The Categories.
    List<Object?>? objects;
    if ((filter != null && filter.isNotEmpty)) {
      objects = ['%${filter.toLowerCase()}%'];
    }
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM $PROMOTION_TABLE_NAME '
        'where 1=1'
        '${filter != null && filter.isNotEmpty ? ' and lower($PRODUCT_NAME) Like ? ' : ''}',
        objects);

    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
  }
}
