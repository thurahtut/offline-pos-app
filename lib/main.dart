import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/controller/morning_sync_controller.dart';
import 'package:offline_pos/controller/theme_setting_controller.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  initializeDateFormatting().then((_) {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      // Initialize FFI
      sqfliteFfiInit();
    }
    DatabaseHelper().db;
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewController()),
        ChangeNotifierProvider(create: (_) => CurrentOrderController()),
        ChangeNotifierProvider(create: (_) => CustomerListController()),
        ChangeNotifierProvider(create: (_) => OrderHistoryListController()),
        ChangeNotifierProvider(create: (_) => QuotationOrderListController()),
        ChangeNotifierProvider(create: (_) => OrderListController()),
        ChangeNotifierProvider(create: (_) => PaymentMethodListController()),
        ChangeNotifierProvider(create: (_) => ProductPackagingController()),
        ChangeNotifierProvider(create: (_) => ProductListController()),
        ChangeNotifierProvider(create: (_) => PriceRulesListController()),
        ChangeNotifierProvider(create: (_) => ProductDetailController()),
        ChangeNotifierProvider(create: (_) => EmployeeListController()),
        ChangeNotifierProvider(create: (_) => MorningsyncController()),
        ChangeNotifierProvider(create: (_) => ItemListController()),
        ChangeNotifierProvider(create: (_) => ThemeSettingController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Offline POS',
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: WelcomeScreen.routeName,
        home: WelcomeScreen(),
        onGenerateRoute: Routers.generateRoute,
        theme: ThemeData(
            textTheme:
                GoogleFonts.outfitTextTheme(Theme.of(context).textTheme)),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
