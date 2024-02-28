import 'dart:convert';
import 'dart:math';

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
          (CommonUtils.getPercentAmountTaxOnProduct(cOrderList[i]) > 0
              ? ((cOrderList[i].priceListItem?.fixedPrice ?? 0) *
                  CommonUtils.getPercentAmountTaxOnProduct(cOrderList[i]))
              : 0);
      log(tTax);
    }
    map["qty"] = double.tryParse(tQty.toStringAsFixed(2)) ?? 0;
    map["total"] = double.tryParse(tTotal.toStringAsFixed(2)) ?? 0;
    map["tax"] = double.tryParse(tTax.toStringAsFixed(2)) ?? 0;
    return map;
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

  Future<void> addItemToList(Product product) async {
    if (product.productType == "product" &&
        (product.onhandQuantity ?? 0) <= 0) {
      CommonUtils.showSnackBar(
        message: '${product.productName} is not remained stock.',
      );
    }
    if (NavigationService.navigatorKey.currentContext != null) {
      if (NavigationService.navigatorKey.currentContext!
              .read<CurrentOrderController>()
              .orderHistory ==
          null) {
        await CommonUtils.createOrderHistory(
            NavigationService.navigatorKey.currentContext!);
      }
    }
    Product orderProduct = Product.fromJson(jsonDecode(jsonEncode(product)));
    PriceListItem? priceListItem = product.priceListItem != null
        ? PriceListItem.fromJson(jsonDecode(jsonEncode(product.priceListItem)))
        : null;
    orderProduct.priceListItem = priceListItem;
    AmountTax? amountTax = product.amountTax != null
        ? AmountTax.fromJson(jsonDecode(jsonEncode(product.amountTax)))
        : null;
    orderProduct.amountTax = amountTax;
    int index = currentOrderList
        .indexWhere((e) => e.productId == orderProduct.productId);
    if (index >= 0) {
      orderProduct.onhandQuantity =
          (currentOrderList[index].onhandQuantity ?? 0) + 1;
      currentOrderList[index] = orderProduct;
      if (product.productType == "product") {
        Product? orignalProduct =
            await ProductTable.getProductByProductId(product.productId ?? 0);
        if (orignalProduct != null &&
            ((orignalProduct.onhandQuantity ?? 0) -
                    (currentOrderList[index].onhandQuantity ?? 0) <=
                0)) {
          CommonUtils.showSnackBar(
            message:
                '${product.productName} remains only ${orignalProduct.onhandQuantity}.',
          );
        }
      }
    } else {
      orderProduct.firstTime = true;
      orderProduct.onhandQuantity = 1;
      currentOrderList.add(orderProduct);
    }
    notifyListeners();
    productTextFieldFocusNode.requestFocus();
  }

  Future<void> updateCurrentOrder(
    String value, {
    bool? isBack,
  }) async {
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
          if (product.onhandQuantity == 1) {
            isDelete = true;
            deletedProductLog.updatedQty = "0";
          } else {
            qty = qty.substring(0, qty.length - 1);
            if (qty.isEmpty) {
              qty = "1";
            }
            deletedProductLog.updatedQty = qty;
          }
          CommonUtils.saveDeletedItemLogs([deletedProductLog]);
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
          productTextFieldFocusNode.requestFocus();
        } else {
          product.onhandQuantity = int.tryParse(qty);
          if (product.productType == "product") {
            Product? orignalProduct = await ProductTable.getProductByProductId(
                product.productId ?? 0);
            if (orignalProduct != null &&
                ((orignalProduct.onhandQuantity ?? 0) -
                        (product.onhandQuantity ?? 0) <=
                    0)) {
              CommonUtils.showSnackBar(
                message:
                    '${product.productName} remains only ${orignalProduct.onhandQuantity}.',
              );
            }
          }
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

  bool _chooseCusFromCart = false;
  bool get chooseCusFromCart => _chooseCusFromCart;
  set chooseCusFromCart(bool chooseCusFromCart) {
    if (_chooseCusFromCart == chooseCusFromCart) return;
    _chooseCusFromCart = chooseCusFromCart;
    notifyListeners();
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
    _selectedCustomer = null;
    _selectingCustomer = null;
    _chooseCusFromCart = false;
    notifyListeners();
  }
}
