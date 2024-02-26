// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const AMOUNT_TAX_TABLE_NAME = "amount_tax_table";
const AMOUNT_TAX_ID = "id";
const AMOUNT_TAX_NAME = "name";
const TYPE_TAX_USE = "type_tax_use";
const TAX_SCOPE = "tax_scope";
const DESCRIPTION_IN_TAX = "description";
const COMPANY_ID_IN_TAX = "company_id";

class AmountTaxTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $AMOUNT_TAX_TABLE_NAME("
        "$AMOUNT_TAX_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$AMOUNT_TAX_NAME TEXT,"
        "$TYPE_TAX_USE TEXT,"
        "$TAX_SCOPE TEXT,"
        "$DESCRIPTION_IN_TAX TEXT,"
        "$COMPANY_ID_IN_TAX INTEGER"
        ")");
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      AmountTax amountTax = AmountTax.fromJson(element);
      batch.insert(
        AMOUNT_TAX_TABLE_NAME,
        amountTax.toJson(),
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
}
