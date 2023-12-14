import 'package:google_fonts/google_fonts.dart';
import 'package:offline_pos/components/export_files.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewController()),
        ChangeNotifierProvider(create: (_) => CurrentOrderController()),
        ChangeNotifierProvider(create: (_) => CustomerListController()),
        ChangeNotifierProvider(create: (_) => OrderHistoryListController()),
        ChangeNotifierProvider(create: (_) => QuotationOrderListController()),
        ChangeNotifierProvider(create: (_) => OrderListController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Offline POS',
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: OrderHistoryListScreen.routeName,
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
