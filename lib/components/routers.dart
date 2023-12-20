import 'dart:developer';

import 'package:offline_pos/components/export_files.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log(settings.name.toString());
    switch (settings.name) {
      case WelcomeScreen.routeName:
        return MaterialPageRoute(
          // settings: RouteSettings(name: 'Login'),
          builder: (_) => WelcomeScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          // settings: RouteSettings(name: 'Login'),
          builder: (_) => LoginScreen(),
        );
      case MainScreen.routeName:
        return MaterialPageRoute(
          // settings: RouteSettings(name: 'Home'),
          builder: (_) => MainScreen(),
        );
      case OrderPaymentScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => OrderPaymentScreen(),
        );
      case OrderHistoryListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => OrderHistoryListScreen(),
        );
      case QuotationOrderListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => QuotationOrderListScreen(),
        );
      case OrderListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => OrderListScreen(),
        );
      case PaymentMethodScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(),
        );
      case InventoryListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => InventoryListScreen(),
        );
      case ProductPackagingScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductPackagingScreen(),
        );
      case ProductListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductListScreen(),
        );
      case PriceRulesListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => PriceRulesListScreen(),
        );
      case ProductDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(),
        );
      default:
        {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                child: Center(
                  child: Text(
                    "Route name not found ${settings.name}",
                  ),
                ),
              ),
            ),
          );
        }
    }
  }
}
