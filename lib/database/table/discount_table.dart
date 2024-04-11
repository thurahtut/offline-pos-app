// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const DISCOUNT_TABLE_NAME = "discount_table";
const DISCOUNT_ID = "id";
const SH_DISCOUNT_NAME = "sh_discount_name";
const SH_DISCOUNT_CODE = "sh_discount_code";
const SH_DISCOUNT_VALUE = "sh_discount_value";
const CREATE_UID_IN_DIS = "create_uid";
const CREATED_DATE_IN_DIS = "create_date";
const WRITE_UID_IN_DIS = "write_uid";
const WRITE_DATE_IN_DIS = "write_date";

class DiscountTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $DISCOUNT_TABLE_NAME("
        "$DISCOUNT_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$SH_DISCOUNT_NAME TEXT,"
        "$SH_DISCOUNT_CODE TEXT,"
        "$SH_DISCOUNT_VALUE INTEGER,"
        "$CREATE_UID_IN_DIS INTEGER,"
        "$CREATED_DATE_IN_DIS TEXT,"
        "$WRITE_UID_IN_DIS INTEGER,"
        "$WRITE_DATE_IN_DIS TEXT"
        ")");
  }

  static Future<int> insert(Discount discount) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(DISCOUNT_TABLE_NAME, discount.toJson());
  }

  static Future<void> insertOrUpdate(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    int index = 0;
    for (final element in data) {
      Discount discount = Discount.fromJson(element);
      batch.insert(
        DISCOUNT_TABLE_NAME,
        discount.toJson(),
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

  static Future<List<Discount>> getDiscountList() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    String query = "select * "
        "from $DISCOUNT_TABLE_NAME "
        "order by $DISCOUNT_ID asc ";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (index) {
      return Discount.fromJson(maps[index]);
    });
  }

  static Future<void> deleteAll({Database? db}) async {
    db ??= await DatabaseHelper().db;
    db.rawQuery("delete from $DISCOUNT_TABLE_NAME");
  }
}
