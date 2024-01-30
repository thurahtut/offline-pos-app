// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../components/export_files.dart';

const PRODUCT_TABLE_NAME = "product_table";
const PRODUCT_ID = "id";
const PRODUCT_NAME = "name";
const CATEGORY_ID_IN_PT = "categ_id";
const IS_ROUNDING_PRODUCT = "is_rounding_product";
const SH_IS_BUNDLE = "sh_is_bundle";
const SH_SECONDARY_UOM = "sh_secondary_uom";
const POS_CATEG_ID_IN_PT = "pos_categ_id";
const WRITE_UID_IN_PT = "write_uid";
const WRITE_DATE_IN_PT = "write_date";
const PRODUCT_TYPE = "type";
const PRODUCT_VARIANT_IDS = "product_variant_ids";
const BARCODE_IN_PT = "barcode";
const ON_HAND_QUANTITY = "onhand_quantity";

class ProductTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PRODUCT_TABLE_NAME("
        "$PRODUCT_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PRODUCT_NAME TEXT NOT NULL,"
        "$CATEGORY_ID_IN_PT INTEGER NOT NULL,"
        "$IS_ROUNDING_PRODUCT BOOLEAN,"
        "$SH_IS_BUNDLE BOOLEAN,"
        "$SH_SECONDARY_UOM INTEGER,"
        "$POS_CATEG_ID_IN_PT INTEGER,"
        "$WRITE_UID_IN_PT INTEGER,"
        "$WRITE_DATE_IN_PT TEXT,"
        "$PRODUCT_TYPE TEXT,"
        "$PRODUCT_VARIANT_IDS TEXT,"
        "$BARCODE_IN_PT TEXT,"
        "$ON_HAND_QUANTITY TEXT"
        ")");
  }

  static Future<int> insert(Product product) async {
    final Database db = await DatabaseHelper().db;

    String sql = "INSERT INTO $PRODUCT_TABLE_NAME("
        "${product.productId != null && product.productId != 0 ? "$PRODUCT_ID," : ""}"
        "$PRODUCT_NAME, $CATEGORY_ID_IN_PT, $IS_ROUNDING_PRODUCT, "
        "$SH_IS_BUNDLE, $SH_SECONDARY_UOM, $POS_CATEG_ID_IN_PT, "
        "$WRITE_UID_IN_PT, $WRITE_DATE_IN_PT, $PRODUCT_TYPE, $PRODUCT_VARIANT_IDS, "
        "$BARCODE_IN_PT, $ON_HAND_QUANTITY"
        ")"
        " VALUES("
        "${product.productId != null && product.productId != 0 ? "${product.productId}," : ""}"
        "'${product.productName}', ${product.categoryId}, '${product.isRoundingProduct}', "
        "'${product.shIsBundle}', '${product.shSecondaryUom}', ${product.posCategId}, "
        "${product.writeUid}, '${product.writeDate}', '${product.productType}', '${product.productVariantIds != null && product.productVariantIds!.isNotEmpty ? jsonEncode(product.productVariantIds!) : ""}', "
        "'${product.barcode}', '${product.onhandQuantity ?? "0"}', "
        ")";

    return db.rawInsert(sql);
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    // var time = DateTime.now();
    int index = 0;
    for (final element in data) {
      Product product = Product.fromJson(element);
      batch.insert(
        PRODUCT_TABLE_NAME,
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (index % 1000 == 0) {
        await batch.commit(noResult: true);
        batch = db.batch();
      }
      index++;
    }

    // var time2 = DateTime.now();
    // var d = time2.difference(time);
    // print("Finished ${data.length} in $d");
    await batch.commit(noResult: true);
  }

  static Future<List<Product>> getAll({
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PRODUCT_TABLE_NAME,
      orderBy: '$PRODUCT_ID DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  static Future<Product?> getProductByProductId(int productId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PRODUCT_TABLE_NAME,
      where: "$PRODUCT_ID=?",
      whereArgs: [productId],
      limit: 1,
    );

    return Product.fromJson(maps.first);
  }

  static Future<List<Product>> getProductsFiltering({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PRODUCT_TABLE_NAME,
      where: filter != null
          ? "$PRODUCT_ID LIKE ? or lower($PRODUCT_NAME) LIKE ?"
          : null,
      whereArgs:
          filter != null ? ['%$filter%', '%${filter.toLowerCase()}%'] : null,
      // where: "$PRODUCT_NAME=?",
      // whereArgs: [filter],
      orderBy: '$PRODUCT_ID DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  static Future<Product?> getLastProduct() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await
        //  db.query(
        //   PRODUCT_TABLE_NAME,
        //   orderBy: '$PRODUCT_ID DESC',
        //   limit: 1,
        // );

        db.rawQuery(
            "select * from $PRODUCT_TABLE_NAME where id=(select max(id) from $PRODUCT_TABLE_NAME, []");

    return Product.fromJson(maps.first);
  }

  static Future<List<Product>> getProductByFilteringWithPrice({
    String? filter,
    int? categoryId,
    int? limit,
    int? offset,
    bool? barcodeOnly,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String query =
        "SELECT pt.id productId, pli.id priceListItemId,* from $PRODUCT_TABLE_NAME pt "
        "left join $PRICE_LIST_ITEM_TABLE_NAME pli "
        "on pt.$PRODUCT_ID=pli.$PRODUCT_TMPL_ID "
        "and pli.$APPLIED_ON='1_product' "
        "and (datetime($DATE_START) < datetime('${DateTime.now().toUtc().toString()}') or $DATE_START=null or lower($DATE_START) is null or $DATE_START='') "
        "and (datetime($DATE_END)>=  datetime('${DateTime.now().toUtc().toString()}') or $DATE_END=null or lower($DATE_END) is null or $DATE_END='') "
        "where 1=1 "
        "${filter?.isNotEmpty ?? false ? (barcodeOnly == true ? "and pt.$BARCODE_IN_PT=?" : "and (pt.$PRODUCT_ID like ? or lower(pt.$PRODUCT_NAME) Like ? or pt.$BARCODE_IN_PT like ?)") : ''} "
        "${categoryId != null && categoryId != -1 ? "and pt.$POS_CATEG_ID_IN_PT=?" : ''} "
        "ORDER by pt.$PRODUCT_ID DESC "
        "${limit != null ? "limit $limit " : " "}"
        "${offset != null ? "offset $offset " : " "}";
    List<Object?>? objects;
    if ((filter != null && filter.isNotEmpty) ||
        (categoryId != null && categoryId != -1)) {
      objects = [];
      if (filter != null && filter.isNotEmpty) {
        objects = ['%$filter%', '%${filter.toLowerCase()}%', '%$filter%'];
      }
      if (categoryId != null && categoryId != -1) {
        objects.add(categoryId);
      }
    }
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        query,
        objects);

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      Product product = Product.fromJson(maps[i], pId: maps[i]["productId"]);
      PriceListItem priceListItem = PriceListItem.fromJson(maps[i],
          priceListItemId: maps[i]["priceListItemId"]);
      product.priceListItem = priceListItem;
      return product;
    });
  }

  static Future<int> getAllProductCount({
    String? filter,
    int? categoryId,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    filter = filter?.toLowerCase();
    // Query the table for all The Categories.
    List<Object?>? objects;
    if ((filter != null && filter.isNotEmpty) ||
        (categoryId != null && categoryId != -1)) {
      objects = [];
      if (filter != null && filter.isNotEmpty) {
        objects = ['%$filter%', '%${filter.toLowerCase()}%', '%$filter%'];
      }
      if (categoryId != null && categoryId != -1) {
        objects.add(categoryId);
      }
    }
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM $PRODUCT_TABLE_NAME '
        'where 1=1'
        '${filter != null && filter.isNotEmpty ? ' and $PRODUCT_ID Like ? or lower($PRODUCT_NAME) Like ? or $BARCODE_IN_PT like ?' : ''}'
        "${categoryId != null && categoryId != -1 ? " and $POS_CATEG_ID_IN_PT=?" : ''} ",
        objects);
    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
  }

  static Future<int> delete(int productId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      PRODUCT_TABLE_NAME,
      where: "$PRODUCT_ID=?",
      whereArgs: [productId],
    );
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $PRODUCT_TABLE_NAME");
  }

  static Future<int> update(Product product) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      PRODUCT_TABLE_NAME,
      product.toJson(),
      where: "$PRODUCT_ID=?",
      whereArgs: [product.productId],
    );
  }
}
