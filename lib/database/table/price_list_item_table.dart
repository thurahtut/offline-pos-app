// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../components/export_files.dart';

const PRICE_LIST_ITEM_TABLE_NAME = "price_list_item_table";
const PRICE_LIST_ITEM_ID = "id";
const PRODUCT_TMPL_ID = "product_tmpl_id";
const MIN_QUANTITY = "min_quantity";
const APPLIED_ON = "applied_on";
const CURRENCY_ID = "currency_id";
const DATE_START = "date_start";
const DATE_END = "date_end";
const COMPUTE_PRICE = "compute_price";
const FIXED_PRICE = "fixed_price";
const PERCENT_PRICE = "percent_price";
const WRITE_DATE_IN_PRIT = "write_date";
const WRITE_UID_IN_PRIT = "write_uid";

class PriceListItemTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PRICE_LIST_ITEM_TABLE_NAME("
        "$PRICE_LIST_ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PRODUCT_TMPL_ID INTEGER,"
        "$MIN_QUANTITY INTEGER,"
        "$APPLIED_ON TEXT,"
        "$CURRENCY_ID INTEGER,"
        "$DATE_START TEXT,"
        "$DATE_END TEXT,"
        "$COMPUTE_PRICE TEXT,"
        "$FIXED_PRICE TEXT,"
        "$PERCENT_PRICE TEXT,"
        "$WRITE_DATE_IN_PRIT TEXT,"
        "$WRITE_UID_IN_PRIT INTEGER"
        ")");
  }

  static Future<int> insert(PriceListItem priceListItem) async {
    final Database db = await DatabaseHelper().db;

    String sql = "INSERT INTO $PRICE_LIST_ITEM_TABLE_NAME("
        "${priceListItem.id != null && priceListItem.id != 0 ? "$PRICE_LIST_ITEM_ID," : ""}"
        "$MIN_QUANTITY, $APPLIED_ON, $CURRENCY_ID,"
        "$DATE_START, $DATE_END, $COMPUTE_PRICE,"
        "$FIXED_PRICE, $PERCENT_PRICE, $WRITE_DATE_IN_PRIT,"
        "$WRITE_UID_IN_PRIT"
        ")"
        " VALUES("
        "${priceListItem.id != null && priceListItem.id != 0 ? '${int.tryParse(priceListItem.id.toString())}' : ""}"
        "'${int.tryParse(priceListItem.minQuantity.toString())}', '${priceListItem.appliedOn}', '${int.tryParse(priceListItem.currencyId.toString())}', "
        "'${priceListItem.dateStart}', '${priceListItem.dateEnd}', '${int.tryParse(priceListItem.computePrice.toString())}', "
        "'${int.tryParse(priceListItem.fixedPrice.toString())}', '${int.tryParse(priceListItem.percentPrice.toString())}', '${priceListItem.writeDate}', "
        "'${int.tryParse(priceListItem.writeUid.toString())}'"
        ")";
    return db.rawInsert(sql);
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    // var time = DateTime.now();
    int index = 0;
    for (final element in data) {
      PriceListItem priceListItem = PriceListItem.fromJson(element);
      batch.insert(
        PRICE_LIST_ITEM_TABLE_NAME,
        priceListItem.toJson(),
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

  static Future<int> getAllPriceListCount() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final result =
        await db.rawQuery('SELECT COUNT(*) FROM $PRICE_LIST_ITEM_TABLE_NAME ');
    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
  }

  static Future<List<PriceListItem>> getAll({
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PRICE_LIST_ITEM_TABLE_NAME,
      orderBy: '$PRICE_LIST_ITEM_ID DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return PriceListItem.fromJson(maps[i]);
    });
  }

  static Future<List<PriceListItem>> getPriceListItemByProductIds(
    List<int> productIds,
  ) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String query = "SELECT * from $PRICE_LIST_ITEM_TABLE_NAME "
        "WHERE $PRODUCT_TMPL_ID in (${productIds.map((e) => "$e").join(",")})"
        " ORDER by $PRICE_LIST_ITEM_ID DESC";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    debugPrint(query);
    return List.generate(maps.length, (i) {
      return PriceListItem.fromJson(maps[i]);
    });
  }

  static Future<PriceListItem?> getPriceListItemById(
      int priceListItemId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PRICE_LIST_ITEM_TABLE_NAME,
      where: "$PRICE_LIST_ITEM_ID=?",
      whereArgs: [priceListItemId],
      limit: 1,
    );

    return PriceListItem.fromJson(maps.first);
  }

  static Future<List<Product>> getPriceItemByFilteringWithProduct({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String query =
        "SELECT pt.id productId, pli.id priceListItemId,* from $PRICE_LIST_ITEM_TABLE_NAME pli "
        "left join $PRODUCT_TABLE_NAME pt "
        "on pt.$PRODUCT_ID=pli.$PRODUCT_TMPL_ID "
        "${filter?.isNotEmpty ?? false ? "and (pt.$PRODUCT_NAME like ? or lower(pt.$PRODUCT_NAME) Like ? or pt.$BARCODE_IN_PT like ?)" : ''} "
        "where 1=1 "
        "and pli.$APPLIED_ON='1_product' "
        "and (datetime($DATE_START) < datetime('${DateTime.now().toUtc().toString()}') or $DATE_START=null or lower($DATE_START) is null or $DATE_START='') "
        "and (datetime($DATE_END)>=  datetime('${DateTime.now().toUtc().toString()}') or $DATE_END=null or lower($DATE_END) is null or $DATE_END='') "
        "ORDER by pli.$PRICE_LIST_ITEM_ID DESC"
        "${limit != null ? " limit $limit " : " "}"
        "${offset != null ? " offset $offset " : " "}";
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        query,
        filter != null && filter.isNotEmpty
            ? ['%$filter%', '%${filter.toLowerCase()}%']
            : null);

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      Product product = Product.fromJson(maps[i], pId: maps[i]["productId"]);
      PriceListItem priceListItem = PriceListItem.fromJson(maps[i],
          priceListItemId: maps[i]["priceListItemId"]);
      product.priceListItem = priceListItem;
      return product;
    });
  }

  static Future<int> delete(int priceListItemId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      PRICE_LIST_ITEM_TABLE_NAME,
      where: "$PRICE_LIST_ITEM_ID=?",
      whereArgs: [priceListItemId],
    );
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $PRICE_LIST_ITEM_TABLE_NAME");
  }

  static Future<int> update(PriceListItem priceListItem) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      PRICE_LIST_ITEM_TABLE_NAME,
      priceListItem.toJson(),
      where: "$PRICE_LIST_ITEM_ID=?",
      whereArgs: [priceListItem.id],
    );
  }
}
