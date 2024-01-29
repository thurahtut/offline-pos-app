import 'package:offline_pos/components/export_files.dart';

class OrderDetailController with ChangeNotifier {
  OrderHistory? _orderHistory;
  OrderHistory? get orderHistory => _orderHistory;
  set orderHistory(OrderHistory? orderHistory) {
    if (orderHistory == _orderHistory) return;
    _orderHistory = orderHistory;
    notifyListeners();
  }

  int _headerIndex = 0;
  int get headerIndex => _headerIndex;
  set headerIndex(int headerIndex) {
    if (_headerIndex == headerIndex) return;
    _headerIndex = headerIndex;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  resetOrderDetailController() {
    _orderHistory = null;
    _headerIndex = 0;
    notifyListeners();
  }
}
