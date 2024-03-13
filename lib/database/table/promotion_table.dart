// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/promotion.dart';
import 'package:sqflite/sqflite.dart';

const PROMOTION_TABLE_NAME = "promotion_table";
const PROMOTION_ID = " id";
const PROMOTION_NAME = "name";
const PROMOTION_ACTIVE = "active";
const RULE_ID = "rule_id";
const RULE_DATE_FROM = "rule_date_from";
const RULE_DATE_TO = "rule_date_to";
const REWARD_ID = "reward_id";
const DISCOUNT_TYPE = "discount_type";
const REWARD_TYPE = "reward_type";
const REWARD_PRODUCT_ID = "reward_product_id";
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
        "$APP_SEQUENCE TEXT,"
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
        couponAndPromo.toJson(),
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

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $PROMOTION_TABLE_NAME");
  }
}