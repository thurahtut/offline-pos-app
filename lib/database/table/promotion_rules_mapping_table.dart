// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const PROMOTION_RULE_MAPPING_TABLE_NAME = "promotion_rule_mapping_table";
const MAPPING_PROMOTION_RULE_ID = "rule_id";
const MAPPING_PRODUCT_ID = "product_id";
const MAPPING_PRODUCT_NAME = "product_name";

class PromotionRuleMappingTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PROMOTION_RULE_MAPPING_TABLE_NAME("
        "$MAPPING_PROMOTION_RULE_ID INTEGER,"
        "$MAPPING_PRODUCT_ID INTEGER,"
        "$MAPPING_PRODUCT_NAME TEXT"
        ")");
  }

  static Future<void> insert(
    int ruleId,
    int productVariantId,
    String productName,
  ) async {
    final Database db = await DatabaseHelper().db;

    db.rawQuery("INSERT INTO "
        "$PROMOTION_RULE_MAPPING_TABLE_NAME($MAPPING_PROMOTION_RULE_ID, $MAPPING_PRODUCT_ID, $MAPPING_PRODUCT_NAME) "
        "VALUES($ruleId, "
        "(SELECT $PRODUCT_ID FROM $PRODUCT_TABLE_NAME WHERE $PRODUCT_VARIANT_IDS= $productVariantId),"
        "'$productName')");
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $PROMOTION_RULE_MAPPING_TABLE_NAME");
  }
}
