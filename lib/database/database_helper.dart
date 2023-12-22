import 'package:offline_pos/components/export_files.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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

    var databaseFactory = databaseFactoryFfi;
    String path;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var dir = await getApplicationDocumentsDirectory();
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      path = join(dir.path, _databaseName);

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } else {
      var databasesPath = await getDatabasesPath();
      path = join(databasesPath, _databaseName);
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

  void _onCreate(Database db, int version) async {}

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // static Future<void> clear() async {
  //   final db = await DatabaseHelper().db;
  //   //  await db.delete(tableName);
  // }
}
