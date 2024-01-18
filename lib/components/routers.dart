import 'dart:developer';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/category/product_category_list_screen.dart';
import 'package:offline_pos/view/data_sync/morning_sync_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log(settings.name.toString());
    switch (settings.name) {
      case WelcomeScreen.routeName:
        return MaterialPageRoute(
          // settings: RouteSettings(name: 'Login'),
          builder: (_) => WelcomeScreen(),
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
      // case InventoryListScreen.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => InventoryListScreen(),
      //   );
      case ProductPackagingScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductPackagingScreen(),
        );
      case ProductListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductListScreen(),
        );
      case PriceItemListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => PriceItemListScreen(),
        );
      case ProductDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(),
        );
      case OrderPaymentReceiptScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => OrderPaymentReceiptScreen(),
        );
      case ProductCategoryListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ProductCategoryListScreen(),
        );
      case EmployeeListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => EmployeeListScreen(),
        );
      case MorningSyncScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => MorningSyncScreen(),
        );
      case ThemeSettingScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ThemeSettingScreen(),
        );
      case ManualSyncScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ManualSyncScreen(),
        );
      default:
        {
          return MaterialPageRoute(
            builder: (_) => LoginScreen(),
          );
          //  MaterialPageRoute(
          //   builder: (context) => Scaffold(
          //     appBar: AppBar(),
          //     body: SafeArea(
          //       child: Center(
          //         child: Text(
          //           "Route name not found ${settings.name}",
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        }
    }
  }
}
