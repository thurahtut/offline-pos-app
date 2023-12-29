import 'package:flutter/foundation.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static Database? _db;
  final String _databaseName = 'offline_pos.db';
  final int _databaseVersion = 1;

  Future<Database> get db async {
    // Get a singleton database
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    // Get a location using getDatabasesPath
    String path;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var dir = await getApplicationDocumentsDirectory();
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      path = join(dir.path, _databaseName);

      // await deleteDatabase(path);
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } else if (kIsWeb) {
      var databaseFactory = databaseFactoryFfiWeb;
      // await deleteDatabase(_databaseName);
      // path = join(_databaseName, _databaseName);
      return await databaseFactory.openDatabase(_databaseName,
          options: OpenDatabaseOptions(
            version: _databaseVersion,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
          ));
    } else {
      var databasesPath = await getDatabasesPath();
      var databaseFactory = databaseFactoryFfi;
      path = join(databasesPath, _databaseName);
      // await deleteDatabase(path);
      return await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
            version: _databaseVersion,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
          ));
    }

    // This will delete old/previous database when app is opened
    // Delete the database
    // await deleteDatabase(path);

    // Open the database
  }

  void _onCreate(Database db, int version) async {
    await ProductTable.onCreate(db, version);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  static Future<void> clear() async {
    final db = await DatabaseHelper().db;
    await db.delete(PRODUCT_TABLE_NAME);
  }
}
