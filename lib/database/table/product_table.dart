// ignore_for_file: constant_identifier_names

import 'package:offline_pos/database/table/amount_tax_table.dart';
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
const TAXES_ID = "taxes_id";
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
        "$PRODUCT_VARIANT_IDS INTEGER,"
        "$TAXES_ID TEXT,"
        "$BARCODE_IN_PT TEXT,"
        "$ON_HAND_QUANTITY TEXT"
        ")");
  }

  static Future<int> insert(Product product) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(PRODUCT_TABLE_NAME, product.toJson(removed: true));
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      Product product = Product.fromJson(element);
      batch.insert(
        PRODUCT_TABLE_NAME,
        product.toJson(removed: true),
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

  // static Future<List<Product>> getAll({
  //   int? limit,
  //   int? offset,
  // }) async {
  //   // Get a reference to the database.
  //   final Database db = await DatabaseHelper().db;

  //   // Query the table for all The Categories.
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     PRODUCT_TABLE_NAME,
  //     orderBy: '$PRODUCT_ID DESC',
  //     limit: limit,
  //     offset: offset,
  //   );

  //   // Convert the List<Map<String, dynamic> into a List<Category>.
  //   return List.generate(maps.length, (i) {
  //     return Product.fromJson(maps[i]);
  //   });
  // }

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

  // static Future<List<Product>> getProductsFiltering({
  //   String? filter,
  //   int? limit,
  //   int? offset,
  // }) async {
  //   // Get a reference to the database.
  //   final Database db = await DatabaseHelper().db;

  //   // Query the table for all The Categories.
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     PRODUCT_TABLE_NAME,
  //     where: filter != null
  //         ? "$PRODUCT_ID LIKE ? or lower($PRODUCT_NAME) LIKE ?"
  //         : null,
  //     whereArgs:
  //         filter != null ? ['%$filter%', '%${filter.toLowerCase()}%'] : null,
  //     // where: "$PRODUCT_NAME=?",
  //     // whereArgs: [filter],
  //     orderBy: '$PRODUCT_ID DESC',
  //     limit: limit,
  //     offset: offset,
  //   );

  //   // Convert the List<Map<String, dynamic> into a List<Category>.
  //   return List.generate(maps.length, (i) {
  //     return Product.fromJson(maps[i]);
  //   });
  // }

  // static Future<Product?> getLastProduct() async {
  //   // Get a reference to the database.
  //   final Database db = await DatabaseHelper().db;

  //   // Query the table for all The Categories.
  //   final List<Map<String, dynamic>> maps = await
  //       //  db.query(
  //       //   PRODUCT_TABLE_NAME,
  //       //   orderBy: '$PRODUCT_ID DESC',
  //       //   limit: 1,
  //       // );

  //       db.rawQuery(
  //           "select * from $PRODUCT_TABLE_NAME where id=(select max(id) from $PRODUCT_TABLE_NAME, []");

  //   return Product.fromJson(maps.first);
  // }

  static Future<List<Product>> getProductByFilteringWithPrice({
    String? filter,
    int? categoryId,
    int? limit,
    int? offset,
    bool? barcodeOnly,
    int? sessionId,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String query =
        "SELECT pt.id productId, pt.$PRODUCT_NAME productName, pli.id priceListItemId, amt.id amountTaxId, amt.$AMOUNT_TAX_NAME amountTaxName, * ,"
        "pt.$ON_HAND_QUANTITY - (case when line.totalQty is not null then line.totalQty else 0 end) as remainingQty "
        "from $PRODUCT_TABLE_NAME pt "
        "left join $PRICE_LIST_ITEM_TABLE_NAME pli "
        "on pt.$PRODUCT_ID=pli.$PRODUCT_TMPL_ID "
        "and pli.$APPLIED_ON='1_product' "
        "and (datetime($DATE_START) < datetime('${CommonUtils.getDateTimeNow().toString()}') or $DATE_START=null or lower($DATE_START) is null or $DATE_START='') "
        "and (datetime($DATE_END)>=  datetime('${CommonUtils.getDateTimeNow().toString()}') or $DATE_END=null or lower($DATE_END) is null or $DATE_END='') "
        "left join $AMOUNT_TAX_TABLE_NAME amt "
        "on '[' || amt.$AMOUNT_TAX_ID || ']'= pt.$TAXES_ID "
        "left JOIN "
        "( "
        "select sum(qty) as totalQty, $PRODUCT_ID_IN_LINE "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        " left join $ORDER_LINE_ID_TABLE_NAME olt "
        " on $ORDER_ID_IN_LINE=ot.$ORDER_HISTORY_ID "
        " and $SESSION_ID =$sessionId "
        ") line "
        "on line.$PRODUCT_ID_IN_LINE= pt.$PRODUCT_VARIANT_IDS "
        "where 1=1 "
        "${filter?.isNotEmpty ?? false ? (barcodeOnly == true ? "and pt.$BARCODE_IN_PT=?" : "and (pt.$PRODUCT_ID like ? or lower(pt.$PRODUCT_NAME) Like ? or pt.$BARCODE_IN_PT like ?)") : ''} "
        "${categoryId != null && categoryId != -1 ? "and pt.$POS_CATEG_ID_IN_PT=?" : ''} "
        "Group by pt.id "
        "ORDER by pt.$PRODUCT_ID DESC "
        "${limit != null ? "limit $limit " : " "}"
        "${offset != null ? "offset $offset " : " "}";
    List<Object?>? objects;
    if ((filter != null && filter.isNotEmpty) ||
        (categoryId != null && categoryId != -1)) {
      objects = [];
      if (filter != null && filter.isNotEmpty) {
        if (barcodeOnly == true) {
          objects = [filter];
        } else {
          objects = ['%$filter%', '%${filter.toLowerCase()}%', '%$filter%'];
        }
      }
      if (categoryId != null && categoryId != -1) {
        objects.add(categoryId);
      }
    }
    final List<Map<String, dynamic>> maps = await db.rawQuery(query, objects);

    // String query2 = "SELECT pt.id productId, * from $PRODUCT_TABLE_NAME pt "
    //     "where 1=1 "
    //     "${filter?.isNotEmpty ?? false ? (barcodeOnly == true ? "and pt.$BARCODE_IN_PT=?" : "and (pt.$PRODUCT_ID like ? or lower(pt.$PRODUCT_NAME) Like ? or pt.$BARCODE_IN_PT like ?)") : ''} "
    //     "${categoryId != null && categoryId != -1 ? "and pt.$POS_CATEG_ID_IN_PT=?" : ''} "
    //     "ORDER by pt.$PRODUCT_ID DESC "
    //     "${limit != null ? "limit $limit " : " "}"
    //     "${offset != null ? "offset $offset " : " "}";
    // List<Object?>? objects2;
    // if ((filter != null && filter.isNotEmpty) ||
    //     (categoryId != null && categoryId != -1)) {
    //   objects2 = [];
    //   if (filter != null && filter.isNotEmpty) {
    //     objects = ['%$filter%', '%${filter.toLowerCase()}%', '%$filter%'];
    //   }
    //   if (categoryId != null && categoryId != -1) {
    //     objects2.add(categoryId);
    //   }
    // }
    // final List<Map<String, dynamic>> maps2 =
    //     await db.rawQuery(query2, objects2);

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      Product product = Product.fromJson(maps[i],
          pId: maps[i]["productId"], pName: maps[i]["productName"]);
      product.onhandQuantity =
          double.tryParse(maps[i]['remainingQty'].toString())?.toInt() ?? 0;
      PriceListItem priceListItem = PriceListItem.fromJson(maps[i],
          priceListItemId: maps[i]["priceListItemId"]);
      product.priceListItem = priceListItem;
      AmountTax amountTax = AmountTax.fromJson(maps[i],
          amId: maps[i]["amountTaxId"], amName: maps[i]["amountTaxName"]);
      product.amountTax = amountTax;
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
      product.toJson(removed: true),
      where: "$PRODUCT_ID=?",
      whereArgs: [product.productId],
    );
  }

  static Future<List<Product>> getProductListByIds(List<int> productIds) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String query =
        "SELECT pt.id productId, pt.$PRODUCT_NAME productName, pli.id priceListItemId, amt.id amountTaxId, amt.$AMOUNT_TAX_NAME amountTaxName, * "
        "from $PRODUCT_TABLE_NAME pt "
        "left join $PRICE_LIST_ITEM_TABLE_NAME pli "
        "on pt.$PRODUCT_ID=pli.$PRODUCT_TMPL_ID "
        "and pli.$APPLIED_ON='1_product' "
        "and (datetime($DATE_START) < datetime('${CommonUtils.getDateTimeNow().toString()}') or $DATE_START=null or lower($DATE_START) is null or $DATE_START='') "
        "and (datetime($DATE_END)>=  datetime('${CommonUtils.getDateTimeNow().toString()}') or $DATE_END=null or lower($DATE_END) is null or $DATE_END='') "
        "left join $AMOUNT_TAX_TABLE_NAME amt "
        "on '[' || amt.$AMOUNT_TAX_ID || ']'= pt.$TAXES_ID "
        "WHERE $PRODUCT_VARIANT_IDS in (${productIds.map((e) => e).join(",")}) "
        "Group by pt.id";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (i) {
      Product product = Product.fromJson(maps[i],
          pId: maps[i]["productId"], pName: maps[i]["productName"]);
      PriceListItem priceListItem = PriceListItem.fromJson(maps[i],
          priceListItemId: maps[i]["priceListItemId"]);
      product.priceListItem = priceListItem;
      AmountTax amountTax = AmountTax.fromJson(maps[i],
          amId: maps[i]["amountTaxId"], amName: maps[i]["amountTaxName"]);
      product.amountTax = amountTax;
      return product;
    });
  }

  static String getProductSelectKeys({
    String? initialKey,
    bool? jsonForm,
    List<String>? toRemoveKeys,
    bool? removed,
    Map<String, String>? replaceValue,
  }) {
    Map<String, dynamic> map = Product().toJson(removed: removed);
    for (var data in toRemoveKeys ?? []) {
      map.remove(data);
    }
    String str = "";
    List<String> list = [];
    if (jsonForm == true) {
      for (MapEntry<String, dynamic> entry in map.entries) {
        list.add("'${entry.key}'");
        MapEntry<String, String>? replaceMap = replaceValue?.entries
            .firstWhere((element) => entry.key == element.key);
        list.add(initialKey != null
            ? "$initialKey${replaceMap != null ? replaceMap.value : entry.key}"
            : (replaceMap != null ? replaceMap.value : entry.key));
      }
    } else {
      list = initialKey != null || replaceValue != null
          ? map.keys.map((e) {
              MapEntry<String, String>? replaceMap = replaceValue?.entries
                  .firstWhere((element) => e == element.key);
              return "$initialKey${replaceMap != null ? replaceMap.value : e}";
            }).toList()
          : map.keys.toList();
    }
    str = list.join(",");
    return str;
  }

  static String getProductIncludingPriceAndTax({
    int? sessionId,
    String? productTName,
    String? priTName,
    String? amtTName,
    String? lineTName,
  }) {
    productTName ??= "pt";
    priTName ??= "pli";
    amtTName ??= "amt";
    lineTName ??= "line";
    return "left join $PRICE_LIST_ITEM_TABLE_NAME $priTName "
        "on $productTName.$PRODUCT_ID=$priTName.$PRODUCT_TMPL_ID "
        "and $priTName.$APPLIED_ON='1_product' "
        "and (datetime($priTName.$DATE_START) < datetime('${CommonUtils.getDateTimeNow().toString()}') or $priTName.$DATE_START=null or lower($priTName.$DATE_START) is null or $priTName.$DATE_START='') "
        "and (datetime($priTName.$DATE_END)>=  datetime('${CommonUtils.getDateTimeNow().toString()}') or $priTName.$DATE_END=null or lower($priTName.$DATE_END) is null or $priTName.$DATE_END='') "
        "left join $AMOUNT_TAX_TABLE_NAME $amtTName "
        "on '[' || $amtTName.$AMOUNT_TAX_ID || ']'= $productTName.$TAXES_ID "
        "left JOIN "
        "( "
        "select sum(qty) as totalQty, $PRODUCT_ID_IN_LINE "
        "from $ORDER_HISTORY_TABLE_NAME ot "
        "left join $ORDER_LINE_ID_TABLE_NAME olt "
        "on $ORDER_ID_IN_LINE=ot.$ORDER_HISTORY_ID "
        "${sessionId != null ? "and $SESSION_ID =$sessionId " : ""}"
        ") $lineTName "
        "on $lineTName.$PRODUCT_ID_IN_LINE= $productTName.$PRODUCT_VARIANT_IDS ";
  }
}
