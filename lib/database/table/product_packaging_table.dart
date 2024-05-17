// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const PRODUCT_PACKAGING_TABLE_NAME = "product_packaging_table";
const PRODUCT_PACKAGING_ID = "id";
const PACKAGING_PRODUCT_ID = "product_id";
const PACKAGING_NAME = "name";
const PACKAGING_TYPE_ID = "package_type_id";
const PACKAGING_QTY = "qty";
const PACKAGING_BARCODE = "barcode";
const PACKAGING_SALES = "sales";
const PACKAGING_PRODUCT_UOM_ID = "product_uom_id";

class ProductPackagingTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PRODUCT_PACKAGING_TABLE_NAME("
        "$PRODUCT_PACKAGING_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PACKAGING_PRODUCT_ID INTEGER,"
        "$PACKAGING_NAME TEXT,"
        "$PACKAGING_TYPE_ID TEXT,"
        "$PACKAGING_QTY INTEGER,"
        "$PACKAGING_BARCODE TEXT,"
        "$PACKAGING_SALES TEXT,"
        "$PACKAGING_PRODUCT_UOM_ID TEXT"
        ")");
  }

  static Future<int> insert(ProductPackaging productPackaging) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(PRODUCT_PACKAGING_TABLE_NAME, productPackaging.toJson());
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      ProductPackaging productPackaging = ProductPackaging.fromJson(element);
      batch.insert(
        PRODUCT_PACKAGING_TABLE_NAME,
        productPackaging.toJson(),
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

  static Future<List<ProductPackaging>> getProductPackagingByProductId(
      int productId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    String query =
        "select *, ppt.$PRODUCT_PACKAGING_ID as packageId, pit.$PRICE_LIST_ITEM_ID as priceId "
        "from $PRODUCT_PACKAGING_TABLE_NAME ppt "
        "left join $PRICE_LIST_ITEM_TABLE_NAME pit "
        "on pit.$PACKAGE_ID_IN_LINE=ppt.$PRODUCT_PACKAGING_ID "
        "and (datetime($DATE_START) < datetime('${CommonUtils.getDateTimeNow().toString()}') or $DATE_START=null or lower($DATE_START) is null or $DATE_START='') "
        "and (datetime($DATE_END)>=  datetime('${CommonUtils.getDateTimeNow().toString()}') or $DATE_END=null or lower($DATE_END) is null or $DATE_END='') "
        "and $APPLIED_ON='3_product_package' "
        "where pit.$PRODUCT_TMPL_ID =$productId "
        "group by ppt.$PRODUCT_PACKAGING_ID "
        "order by $PACKAGING_QTY asc ";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (index) {
      ProductPackaging productPackaging = ProductPackaging.fromJson(maps[index],
          packagingId: maps[index]["packageId"]);
      PriceListItem priceListItem = PriceListItem.fromJson(maps[index],
          priceListItemId: maps[index]["priceId"]);
      productPackaging.priceListItem = priceListItem;
      return productPackaging;
    });
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $PRODUCT_PACKAGING_TABLE_NAME");
  }

  static Future<int> update(ProductPackaging productPackaging) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      PRODUCT_PACKAGING_TABLE_NAME,
      productPackaging.toJson(),
      where: "$PRODUCT_PACKAGING_ID=?",
      whereArgs: [productPackaging.id],
    );
  }
}
