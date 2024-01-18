import 'package:offline_pos/components/export_files.dart';

class CurrentOrderController with ChangeNotifier {
  List<Product> _currentOrderList = [];
  List<Product> get currentOrderList => _currentOrderList;

  set currentOrderList(List<Product> currentOrderList) {
    _currentOrderList = currentOrderList;
    notifyListeners();
  }

  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;
  set selectedIndex(int? selectedIndex) {
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
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
      tQty +=
          int.tryParse(cOrderList[i].onhandQuantity?.toString() ?? "0") ?? 0;
      tTotal += (int.tryParse(
                  cOrderList[i].onhandQuantity?.toString() ?? "0") ??
              0) *
          (int.tryParse(
                  cOrderList[i].priceListItem?.fixedPrice?.toString() ?? "0") ??
              0); //int.tryParse(cOrderList[i].salePrice?.toString() ?? "0") ??
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

  CurrentOrderKeyboardState _currentOrderKeyboardState =
      CurrentOrderKeyboardState.qty;
  CurrentOrderKeyboardState get currentOrderKeyboardState =>
      _currentOrderKeyboardState;
  set currentOrderKeyboardState(
      CurrentOrderKeyboardState currentOrderKeyboardState) {
    if (currentOrderKeyboardState == _currentOrderKeyboardState) return;
    _currentOrderKeyboardState = currentOrderKeyboardState;
    notifyListeners();
  }

  List<PaymentMethod> _paymentMethodList = [];
  List<PaymentMethod> get paymentMethodList => _paymentMethodList;
  set paymentMethodList(List<PaymentMethod> paymentMethodList) {
    _paymentMethodList = paymentMethodList;
    notifyListeners();
  }

  Map<String, PaymentTransaction> _paymentTransactionList = {};
  Map<String, PaymentTransaction> get paymentTransactionList =>
      _paymentTransactionList;
  set paymentTransactionList(
      Map<String, PaymentTransaction> paymentTransactionList) {
    _paymentTransactionList = paymentTransactionList;
    notifyListeners();
  }

  Future<void> getAllPaymentMethod() async {
    PaymentMethodTable.getActivePaymentMethod().then((paymentMethods) {
      _paymentMethodList = [];
      if (paymentMethods != null) {
        _paymentMethodList.addAll(paymentMethods);
      }
      notifyListeners();
    });
  }

  resetCurrentOrderController() {
    _currentOrderList = [];
    _selectedIndex = null;
    _currentOrderKeyboardState = CurrentOrderKeyboardState.qty;
    _paymentMethodList = [];
    _paymentTransactionList = {};
    notifyListeners();
  }
}
