// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

const POS_CATEGORY_TABLE_NAME = "pos_category_table";
const POS_CATEGORY_ID = "id";
const POS_CATEGORY_NAME = "name";
const PARENT_ID_IN_CAT = "parent_id";
const WRITE_DATE_IN_CAT = "write_date";
const WRITE_UID_IN_CAT = "write_uid";

class POSCategoryTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $POS_CATEGORY_TABLE_NAME("
        "$POS_CATEGORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$POS_CATEGORY_NAME TEXT NOT NULL,"
        "$PARENT_ID_IN_CAT INTEGER,"
        "$WRITE_UID_IN_CAT INTEGER,"
        "$WRITE_DATE_IN_CAT TEXT"
        ")");
  }

  static Future<void> insertOrUpdate(PosCategory posCategory) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    batch.insert(
      POS_CATEGORY_TABLE_NAME,
      posCategory.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await batch.commit(noResult: true);
  }

  static Future<void> insertOrUpdateWithList(List<dynamic> data) async {
    final Database db = await DatabaseHelper().db;
    Batch batch = db.batch();
    // var time = DateTime.now();
    int index = 0;
    for (final element in data) {
      PosCategory posCategory = PosCategory.fromJson(element);
      batch.insert(
        POS_CATEGORY_TABLE_NAME,
        posCategory.toJson(),
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

  static Future<List<PosCategory>> getAllPosCategory({
    int? limit,
    int? offset,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      POS_CATEGORY_TABLE_NAME,
      orderBy: '$POS_CATEGORY_ID DESC',
      limit: limit,
      offset: offset,
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return PosCategory.fromJson(maps[i]);
    });
  }
}
