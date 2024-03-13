// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/promotion_rule.dart';
import 'package:sqflite/sqflite.dart';

const PROMOTION_RULE_TABLE_NAME = "promotion_rule_table";
const PROMOTION_RULE_ID = "id";
const RULE_DATE_FROM = "rule_date_from";
const RULE_DATE_TO = "rule_date_to";
const RULE_PARTNERS_DOMAIN = "rule_partners_domain";
const RULE_MIN_QUANTITY = "rule_min_quantity";
const RULE_MINIMUM_AMOUNT = "rule_minimum_amount";
const RULE_MINIMUM_AMOUNT_TAX_INCLUSION = "rule_minimum_amount_tax_inclusion";
const RULE_CREATE_UID = "create_uid";
const RULE_CREATE_DATE = "create_date";
const RULE_WRITE_UID = "write_uid";
const RULE_WRITE_DATE = "write_date";
const IS_ANY = "is_any";
const VALID_PRODUCT_IDS = "valid_product_ids";

class PromotionRuleTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PROMOTION_RULE_TABLE_NAME("
        "$PROMOTION_RULE_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$RULE_DATE_FROM TEXT,"
        "$RULE_DATE_TO TEXT,"
        "$RULE_PARTNERS_DOMAIN TEXT,"
        "$RULE_MIN_QUANTITY REAL,"
        "$RULE_MINIMUM_AMOUNT REAL,"
        "$RULE_MINIMUM_AMOUNT_TAX_INCLUSION TEXT,"
        "$RULE_CREATE_UID INTEGER,"
        "$RULE_CREATE_DATE TEXT,"
        "$RULE_WRITE_UID INTEGER,"
        "$RULE_WRITE_DATE TEXT,"
        "$IS_ANY TEXT,"
        "$VALID_PRODUCT_IDS TEXT"
        ")");
  }

  static Future<int> insert(PromotionRule couponAndPromo) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(PROMOTION_RULE_TABLE_NAME, couponAndPromo.toJson());
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      PromotionRule promotionRule = PromotionRule.fromJson(element);
      batch.insert(
        PROMOTION_RULE_TABLE_NAME,
        promotionRule.toJson(),
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
    db.rawQuery("delete from $PROMOTION_RULE_TABLE_NAME");
  }
}
