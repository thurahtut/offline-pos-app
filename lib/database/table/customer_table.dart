// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const CUSTOMER_TABLE_NAME = "customer_table";
const CUSTOMER_ID_IN_CT = "customer_id";
const CUSTOMER_NAME = "name";
const BLOCKING_STAGE = "blocking_stage";
const CUSTOMER_STREET = "street";
const CITY_IN_CT = "city";
const STATE_ID = "state_id";
const COUNTRY_ID_IN_CT = "country_id";
const VAT = "vat";
const LANG_IN_CT = "lang";
const CUSTOMER_PHONE = "phone";
const ZIP = "zip";
const MOBILE = "mobile";
const EMAIL = "email";
const COMPANY_ID = "company_id";
const PROPERTY_PRODUCT_PRICELIST = "property_product_pricelist";
const BARCODE_IN_CT = "barcode";
const PROPERTY_ACCOUNT_POSITION_ID = "property_account_position_id";

class CustomerTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $CUSTOMER_TABLE_NAME("
        "$CUSTOMER_ID_IN_CT INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$CUSTOMER_NAME TEXT,"
        "$BLOCKING_STAGE INTEGER,"
        "$CUSTOMER_STREET TEXT,"
        "$CITY_IN_CT TEXT,"
        "$STATE_ID INTEGER,"
        "$COUNTRY_ID_IN_CT INTEGER,"
        "$VAT TEXT,"
        "$LANG_IN_CT TEXT,"
        "$CUSTOMER_PHONE TEXT,"
        "$ZIP TEXT,"
        "$MOBILE TEXT,"
        "$EMAIL TEXT,"
        "$COMPANY_ID INTEGER,"
        "$PROPERTY_PRODUCT_PRICELIST TEXT,"
        "$BARCODE_IN_CT TEXT,"
        "$PROPERTY_ACCOUNT_POSITION_ID INTEGER"
        ")");
  }

  static Future<int> insert(Customer customer) async {
    final Database db = await DatabaseHelper().db;
    String sql = "INSERT INTO $CUSTOMER_TABLE_NAME("
        "$CUSTOMER_NAME, "
        "$BLOCKING_STAGE, "
        "$CUSTOMER_STREET, "
        "$CITY_IN_CT, "
        "$STATE_ID, "
        "$COUNTRY_ID_IN_CT, "
        "$VAT, "
        "$LANG_IN_CT, "
        "$ZIP, "
        "$MOBILE, "
        "$EMAIL, "
        "$COMPANY_ID, "
        "$PROPERTY_PRODUCT_PRICELIST, "
        "$BARCODE_IN_CT, "
        "$PROPERTY_ACCOUNT_POSITION_ID"
        ")"
        " VALUES("
        "'${customer.name}',"
        "'${customer.blockingStage}',"
        "'${customer.street}',"
        "'${customer.city}',"
        "'${customer.stateId}',"
        "'${customer.countryId}',"
        "'${customer.vat}',"
        "'${customer.lang}'"
        "'${customer.phone}'"
        "'${customer.zip}'"
        "'${customer.mobile}'"
        "'${customer.email}'"
        "'${customer.companyId}'"
        "'${customer.propertyProductPricelist != null ? jsonEncode(customer.propertyProductPricelist) : null}'"
        "'${customer.barcode}'"
        "'${customer.propertyAccountPositionId}'"
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
      Customer customer = Customer.fromJson(element);
      batch.insert(
        CUSTOMER_TABLE_NAME,
        customer.toJson(),
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

  static Future<List<Customer>> getAll({
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      CUSTOMER_TABLE_NAME,
      orderBy: '$CUSTOMER_ID_IN_CT DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  static Future<int> getAllCustomerCount({
    String? filter,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    filter = filter?.toLowerCase();
    // Query the table for all The Categories.
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM $CUSTOMER_TABLE_NAME '
        '${filter != null && filter.isNotEmpty ? 'Where $CUSTOMER_ID_IN_CT Like ? or lower($CUSTOMER_NAME) Like ?' : ''}',
        filter != null && filter.isNotEmpty
            ? ['%$filter%', '%${filter.toLowerCase()}%']
            : null);
    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
  }

  static Future<List<Customer>> getCustomersFiltering({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      CUSTOMER_TABLE_NAME,
      where: filter != null
          ? "$CUSTOMER_ID_IN_CT LIKE ? or lower($CUSTOMER_NAME) LIKE ?"
          : null,
      whereArgs:
          filter != null ? ['%$filter%', '%${filter.toLowerCase()}%'] : null,
      // where: "$PRODUCT_NAME=?",
      // whereArgs: [filter],
      orderBy: '$CUSTOMER_ID_IN_CT DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  static Future<List<Customer>> getEmployeeWithFilter(String filter) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $CUSTOMER_TABLE_NAME "
            "where $CUSTOMER_NAME like '%$filter%' "
            "or $BARCODE_IN_CT like '%$filter%'");

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  static Future<Customer?> getCustomerByCustomerId(int customerId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      CUSTOMER_TABLE_NAME,
      where: "$CUSTOMER_ID_IN_CT=?",
      whereArgs: [customerId],
      limit: 1,
    );

    return Customer.fromJson(maps.first);
  }

  static Future<Customer?> checkCustomerWithIdAndPassword(
      int customerId, String password) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $CUSTOMER_TABLE_NAME "
            "where $CUSTOMER_ID_IN_CT='$customerId' "
            "and $PIN='$password'");

    return maps.isEmpty ? null : Customer.fromJson(maps.first);
  }

  static Future<int> delete(int customerId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      CUSTOMER_TABLE_NAME,
      where: "$CUSTOMER_ID_IN_CT=?",
      whereArgs: [customerId],
    );
  }

  static Future<void> deleteAll(Database db) async {
    db.rawQuery("delete from $CUSTOMER_TABLE_NAME");
  }

  static Future<int> update(Customer customer) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      CUSTOMER_TABLE_NAME,
      customer.toJson(),
      where: "$CUSTOMER_ID_IN_CT=?",
      whereArgs: [customer.id],
    );
  }
}
