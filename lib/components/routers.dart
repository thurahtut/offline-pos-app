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
      case MainScreen.routeName:
        final MainScreen? args = settings.arguments as MainScreen?;
        return MaterialPageRoute(
          // settings: RouteSettings(name: 'Home'),
          builder: (_) => MainScreen(
            resetController: args?.resetController,
          ),
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
        final OrderPaymentReceiptScreen? args =
            settings.arguments as OrderPaymentReceiptScreen?;
        return MaterialPageRoute(
          builder: (_) => OrderPaymentReceiptScreen(
            isNewOrder: args?.isNewOrder,
          ),
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
        final MorningSyncScreen? args =
            settings.arguments as MorningSyncScreen?;
        return MaterialPageRoute(
          builder: (_) => MorningSyncScreen(
            alreadyLogin: args?.alreadyLogin,
          ),
        );
      case ThemeSettingScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ThemeSettingScreen(),
        );
      case ManualSyncScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ManualSyncScreen(),
        );
      case OrderDetailScreen.routeName:
        final OrderDetailScreen? args =
            settings.arguments as OrderDetailScreen?;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(
            orderId: args?.orderId ?? 0,
          ),
        );
      case RefundedOrderDetailScreen.routeName:
        final RefundedOrderDetailScreen? args =
            settings.arguments as RefundedOrderDetailScreen?;
        return MaterialPageRoute(
          builder: (_) => RefundedOrderDetailScreen(
            orderId: args?.orderId ?? 0,
          ),
        );
      case SessionLoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => SessionLoginScreen(),
        );
      case PromotionListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => PromotionListScreen(),
        );
      case PromotionListDetailScreen.routeName:
        final PromotionListDetailScreen? args =
            settings.arguments as PromotionListDetailScreen?;
        return MaterialPageRoute(
          builder: (_) => PromotionListDetailScreen(
            promotion: args?.promotion,
          ),
        );
      case SummaryReportScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => SummaryReportScreen(),
        );
      case RefundOrderScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => RefundOrderScreen(),
        );
      case SelectedRefundOrderScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => SelectedRefundOrderScreen(),
        );
      case RefundedOrderListScreen.routeName:
        final RefundedOrderListScreen? args =
            settings.arguments as RefundedOrderListScreen?;
        return MaterialPageRoute(
          builder: (_) => RefundedOrderListScreen(
            orderId: args?.orderId,
          ),
        );
      // case DeletedProductLogScreen.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => DeletedProductLogScreen(),
      //   );
      // case DeletedLogsTypeScreen.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => DeletedLogsTypeScreen(),
      //   );
      default:
        {
          return MaterialPageRoute(
            builder: (_) => UserLoginScreen(),
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
