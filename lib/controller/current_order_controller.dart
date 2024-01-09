import 'package:offline_pos/components/export_files.dart';

class CurrentOrderController with ChangeNotifier {
  List<Product> _currentOrderList = [];
  List<Product> get currentOrderList => _currentOrderList;

  set currentOrderList(List<Product> currentOrderList) {
    _currentOrderList = currentOrderList;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  List getTotalQty(List<Product> cOrderList) {
    List list = [0, 0];
    int tQty = 0;
    int tTotal = 0;
    for (var i = 0; i < cOrderList.length; i++) {
      tQty += int.tryParse(cOrderList[i].qty?.toString() ?? "0") ?? 0;
      tTotal += (int.tryParse(cOrderList[i].qty?.toString() ?? "0") ?? 0) *
          (0); //int.tryParse(cOrderList[i].salePrice?.toString() ?? "0") ??
    }
    list.first = tQty;
    list.last = tTotal;
    return list;
  }

  bool? _isContainCustomer = false;
  bool? get isContainCustomer => _isContainCustomer;
  set isContainCustomer(bool? isContainCustomer) {
    if (_isContainCustomer == isContainCustomer) return;
    _isContainCustomer = isContainCustomer;
    notifyListeners();
  }

  double? _paymentAmount;
  double? get paymentAmount => _paymentAmount;
  set paymentAmount(double? paymentAmount) {
    if (_paymentAmount == paymentAmount) return;
    _paymentAmount = paymentAmount;
    notifyListeners();
  }

  resetCurrentOrderController() {
    _currentOrderList = [];
    notifyListeners();
  }
}
