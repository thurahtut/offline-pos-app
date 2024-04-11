import 'package:flutter/foundation.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/amount_tax_table.dart';
import 'package:offline_pos/database/table/discount_table.dart';
import 'package:offline_pos/database/table/order_and_order_line_table.dart';
import 'package:offline_pos/database/table/order_and_transaction_table.dart';
import 'package:offline_pos/database/table/promotion_rules_mapping_table.dart';
import 'package:offline_pos/database/table/promotion_rules_table.dart';
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
      var databasesPath = await checkPath();
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

  Future<int> backupDatabase(BuildContext context, {bool? toDelete}) async {
    if (kIsWeb) {
      CommonUtils.showSnackBar(
          context: context, message: "Web is not supported");
      return 0;
    }
    String databasesPath;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var dir = await getApplicationDocumentsDirectory();
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      databasesPath = join(dir.path, _databaseName);
    } else {
      databasesPath = await checkPath();
    }
    File dbFile = File("$databasesPath\\$_databaseName");

    if (await dbFile.exists()) {
      // Database file exists, so create a backup file
      String externalDir = await CommonUtils.externalDirectoryPath(
          "Offline Pos Backup Database");
      String customDate = CommonUtils.getLocaleDateTime(
        "dd-MM-yyyy-hh-mm-ss",
        CommonUtils.getDateTimeNow().toString(),
      );
      String backupPath =
          join(externalDir, "offline-pos-backup-$customDate.db");
      await dbFile.copy(backupPath);
      if (toDelete == true) {
        try {
          // Delete the file
          await _db?.close();
          File("$databasesPath\\$_databaseName").deleteSync();
          _db = null;
          print('success');
        } catch (e) {
          print('Error while deleting the file: $e');
        }
      }
      return 1;
    }
    return 0; // Database file doesn't exist
  }

  Future<String> checkPath() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    if (!await Directory(dirname(path)).exists()) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
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
    await POSCategoryTable.onCreate(db, version);
    await AmountTaxTable.onCreate(db, version);
    await PendingOrderTable.onCreate(db, version);
    await ProductPackagingTable.onCreate(db, version);
    await PromotionTable.onCreate(db, version);
    await PromotionRuleTable.onCreate(db, version);
    await PromotionRuleMappingTable.onCreate(db, version);
    await DiscountSpecificProductMappingTable.onCreate(db, version);
    await DiscountTable.onCreate(db, version);

    await DBUpgrade.uploadAppConfigForVersion1(db);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {}
  }

  static Future<void> clearAll() async {
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
    await db.delete(POS_CATEGORY_TABLE_NAME);
    await db.delete(AMOUNT_TAX_TABLE_NAME);
    await db.delete(PENDING_ORDER_TABLE_NAME);
    await db.delete(PRODUCT_PACKAGING_TABLE_NAME);
    await db.delete(PROMOTION_TABLE_NAME);
    await db.delete(PROMOTION_RULE_TABLE_NAME);
    await db.delete(PROMOTION_RULE_MAPPING_TABLE_NAME);
    await db.delete(DISCOUNT_SPECIFIC_PRODUCT_MAPPING_TABLE_NAME);
    await db.delete(DISCOUNT_TABLE_NAME);
  }

  static Future<void> userLogOut() async {
    final db = await DatabaseHelper().db;
    await db.delete(LOGIN_USER_TABLE_NAME);
    await db.delete(POS_CONFIG_TABLE_NAME);
    await db.delete(POS_SESSION_TABLE_NAME);
    await db.delete(EMPLOYEE_TABLE_NAME);
    await db.delete(PENDING_ORDER_TABLE_NAME);
  }
}
