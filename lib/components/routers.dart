import 'package:flutter/material.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/customer/customer_list_screen.dart';
import 'package:offline_pos/view/login/login_screen.dart';
import 'package:offline_pos/view/main_screen.dart';
import 'package:offline_pos/view/payment/order_payment_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
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
      case CustomerListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => CustomerListScreen(),
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
