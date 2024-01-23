import 'dart:convert';

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
    double tQty = 0;
    double tTotal = 0;
    for (var i = 0; i < cOrderList.length; i++) {
      tQty +=
          double.tryParse(cOrderList[i].onhandQuantity?.toString() ?? "0") ?? 0;
      tTotal += (double.tryParse(
                  cOrderList[i].onhandQuantity?.toString() ?? "0") ??
              0) *
          (double.tryParse(
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

  Map<int, PaymentTransaction> _paymentTransactionList = {};
  Map<int, PaymentTransaction> get paymentTransactionList =>
      _paymentTransactionList;
  set paymentTransactionList(
      Map<int, PaymentTransaction> paymentTransactionList) {
    _paymentTransactionList = paymentTransactionList;
    notifyListeners();
  }

  int _selectedPaymentMethodId = -1;
  int get selectedPaymentMethodId => _selectedPaymentMethodId;
  set selectedPaymentMethodId(int selectedPaymentMethodId) {
    _selectedPaymentMethodId = selectedPaymentMethodId;
    notifyListeners();
  }

  OrderHistory? _orderHistory;
  OrderHistory? get orderHistory => _orderHistory;
  set orderHistory(OrderHistory? orderHistory) {
    if (_orderHistory == orderHistory) return;
    _orderHistory = orderHistory;
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

  void addItemToList(Product product) {
    Product orderProduct = Product.fromJson(jsonDecode(jsonEncode(product)));
    PriceListItem? priceListItem = product.priceListItem != null
        ? PriceListItem.fromJson(jsonDecode(jsonEncode(product.priceListItem)))
        : null;
    orderProduct.priceListItem = priceListItem;
    int index = currentOrderList
        .indexWhere((e) => e.productId == orderProduct.productId);
    if (index >= 0) {
      orderProduct.onhandQuantity =
          (currentOrderList[index].onhandQuantity ?? 0) + 1;
      currentOrderList[index] = orderProduct;
    } else {
      orderProduct.onhandQuantity = 1;
      currentOrderList.add(orderProduct);
    }
    notifyListeners();
  }

  resetCurrentOrderController() {
    _currentOrderList = [];
    _selectedIndex = null;
    _currentOrderKeyboardState = CurrentOrderKeyboardState.qty;
    _paymentMethodList = [];
    _paymentTransactionList = {};
    _selectedPaymentMethodId = -1;
    _orderHistory = null;
    notifyListeners();
  }
}
