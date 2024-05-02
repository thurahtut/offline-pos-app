import 'dart:convert';

import 'package:offline_pos/components/export_files.dart';

class RefundOrderController with ChangeNotifier {
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

  Map<String, double> getTotalQty(List<Product> cOrderList) {
    Map<String, double> map = {};
    double tQty = 0;
    double tTotal = 0;
    double tTax = 0;
    double tDis = 0;
    for (var i = 0; i < cOrderList.length; i++) {
      tQty +=
          double.tryParse(cOrderList[i].onhandQuantity?.toString() ?? "0") ?? 0;
      tTotal += ((double.tryParse(
                      cOrderList[i].onhandQuantity?.toString() ?? "0") ??
                  0) *
              (double.tryParse(
                      cOrderList[i].priceListItem?.fixedPrice?.toString() ??
                          "0") ??
                  0)) -
          (((double.tryParse(cOrderList[i].onhandQuantity?.toString() ?? "0") ??
                      0) *
                  (double.tryParse(
                          cOrderList[i].priceListItem?.fixedPrice?.toString() ??
                              "0") ??
                      0)) *
              ((cOrderList[i].discount ?? 0) / 100));

      tDis +=
          ((double.tryParse(cOrderList[i].onhandQuantity?.toString() ?? "0") ??
                      0) *
                  (double.tryParse(
                          cOrderList[i].priceListItem?.fixedPrice?.toString() ??
                              "0") ??
                      0)) *
              ((cOrderList[i].discount ?? 0) / 100);

      tTax += (cOrderList[i].onhandQuantity?.toDouble() ?? 0) *
          (CommonUtils.getPercentAmountTaxOnProduct(cOrderList[i]) > 0
              ? ((cOrderList[i].priceListItem?.fixedPrice ?? 0) *
                  CommonUtils.getPercentAmountTaxOnProduct(cOrderList[i]))
              : 0);
    }
    map["qty"] = double.tryParse(tQty.toStringAsFixed(2)) ?? 0;
    map["total"] = double.tryParse(tTotal.toStringAsFixed(2)) ?? 0;
    map["tax"] = double.tryParse(tTax.toStringAsFixed(2)) ?? 0;
    map["tDis"] = double.tryParse(tDis.toStringAsFixed(2)) ?? 0;
    map["untaxed"] = (double.tryParse(tTotal.toStringAsFixed(2)) ?? 0) -
        (double.tryParse(tTax.toStringAsFixed(2)) ?? 0);
    return map;
  }

  double? _paymentAmount;
  double? get paymentAmount => _paymentAmount;
  set paymentAmount(double? paymentAmount) {
    if (_paymentAmount == paymentAmount) return;
    _paymentAmount = paymentAmount;
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

  Customer? _selectedCustomer;
  Customer? get selectedCustomer => _selectedCustomer;
  set selectedCustomer(Customer? selectedCustomer) {
    if (_selectedCustomer == selectedCustomer) return;
    _selectedCustomer = selectedCustomer;
    notifyListeners();
  }

  Customer? _selectingCustomer;
  Customer? get selectingCustomer => _selectingCustomer;
  set selectingCustomer(Customer? selectingCustomer) {
    if (_selectingCustomer == selectingCustomer) return;
    _selectingCustomer = selectingCustomer;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  Future<void> updateCurrentOrder(
    String value, {
    bool? isBack,
    Discount? discount,
    String? shDiscountReason,
  }) async {
    if (selectedIndex != null) {
      Product product = currentOrderList.elementAt(selectedIndex!);

      product.priceListItem ??= PriceListItem();
      String qty = product.refundQuantity?.toString() ?? "";
      if (isBack == true) {
        int? employeeId;
        String? employeeName;
        int? sessionId;
        if (NavigationService.navigatorKey.currentContext != null) {
          employeeId = NavigationService.navigatorKey.currentContext!
                  .read<LoginUserController>()
                  .loginEmployee
                  ?.id ??
              0;
          employeeName = NavigationService.navigatorKey.currentContext!
                  .read<LoginUserController>()
                  .loginEmployee
                  ?.name ??
              '';
          sessionId = NavigationService.navigatorKey.currentContext!
                  .read<LoginUserController>()
                  .posSession
                  ?.id ??
              0;
        }
        DeletedProductLog deletedProductLog = DeletedProductLog(
          orderId: orderHistory?.id ?? 0,
          productId: product.productId,
          productName: product.productName,
          employeeId: employeeId,
          employeeName: employeeName,
          originalQty: qty,
          sessionId: sessionId,
          date: CommonUtils.getDateTimeNow().toString(),
        );

        qty = qty.substring(0, qty.length - 1);
        if (qty.isEmpty) {
          qty = "1";
        }
        deletedProductLog.updatedQty = qty;

        CommonUtils.saveDeletedItemLogs([deletedProductLog]);
      } else {
        if (product.firstTime == true) {
          qty = (qty == "1" && value != "0" ? "" : qty);
          product.firstTime = false;
        }

        if ((product.onhandQuantity ?? 0) < (int.tryParse(qty + value) ?? 0)) {
          if (NavigationService.navigatorKey.currentContext != null) {
            showDialog(
              context: NavigationService.navigatorKey.currentContext!,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade200,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Maximum Exceeded',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  insetPadding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  content: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                    color: Colors.white,
                    child: Text(
                      'The requested quantity to be refunded is higher than the ordered quantity. '
                      '${qty + value} is requested while only ${product.onhandQuantity} cand be refunded.',
                      style: TextStyle(color: Colors.red.shade500),
                    ),
                  ),
                  actions: [
                    InkWell(
                      child: Container(
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("Ok")),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          qty += value;
        }
      }
      product.refundQuantity = int.tryParse(qty);
      notifyListeners();

      PendingOrderTable.insertOrUpdateCurrentOrderListWithDB(
          productList: jsonEncode(currentOrderList));
    }
  }

  void handleKeyEvent(
      RawKeyEvent event, ItemListController itemListController) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        updateCurrentOrder("", isBack: true);
      } else if (event.logicalKey.keyLabel == "1" ||
          event.logicalKey.keyLabel == "2" ||
          event.logicalKey.keyLabel == "3" ||
          event.logicalKey.keyLabel == "4" ||
          event.logicalKey.keyLabel == "5" ||
          event.logicalKey.keyLabel == "6" ||
          event.logicalKey.keyLabel == "7" ||
          event.logicalKey.keyLabel == "8" ||
          event.logicalKey.keyLabel == "9" ||
          event.logicalKey.keyLabel == "0" ||
          event.logicalKey.keyLabel == ".") {
        updateCurrentOrder(event.logicalKey.keyLabel);
      }
    }
  }

  resetRefundOrderController() {
    _currentOrderList = [];
    _selectedIndex = null;
    _paymentMethodList = [];
    _paymentTransactionList = {};
    _selectedPaymentMethodId = -1;
    _orderHistory = null;
    _selectedCustomer = null;
    _selectingCustomer = null;
    notifyListeners();
  }
}
