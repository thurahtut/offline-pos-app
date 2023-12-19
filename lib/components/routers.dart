import 'dart:developer';

import 'package:offline_pos/components/export_files.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log(settings.name.toString());
    switch (settings.name) {
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
