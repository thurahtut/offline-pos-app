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

  Map<String, double> getTotalQty(List<Product> cOrderList) {
    Map<String, double> map = {};
    double tQty = 0;
    double tTotal = 0;
    double tTax = 0;
    for (var i = 0; i < cOrderList.length; i++) {
      tQty +=
          double.tryParse(cOrderList[i].onhandQuantity?.toString() ?? "0") ?? 0;
      tTotal += (double.tryParse(
                  cOrderList[i].onhandQuantity?.toString() ?? "0") ??
              0) *
          (double.tryParse(
                  cOrderList[i].priceListItem?.fixedPrice?.toString() ?? "0") ??
              0);

      tTax += (cOrderList[i].onhandQuantity?.toDouble() ?? 0) *
          ((cOrderList[i].priceListItem?.fixedPrice ?? 0) * 0.05);
    }
    map["qty"] = double.tryParse(tQty.toStringAsFixed(2)) ?? 0;
    map["total"] = double.tryParse(tTotal.toStringAsFixed(2)) ?? 0;
    map["tax"] = double.tryParse(tTax.toStringAsFixed(2)) ?? 0;
    return map;
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
      orderProduct.firstTime = true;
      orderProduct.onhandQuantity = 1;
      currentOrderList.add(orderProduct);
    }
    notifyListeners();
    productTextFieldFocusNode.requestFocus();
  }

  void updateCurrentOrder(
    String value, {
    bool? isBack,
  }) {
    if (selectedIndex != null) {
      Product product = currentOrderList.elementAt(selectedIndex!);
      product.priceListItem ??= PriceListItem();
      if (currentOrderKeyboardState == CurrentOrderKeyboardState.price) {
        String price = product.priceListItem!.fixedPrice?.toString() ?? "";
        if (isBack == true) {
          price = price.substring(0, price.length - 1);
        } else {
          price += value;
        }
        product.priceListItem?.fixedPrice = int.tryParse(price);
        notify();
      } else if (currentOrderKeyboardState == CurrentOrderKeyboardState.qty) {
        String qty = product.onhandQuantity?.toString() ?? "";
        bool isDelete = false;
        if (isBack == true) {
          if (product.onhandQuantity == 1) {
            isDelete = true;
          } else {
            qty = qty.substring(0, qty.length - 1);
            if (qty.isEmpty) {
              qty = "1";
            }
          }
        } else {
          if (product.firstTime == true) {
            qty = (qty == "1" && value != "0" ? "" : qty);
            product.firstTime = false;
          }
          qty += value;
        }
        if (isDelete) {
          currentOrderList.removeAt(selectedIndex!);
          selectedIndex = null;
        } else {
          product.onhandQuantity = int.tryParse(qty);
        }
        notifyListeners();
      }
      // else if (currentOrderKeyboardState ==
      //     CurrentOrderKeyboardState.disc) {
      //   Product promotionProduct = product.cloneProduct();
      //   promotionProduct.onhandQuantity = 1;
      //   promotionProduct.priceListItem?.fixedPrice = 0;
      //   currentOrderList.insert(
      //       selectedIndex! + 1, promotionProduct);
      //   notify();
      // }
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
      //else if (event.logicalKey.keyLabel.length >= 3) {
      //   productTextFieldFocusNode.requestFocus();
      //   log('Key event: ${event.logicalKey}');
      //   log('Key event label: ${event.logicalKey.keyId}');
      //   // itemListController.filterValue = event.logicalKey.keyLabel;
      //   // TextEditingController con =
      //   //     TextEditingController(text: event.logicalKey.keyLabel);
      //   // log('Con Val :${con.text}');
      //   // itemListController.searchProduct(callback: (product) {
      //   //   if (product != null) {
      //   //     // if ((e.onhandQuantity ?? 0) > 0) {
      //   //     addItemToList(product);
      //   //     // } else {
      //   //     //   CommonUtils.showSnackBar(
      //   //     //     message: 'Stock out',
      //   //     //   );
      //   //     // }
      //   //   }
      //   // });
      // }
    }
    // else if (event is RawKeyUpEvent &&
    //     !(event.logicalKey.keyLabel == "1" ||
    //         event.logicalKey.keyLabel == "2" ||
    //         event.logicalKey.keyLabel == "3" ||
    //         event.logicalKey.keyLabel == "4" ||
    //         event.logicalKey.keyLabel == "5" ||
    //         event.logicalKey.keyLabel == "6" ||
    //         event.logicalKey.keyLabel == "7" ||
    //         event.logicalKey.keyLabel == "8" ||
    //         event.logicalKey.keyLabel == "9" ||
    //         event.logicalKey.keyLabel == "0" ||
    //         event.logicalKey.keyLabel == ".")) {
    //   if (event.logicalKey.keyLabel.length >= 3) {
    //     // BarcodeKeyboardListener.onKey(event, (){});
    //     log('Key event: ${event.logicalKey}');
    //     log('Key event: ${event.logicalKey}');
    //     log('Key event label: ${event.logicalKey.keyLabel}');
    //     itemListController.filterValue = event.logicalKey.keyLabel;
    //     itemListController.searchProduct(callback: (product) {
    //       if (product != null) {
    //         // if ((e.onhandQuantity ?? 0) > 0) {
    //         addItemToList(product);
    //         // } else {
    //         //   CommonUtils.showSnackBar(
    //         //     message: 'Stock out',
    //         //   );
    //         // }
    //       }
    //     });
    //   }
    // }
  }

  final FocusNode productTextFieldFocusNode = FocusNode();

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
