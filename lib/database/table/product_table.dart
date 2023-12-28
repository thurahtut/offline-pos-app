// ignore_for_file: constant_identifier_names

import 'package:offline_pos/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../components/export_files.dart';

const PRODUCT_TABLE_NAME = "product_table";
const PRODUCT_ID = "product_id";
const PRODUCT_NAME = "product_name";
const PACKAGE = "package";
const PRODUCT_TYPE = "product_type";
const IS_BUNDLED = "is_bundled";
const CAN_BE_SOLD = "can_be_sold";
const CAN_BE_PURCHASED = "can_be_purchased";
const CAN_BE_MANUFACTURED = "can_be_manufactured";
const RE_INVOICE_EXPENSES = "re_invoice_expenses";
const INVOICE_POLICY = "invoice_policy";
const UNIT_OF_MEASURE = "unit_of_measure";
const BASE_UNIT_COUNT = "base_unit_count";
const IS_SECONDARY_UNIT = "is_secondary_count";
const PURCHASE_UOM = "purchase_uom";
const IS_COMMISSION_BASED_SERVICES = "is_commission_based_services";
const IS_THIRD_UNIT = "is_third_unit";
const REBATE_PERCENTAGE = "rebate_percentage";
const PRICE = "price";
const SALE_PRICE = "sale_price";
const LATEST_PRICE = "latest_price";
const PRODUCT_CATEGORY = "product_category";
const PRODUCT_BRAND = "product_brand";
const QTY_IN_BAGS = "qty_in_bags";
const MULTIPLE_OF_QTY = "multiple_of_qty";
const OLD_INTERNAL_REF = "old_internal_ref";
const INTERNAL_REF = "internal_ref";
const BARCODE = "barcode";
const IS_CLEARANCE = "is_clearance";
const ITEM_TYPE = "item_type";
const COUNTRY_CODE = "country_code";
const ALLOW_NEGATIVE_STOCK = "allow_negative_stock";
const COMPANY = "company";
const TAGS = "tags";
const INTERNAL_NOTES = "internal_notes";

class ProductTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $PRODUCT_TABLE_NAME("
        "$PRODUCT_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$PRODUCT_NAME TEXT NOT NULL,"
        "$PACKAGE TEXT NOT NULL,"
        "$PRODUCT_TYPE TEXT NOT NULL,"
        "$IS_BUNDLED TEXT NOT NULL,"
        "$CAN_BE_SOLD TEXT NOT NULL,"
        "$CAN_BE_PURCHASED TEXT NOT NULL,"
        "$CAN_BE_MANUFACTURED TEXT NOT NULL,"
        "$RE_INVOICE_EXPENSES TEXT NOT NULL,"
        "$INVOICE_POLICY TEXT NOT NULL,"
        "$UNIT_OF_MEASURE TEXT NOT NULL,"
        "$BASE_UNIT_COUNT INTEGER,"
        "$IS_SECONDARY_UNIT TEXT NOT NULL,"
        "$PURCHASE_UOM TEXT NOT NULL,"
        "$IS_COMMISSION_BASED_SERVICES TEXT NOT NULL,"
        "$IS_THIRD_UNIT TEXT NOT NULL,"
        "$REBATE_PERCENTAGE REAL,"
        "$PRICE REAL,"
        "$SALE_PRICE REAL,"
        "$LATEST_PRICE REAL,"
        "$PRODUCT_CATEGORY TEXT NOT NULL,"
        "$PRODUCT_BRAND TEXT NOT NULL,"
        "$QTY_IN_BAGS REAL,"
        "$MULTIPLE_OF_QTY REAL,"
        "$OLD_INTERNAL_REF TEXT NOT NULL,"
        "$INTERNAL_REF TEXT NOT NULL,"
        "$BARCODE TEXT NOT NULL,"
        "$IS_CLEARANCE TEXT NOT NULL,"
        "$ITEM_TYPE TEXT NOT NULL,"
        "$COUNTRY_CODE TEXT NOT NULL,"
        "$ALLOW_NEGATIVE_STOCK TEXT NOT NULL,"
        "$COMPANY TEXT NOT NULL,"
        "$TAGS TEXT NOT NULL,"
        "$INTERNAL_NOTES TEXT NOT NULL"
        ")");
  }

  static Future<int> insert(Product product) async {
    final Database db = await DatabaseHelper().db;

    String sql = "INSERT INTO $PRODUCT_TABLE_NAME("
        "$PRODUCT_ID, $PRODUCT_NAME, $PACKAGE, $PRODUCT_TYPE, "
        "$IS_BUNDLED, $CAN_BE_SOLD, $CAN_BE_PURCHASED, $CAN_BE_MANUFACTURED, "
        "$RE_INVOICE_EXPENSES, $INVOICE_POLICY, $UNIT_OF_MEASURE, $BASE_UNIT_COUNT, "
        "$IS_SECONDARY_UNIT, $PURCHASE_UOM, $IS_COMMISSION_BASED_SERVICES, $IS_THIRD_UNIT, "
        "$REBATE_PERCENTAGE, $PRICE, $SALE_PRICE, $LATEST_PRICE, "
        "$PRODUCT_CATEGORY, $PRODUCT_BRAND, $QTY_IN_BAGS, $MULTIPLE_OF_QTY, "
        "$OLD_INTERNAL_REF, $INTERNAL_REF, $BARCODE, $IS_CLEARANCE, "
        "$ITEM_TYPE, $COUNTRY_CODE, $ALLOW_NEGATIVE_STOCK, $COMPANY, $TAGS, $INTERNAL_NOTES"
        ")"
        " VALUES("
        "'', '${product.productName}', '${product.package}', '${product.productType}', "
        "'${product.isBundled}', '${product.canBeSold}', '${product.canBePurchased}', '${product.canBeManufactured}', "
        "'${product.reInvoiceExpenses}', '${product.invoicingPolicy}', '${product.unitOfMeasure}', '${product.baseUnitCount}', "
        "'${product.isSecondaryUnit}', '${product.purchaseUOM}', '${product.isCommissionBasedServices}', '${product.isThirdUnit}', "
        "'${product.rebatePercentage}', '${product.price}', '${product.salePrice}', '${product.latestPrice}', "
        "'${product.productCategory}', '${product.productBrand}', '${product.qtyInBags}', '${product.multipleOfQty}', "
        "'${product.oldInternalRef}', '${product.internalRef}', '${product.barcode}', '${product.isClearance}', "
        "'${product.itemType}', '${product.countryCode}', '${product.allowNegativeStock}', '${product.company}', '${product.tags}', '${product.internalNotes}'"
        ")";

    return db.rawInsert(sql);
  }

  static Future<List<Product>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      PRODUCT_TABLE_NAME,
      orderBy: '$PRODUCT_ID DESC',
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return _parseProduct(maps[i]);
    });
  }

  static Product _parseProduct(Map<String, dynamic> json) {
    Product product = Product();
    product.productId = json[PRODUCT_ID];
    product.productName = json[PRODUCT_NAME];
    product.package = json[PACKAGE];
    product.productType = json[PRODUCT_TYPE];
    product.isBundled = bool.tryParse(json[IS_BUNDLED]);
    product.canBeSold = bool.tryParse(json[CAN_BE_SOLD]);
    product.canBePurchased = bool.tryParse(json[CAN_BE_PURCHASED]);
    product.canBeManufactured = bool.tryParse(json[CAN_BE_MANUFACTURED]);
    product.reInvoiceExpenses = json[RE_INVOICE_EXPENSES];
    product.invoicingPolicy = json[INVOICE_POLICY];
    product.unitOfMeasure = json[UNIT_OF_MEASURE];
    product.baseUnitCount = json[BASE_UNIT_COUNT];
    product.isSecondaryUnit = bool.tryParse(json[IS_SECONDARY_UNIT]);
    product.purchaseUOM = json[PURCHASE_UOM];
    product.isCommissionBasedServices =
        bool.tryParse(json[IS_COMMISSION_BASED_SERVICES]);
    product.isThirdUnit = bool.tryParse(json[IS_THIRD_UNIT]);
    product.rebatePercentage = json[REBATE_PERCENTAGE];
    product.price = json[PRICE];
    product.salePrice = json[SALE_PRICE];
    product.latestPrice = json[LATEST_PRICE];
    product.productCategory = json[PRODUCT_CATEGORY];
    product.productBrand = json[PRODUCT_BRAND];
    product.qtyInBags = json[QTY_IN_BAGS];
    product.multipleOfQty = json[MULTIPLE_OF_QTY];
    product.oldInternalRef = json[OLD_INTERNAL_REF];
    product.internalRef = json[INTERNAL_REF];
    product.barcode = json[BARCODE];
    product.isClearance = bool.tryParse(json[IS_CLEARANCE]);
    product.itemType = json[ITEM_TYPE];
    product.countryCode = json[COUNTRY_CODE];
    product.allowNegativeStock = json[ALLOW_NEGATIVE_STOCK];
    product.company = json[COMPANY];
    product.tags = json[TAGS];
    product.internalNotes = json[INTERNAL_NOTES];
    return product;
  }

  static Future<int> delete(int productId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      PRODUCT_TABLE_NAME,
      where: "$PRODUCT_ID=?",
      whereArgs: [productId],
    );
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
