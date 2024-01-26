import 'package:offline_pos/components/export_files.dart';

class OrderDetailController with ChangeNotifier {
  OrderHistory? _orderHistory;
  OrderHistory? get orderHistory => _orderHistory;
  set orderHistory(OrderHistory? orderHistory) {
    if (orderHistory == _orderHistory) return;
    _orderHistory = orderHistory;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  resetOrderDetailController() {
    _orderHistory = null;
    notifyListeners();
  }
}
