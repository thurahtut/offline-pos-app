import 'package:flutter/foundation.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/order_and_order_line_table.dart';
import 'package:offline_pos/database/table/order_and_transaction_table.dart';
import 'package:offline_pos/database/table/order_line_id_table.dart';
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
      databaseFactory = databaseFactoryFfiWeb;
      // await deleteDatabase(_databaseName);
      // path = join(_databaseName, _databaseName);
      return await databaseFactory.openDatabase(_databaseName,
          options: OpenDatabaseOptions(
            version: _databaseVersion,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
          ));
    } else {
      databaseFactory = databaseFactoryFfi;
      var databasesPath = await getDatabasesPath();
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
    await EmployeeTable.onCreate(db, version);
    await CustomerTable.onCreate(db, version);
    await ProductTable.onCreate(db, version);
    await PriceListItemTable.onCreate(db, version);
    await AppConfigTable.onCreate(db, version);
    await PaymentMethodTable.onCreate(db, version);
    await LoginUserTable.onCreate(db, version);
    await POSConfigTable.onCreate(db, version);
    await POSSessionTable.onCreate(db, version);
    await PaymentTransactionTable.onCreate(db, version);
    await OrderLineIdTable.onCreate(db, version);
    await OrderAndOrderLineTable.onCreate(db, version);
    await OrderAndPaymentTransactionTable.onCreate(db, version);
    await OrderHistoryTable.onCreate(db, version);

    await DBUpgrade.uploadAppConfigForVersion1(db);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {}
  }

  static Future<void> clear() async {
    final db = await DatabaseHelper().db;
    await db.delete(PRODUCT_TABLE_NAME);
    await db.delete(PRICE_LIST_ITEM_TABLE_NAME);
    await db.delete(EMPLOYEE_TABLE_NAME);
    await db.delete(CUSTOMER_TABLE_NAME);
    await db.delete(PAYMENT_METHOD_TABLE_NAME);
    await db.delete(LOGIN_USER_TABLE_NAME);
    await db.delete(POS_CONFIG_TABLE_NAME);
    await db.delete(POS_SESSION_TABLE_NAME);
    await db.delete(PAYMENT_TRANSACTION_TABLE_NAME);
    await db.delete(ORDER_LINE_ID_TABLE_NAME);
    await db.delete(ORDER_AND_ORDER_LINE_ID);
    await db.delete(ORDER_AND_PAYMENT_TRANSACTION_ID);
    await db.delete(ORDER_HISTORY_TABLE_NAME);
  }
}
