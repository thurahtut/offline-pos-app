import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBUpgrade {
  static Future<void> uploadAppConfigForVersion1(final Database db) async {
    await AppConfigTable.insertOrUpdateWithDB(
        db,
        THEME_BODY_COLOR,
        primaryColor
            .toString()
            .toLowerCase()
            .replaceAll("color(0xff", "")
            .replaceAll(")", ""));
    await AppConfigTable.insertOrUpdateWithDB(db, LOGO, "");
    await AppConfigTable.insertOrUpdateWithDB(db, DB_VERSION, "1");
    await AppConfigTable.insertOrUpdateWithDB(db, REMEMBER_PASSWORD, "true");
  }
}
