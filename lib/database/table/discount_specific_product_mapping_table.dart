// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME =
    "discount_specific_product_mapping_table";
const MAPPING_PROMOTION_ID = "promotion_id";
const DISCOUNT_MAPPING_PRODUCT_ID = "product_variant_id"; //"product_id";

class DiscountSpecificProductMappingTable {
  static Future<void> onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME("
            "$MAPPING_PROMOTION_ID INTEGER,"
            "$DISCOUNT_MAPPING_PRODUCT_ID INTEGER,"
            "unique ($MAPPING_PROMOTION_ID, $DISCOUNT_MAPPING_PRODUCT_ID)"
            ")");
  }

  // static Future<void> insert(
  //   int promotionId,
  //   int productProductId,
  // ) async {
  //   final Database db = await DatabaseHelper().db;

  //   db.rawQuery("INSERT INTO "
  //       "$DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME($MAPPING_PROMOTION_ID, $DISCOUNT_MAPPING_PRODUCT_ID) "
  //       "VALUES($promotionId, "
  //       "(SELECT $PRODUCT_ID FROM $PRODUCT_TABLE_NAME WHERE $PRODUCT_VARIANT_IDS= $productProductId))");
  // }

  static Future<void> insert(
    int promotionId,
    int productProductId,
  ) async {
    final Database db = await DatabaseHelper().db;

    db.rawQuery("INSERT INTO "
        "$DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME($MAPPING_PROMOTION_ID, $DISCOUNT_MAPPING_PRODUCT_ID) "
        "VALUES($promotionId, $productProductId)");
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME");
  }
}
