// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../components/export_files.dart';

const PRODUCT_TABLE_NAME = "product_table";
const PRODUCT_ID = "id";
const PRODUCT_NAME = "name";
const CATEGORY_ID_IN_PT = "categ_id";
const IS_ROUNDING_PRODUCT = "is_rounding_product";
const SH_IS_BUNDLE = "sh_is_bundle";
const SH_SECONDARY_UOM = "sh_secondary_uom";
const INTERNAL_REF = "internal_ref";

class ProductTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PRODUCT_TABLE_NAME("
        "$PRODUCT_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PRODUCT_NAME TEXT NOT NULL,"
        "$CATEGORY_ID_IN_PT INTEGER NOT NULL,"
        "$IS_ROUNDING_PRODUCT BOOLEAN,"
        "$SH_IS_BUNDLE BOOLEAN,"
        "$SH_SECONDARY_UOM INTEGER,"
        "$INTERNAL_REF TEXT"
        ")");
  }

  static Future<int> insert(Product product) async {
    final Database db = await DatabaseHelper().db;

    String sql = "INSERT INTO $PRODUCT_TABLE_NAME("
        "$PRODUCT_NAME, $CATEGORY_ID_IN_PT, $IS_ROUNDING_PRODUCT, "
        "$SH_IS_BUNDLE, "
        "$SH_SECONDARY_UOM, $INTERNAL_REF"
        ")"
        " VALUES("
        "'${product.productName}', ${product.categoryId}, '${product.isRoundingProduct}', "
        "'${product.shIsBundle}', "
        "'${product.shSecondaryUom}', '${product.internalRef}'"
        ")";

    return db.rawInsert(sql);
  }
  
  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    await deleteAll(db); // todo: to remove
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

  static Future<int> getAllProductCount({
    String? filter,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    filter = filter?.toLowerCase();
    // Query the table for all The Categories.
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM $PRODUCT_TABLE_NAME '
        '${filter != null && filter.isNotEmpty ? 'Where $PRODUCT_ID Like ? or lower($PRODUCT_NAME) Like ?' : ''}',
        filter != null && filter.isNotEmpty
            ? ['%$filter%', '%${filter.toLowerCase()}%']
            : null);
    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
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

  // static Product _parseProduct(Map<String, dynamic> json) {
  //   Product product = Product();
  //   product.productId = json[PRODUCT_ID];
  //   product.productName = json[PRODUCT_NAME];
  //   product.package = json[PACKAGE];
  //   product.productType = json[PRODUCT_TYPE] != "null"
  //       ? ProductType.values.firstWhere((e) => e.name == json[PRODUCT_TYPE])
  //       : ProductType.consumable;
  //   product.isBundled = bool.tryParse(json[IS_BUNDLED]);
  //   product.canBeSold = bool.tryParse(json[CAN_BE_SOLD]);
  //   product.canBePurchased = bool.tryParse(json[CAN_BE_PURCHASED]);
  //   product.canBeManufactured = bool.tryParse(json[CAN_BE_MANUFACTURED]);
  //   product.reInvoiceExpenses = json[RE_INVOICE_EXPENSES] != "null"
  //       ? ReInvoiceExpenses.values
  //           .firstWhere((e) => e.text == json[RE_INVOICE_EXPENSES])
  //       : ReInvoiceExpenses.no;
  //   product.invoicingPolicy = json[INVOICE_POLICY] != "null"
  //       ? InvoicingPolicy.values
  //           .firstWhere((e) => e.name == json[INVOICE_POLICY])
  //       : InvoicingPolicy.orderedQuantities;
  //   product.unitOfMeasure = json[UNIT_OF_MEASURE];
  //   product.baseUnitCount = double.tryParse(json[BASE_UNIT_COUNT].toString());
  //   product.isSecondaryUnit = bool.tryParse(json[IS_SECONDARY_UNIT]);
  //   product.purchaseUOM = json[PURCHASE_UOM];
  //   product.isCommissionBasedServices =
  //       bool.tryParse(json[IS_COMMISSION_BASED_SERVICES]);
  //   product.isThirdUnit = bool.tryParse(json[IS_THIRD_UNIT]);
  //   product.rebatePercentage =
  //       double.tryParse(json[REBATE_PERCENTAGE].toString());
  //   product.price = double.tryParse(json[PRICE].toString());
  //   product.salePrice = double.tryParse(json[SALE_PRICE].toString());
  //   product.latestPrice = double.tryParse(json[LATEST_PRICE].toString());
  //   product.productCategory = json[PRODUCT_CATEGORY];
  //   product.productBrand = json[PRODUCT_BRAND];
  //   product.qtyInBags = double.tryParse(json[QTY_IN_BAGS].toString());
  //   product.multipleOfQty = double.tryParse(json[MULTIPLE_OF_QTY].toString());
  //   product.oldInternalRef = json[OLD_INTERNAL_REF];
  //   product.internalRef = json[INTERNAL_REF];
  //   product.barcode = json[BARCODE];
  //   product.isClearance = bool.tryParse(json[IS_CLEARANCE]);
  //   product.itemType = json[ITEM_TYPE] != "null"
  //       ? ItemType.values.firstWhere((e) => e.text == json[ITEM_TYPE])
  //       : ItemType.none;
  //   product.countryCode = json[COUNTRY_CODE];
  //   product.allowNegativeStock = bool.tryParse(json[ALLOW_NEGATIVE_STOCK]);
  //   product.company = json[COMPANY];
  //   product.tags = json[TAGS];
  //   product.internalNotes = json[INTERNAL_NOTES];
  //   return product;
  // }

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
