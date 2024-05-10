import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/discount_table.dart';

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

  // List<Promotion> _promotionList = [];
  // List<Promotion> get promotionList => _promotionList;

  // set promotionList(List<Promotion> promotionList) {
  //   _promotionList = promotionList;
  //   notifyListeners();
  // }

  notify() {
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

  List<Discount> _discountList = [];
  List<Discount> get discountList => _discountList;
  set discountList(List<Discount> discountList) {
    _discountList = discountList;
    notifyListeners();
  }

  int _selectedDiscountIndex = 0;
  int get selectedDiscountIndex => _selectedDiscountIndex;
  set selectedDiscountIndex(int selectedDiscountIndex) {
    if (_selectedDiscountIndex == selectedDiscountIndex) return;
    _selectedDiscountIndex = selectedDiscountIndex;
    notifyListeners();
  }

  bool _isRefund = false;
  bool get isRefund => _isRefund;
  set isRefund(bool isRefund) {
    if (_isRefund == isRefund) return;
    _isRefund = isRefund;
    notifyListeners();
  }

  Future<void> addItemToList(
    Product product, {
    ProductPackaging? productPackaging,
  }) async {
    if (product.productType == "product" &&
        (product.onhandQuantity ?? 0) <= 0) {
      try {
        CommonUtils.showSnackBar(
          message: '${product.productName} is not remained stock.',
        );
      } catch (_) {}
    }
    int? sessionId;
    if (NavigationService.navigatorKey.currentContext != null) {
      sessionId = NavigationService.navigatorKey.currentContext!
              .read<LoginUserController>()
              .posSession
              ?.id ??
          0;
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
      currentOrderList[index].onhandQuantity =
          (currentOrderList[index].onhandQuantity ?? 0) + 1;
      orderProduct = currentOrderList[index];
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

      // to check promotion
      List<Promotion> promotionList =
          await PromotionTable.getPromotionByProductId(
              orderProduct.productId ?? 0, sessionId ?? 0);
      orderProduct.promotionList = promotionList;

      currentOrderList.add(orderProduct);
      // selectedIndex = currentOrderList.length - 1;
    }

    // promotion product
    if (orderProduct.promotionList?.isNotEmpty ?? false) {
      removePromotionItemsByProduct(orderProduct);
      List<Product> promoProductList = checkAndSetUpPromotion(orderProduct);
      if (index >= 0) {
        int position = index;
        // promoProductList.map((e) => currentOrderList.insert(position++, e));
        for (Product pro in promoProductList) {
          currentOrderList.insert(++position, pro);
        }
        notifyListeners();
      } else {
        currentOrderList.addAll(promoProductList);
      }
    }

    notifyListeners();
    if (kIsWeb || Platform.isWindows) {
      productTextFieldFocusNode.requestFocus();
    }
    PendingOrderTable.insertOrUpdateCurrentOrderListWithDB(
      productList: jsonEncode(currentOrderList),
    );
  }

  void removePromotionItemsByProduct(Product orderProduct) {
    Promotion? promotion = orderProduct.validPromotion ??
        orderProduct.promotionList?.firstWhere(
          (e) {
            return (orderProduct.onhandQuantity ?? 0) >=
                (e.promotionRule?.ruleMinQuantity ?? 0);
          },
          orElse: () => Promotion(),
        );
    currentOrderList.removeWhere((element) {
      return element.isPromoItem == true &&
          element.parentPromotionId == promotion?.id;
    });
    notifyListeners();
  }

  List<Product> checkAndSetUpPromotion(Product? orderProduct) {
    if (orderProduct == null ||
        orderProduct.isPromoItem == true ||
        (orderProduct.onhandQuantity ?? 0) <= 0) {
      return [];
    }

    Promotion? promotion = orderProduct.promotionList?.firstWhere((e) {
      return (orderProduct.onhandQuantity ?? 0) >=
          (e.promotionRule?.ruleMinQuantity ?? 0);
    }, orElse: () => Promotion());
    orderProduct.validPromotion = promotion;
    Product? promoProduct =
        promotion != null && promotion.id != null && promotion.id != 0
            ? Product.fromJson(jsonDecode(jsonEncode(orderProduct)),
                includedOtherField: true)
            : null;
    if (promoProduct != null &&
        promotion != null &&
        promotion.id != null &&
        promotion.id != 0) {
      promoProduct.parentPromotionId = promotion.id;
      promoProduct.isPromoItem = true;

      if (promotion.discountApplyOn == "on_order") {
        promoProduct.onOrderPromo = true;
      }
      return calculatePromotion(promoProduct, promotion);
    }
    return [];
  }

  List<Product> calculatePromotion(Product promoProduct, Promotion promotion) {
    List<Product> promoProductList = [];
    if (promotion.rewardType == 'product') {
      promoProductList = _rewardSpecificProductPromotion(
          promotion, promoProductList, promoProduct);
    } else {
      promoProductList =
          _rewardDiscountPromotion(promotion, promoProductList, promoProduct);
    }
    return promoProductList;
  }

  List<Product> _rewardSpecificProductPromotion(Promotion promotion,
      List<Product> promoProductList, Product promoProduct) {
    List<Product> promoProductList = [];
    if (promotion.freeProduct != null &&
        promotion.freeProduct!.productId != null) {
      promotion.freeProduct!.onhandQuantity =
          (((promotion.rewardProductQuantity ?? 1) /
                      (promotion.promotionRule?.ruleMinQuantity ?? 1)) *
                  (promoProduct.onhandQuantity ?? 1))
              .toInt();
      promotion.freeProduct!.parentPromotionId = promoProduct.parentPromotionId;
      promotion.freeProduct!.isPromoItem = true;
      promoProductList.add(promotion.freeProduct!);

      if (promotion.rewardProduct != null &&
          promotion.rewardProduct!.productId != null) {
        Product free = promotion.rewardProduct!;
        free.priceListItem = PriceListItem.fromJson(
            jsonDecode(jsonEncode(promotion.freeProduct!.priceListItem)));
        free.priceListItem?.fixedPrice = -(free.priceListItem?.fixedPrice ?? 0);
        free.onhandQuantity = (((promotion.rewardProductQuantity ?? 1) /
                    (promotion.promotionRule?.ruleMinQuantity ?? 1)) *
                (promoProduct.onhandQuantity ?? 1))
            .toInt();
        free.parentPromotionId = promoProduct.parentPromotionId;
        free.isPromoItem = true;
        promoProductList.add(free);
      }
    }
    return promoProductList;
  }

  List<Product> _rewardDiscountPromotion(Promotion promotion,
      List<Product> promoProductList, Product promoProduct) {
    List<Product> promoProductList = [];
    if (promotion.discountType == 'percentage') {
      // if (promotion.discountSpecificProducts?.isNotEmpty ?? false) {
      if (promotion.discountApplyOn == 'on_order') {
        Product? existingProduct = currentOrderList.firstWhere((e) {
          return e.parentPromotionId == promoProduct.parentPromotionId;
        }, orElse: () => Product());

        if (existingProduct.productId == null ||
            existingProduct.productId == 0) {
          if (promotion.rewardProduct != null) {
            Product product = promotion.rewardProduct!;
            if ((promotion.discountMaxAmount ?? 0) > 0) {
              Map<String, double> totalMap =
                  getTotalQty(currentOrderList); // to ask included promo or not
              if ((totalMap["total"]! *
                      ((promotion.discountPercentage ?? 0) / 100)) >
                  promotion.discountMaxAmount!) {
                product.priceListItem?.fixedPrice = -promotion
                    .discountMaxAmount!; // to ask how about amount tax
                product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
                product.parentPromotionId = promoProduct.parentPromotionId;
                product.isPromoItem = true;
                promoProductList.add(product);
              } else {
                product.priceListItem?.fixedPrice = -(totalMap["total"]! *
                        ((promotion.discountPercentage ?? 0) / 100))
                    .toInt();
                product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
                product.parentPromotionId = promoProduct.parentPromotionId;
                product.isPromoItem = true;
                promoProductList.add(product);
              }
            } else if ((promotion.discountPercentage ?? 0) > 0) {
              Map<String, double> totalMap =
                  getTotalQty(currentOrderList); // to ask included promo or not
              product.priceListItem?.fixedPrice = -(totalMap["total"]! *
                      ((promotion.discountPercentage ?? 0) / 100))
                  .toInt();
              product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
              product.parentPromotionId = promoProduct.parentPromotionId;
              product.isPromoItem = true;
              promoProductList.add(product);
            }
          }
        }
      } else {
        // promotion
        if (promotion.rewardProduct != null) {
          Product product = promotion.rewardProduct!;
          if ((promotion.discountMaxAmount ?? 0) > 0) {
            if (((promoProduct.priceListItem?.fixedPrice ?? 0) *
                    ((promotion.discountPercentage ?? 0) / 100)) >
                promotion.discountMaxAmount!) {
              product.priceListItem?.fixedPrice =
                  -promotion.discountMaxAmount!; // to ask how about amount tax
              product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
              product.parentPromotionId = promoProduct.parentPromotionId;
              product.isPromoItem = true;
              promoProductList.add(product);
            } else {
              product.priceListItem?.fixedPrice =
                  -((promoProduct.priceListItem?.fixedPrice ?? 0) *
                          ((promotion.discountPercentage ?? 0) / 100))
                      .toInt();
              product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
              product.parentPromotionId = promoProduct.parentPromotionId;
              product.isPromoItem = true;
              promoProductList.add(product);
            }
          } else if ((promotion.discountPercentage ?? 0) > 0) {
            product.priceListItem?.fixedPrice =
                ((promoProduct.priceListItem?.fixedPrice ?? 0) *
                        (promotion.discountPercentage! / 100))
                    .toInt();
            product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
            product.parentPromotionId = promoProduct.parentPromotionId;
            product.isPromoItem = true;
            promoProductList.add(product);
          }
        }
      }
      // } else {}
    } else if (promotion.rewardProduct != null) {
      Product product = promotion.rewardProduct!;
      if ((promotion.discountFixedAmount ?? 0) > 0) {
        if (promotion.discountApplyOn == 'specific_products') {
          product.priceListItem?.fixedPrice =
              -promotion.discountFixedAmount!; // to ask how about amount tax
          product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
          product.parentPromotionId = promoProduct.parentPromotionId;
          product.isPromoItem = true;
          promoProductList.add(product);
        } else if (promotion.discountApplyOn == 'on_order') {
          Product? existingProduct = currentOrderList.firstWhere((e) {
            return e.parentPromotionId == promoProduct.parentPromotionId;
          }, orElse: () => Product());

          if (existingProduct.productId == null ||
              existingProduct.productId == 0) {
            product.priceListItem?.fixedPrice =
                -promotion.discountFixedAmount!; // to ask how about amount tax
            product.onhandQuantity = 1; //promoProduct.onhandQuantity ?? 1;
            product.parentPromotionId = promoProduct.parentPromotionId;
            product.isPromoItem = true;
            promoProductList.add(product);
          }
        }
      }
    }

    return promoProductList;
  }

  // Future<void> updateCurrentOrderByPromotion() async{
  //   // to update current order
  // }

  Future<void> updateCurrentOrder(
    String value, {
    bool? isBack,
    Discount? discount,
    String? shDiscountReason,
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
          if (kIsWeb || Platform.isWindows) {
            productTextFieldFocusNode.requestFocus();
          }
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
        if (product.promotionList?.isNotEmpty ?? false) {
          removePromotionItemsByProduct(product);
          List<Product> promoProductList = checkAndSetUpPromotion(
              currentOrderList.contains(product) ? product : null);
          currentOrderList.addAll(promoProductList);
        }
        notifyListeners();
      } else if (currentOrderKeyboardState == CurrentOrderKeyboardState.disc &&
          discount != null) {
        product.discount = discount.shDiscountValue;
        product.shDiscountCode = discount.shDiscountCode;
        product.shDiscountReason = shDiscountReason;
        notifyListeners();
      }
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

  Future<void> getDiscountList() async {
    DiscountTable.getDiscountList().then((discountLis) {
      if (discountLis.isNotEmpty) {
        discountList = discountLis;
      }
    });
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
    _discountList = [];
    _selectedDiscountIndex = 0;
    _isRefund = false;
    notifyListeners();
  }
}
