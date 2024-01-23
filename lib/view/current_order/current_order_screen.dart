import 'dart:math';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/order_line_id_table.dart';
import 'package:offline_pos/model/order_line_id.dart';
import 'package:sqflite/sqflite.dart';

class CurrentOrderScreen extends StatefulWidget {
  const CurrentOrderScreen({super.key, required this.width});
  final double width;

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  bool isTabletMode = false;
  final FocusNode _textNode = FocusNode();

  @override
  void dispose() {
    _textNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isTabletMode = CommonUtils.isTabletMode(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (context.watch<CurrentOrderController>().currentOrderList.isEmpty)
            ? Expanded(
                // flex: 2,
                child: _noOrderWidget(),
              )
            : Expanded(
                // flex: 2,
                child: _currentOrderListWidget(),
              ),
        _keyboardAndSummaryWidget(),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _keyboardAndSummaryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        (context.watch<CurrentOrderController>().currentOrderList.isNotEmpty)
            ? _totalWidget()
            : SizedBox(),
        Align(
            alignment: Alignment.bottomCenter,
            child: Consumer<ViewController>(builder: (_, controller, __) {
              return Consumer<CurrentOrderController>(
                  builder: (_, currentOrderController, __) {
                return _orderCalculatorWidget(context, currentOrderController);
              });
            })),
      ],
    );
  }

  Widget _currentOrderListWidget() {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    return SingleChildScrollView(
      child: Consumer<CurrentOrderController>(builder: (_, controller, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...controller.currentOrderList
                .asMap()
                .map(
                  (i, e) => MapEntry(
                    i,
                    InkWell(
                      onTap: () {
                        _textNode.requestFocus();
                        controller.selectedIndex = i;
                        // _addManualDiscountProduct(controller);
                      },
                      child: RawKeyboardListener(
                        focusNode: _textNode,
                        onKey: (event) {
                          _handleKeyEvent(event, controller);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: isTabletMode ? 70 : 100,
                              width: isTabletMode
                                  ? widget.width - 16
                                  : widget.width,
                              margin: isTabletMode ? EdgeInsets.all(8) : null,
                              decoration: BoxDecoration(
                                color: controller.selectedIndex == i
                                    ? primaryColor.withOpacity(0.13)
                                    : Constants.currentOrderDividerColor,
                                borderRadius: isTabletMode
                                    ? BorderRadius.circular(20)
                                    : null,
                              ),
                              child: Center(
                                child: ListTile(
                                  dense: true,
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(text: "", children: [
                                            TextSpan(
                                              text: "[${e.productId}]",
                                              style: textStyle.copyWith(
                                                  color:
                                                      Constants.successColor),
                                            ),
                                            TextSpan(
                                                text: e.productName,
                                                style: textStyle),
                                          ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          ProductUntiDialog.productUnitWidget(
                                              context,
                                              product: e);
                                        },
                                        child: Text(
                                            "${(e.priceListItem?.fixedPrice ?? 0) * max(e.onhandQuantity ?? 0, 1)} Ks"
                                                .toString(), // product.salePrice
                                            style: textStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                            )),
                                      )
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "${e.onhandQuantity ?? 0} Unit at ${e.priceListItem?.fixedPrice?.toString() ?? "0"} Ks/Unit with a 0.00 % discount"),
                                      ),
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: primaryColor),
                                        child: Center(
                                          child: Text(
                                            "%",
                                            style: TextStyle(
                                              color: Constants.accentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Divider(
                                thickness: 0.6,
                                height: 6,
                                color: Constants.disableColor.withOpacity(0.96),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .values
                .toList(),
          ],
        );
      }),
    );
  }

  void _handleKeyEvent(RawKeyEvent event, CurrentOrderController controller) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        _updateCurrentOrder(controller, "", isBack: true);
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
        _updateCurrentOrder(controller, event.logicalKey.keyLabel);
      }
    }
  }

  Widget _totalWidget() {
    return Consumer<CurrentOrderController>(builder: (_, controller, __) {
      List list = controller.getTotalQty(controller.currentOrderList);
      return Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 0.6,
              height: 6,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Total Item : ${controller.currentOrderList.length} | Total Qty : ${list.first}"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total : ${list.last} Ks",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Taxes : 150 Ks",
                      style: TextStyle(
                        color: Constants.greyColor2,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _noOrderWidget() {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonUtils.svgIconActionButton("assets/svg/no_order.svg",
              height: 60,
              onPressed: null,
              iconColor: Constants.disableColor.withOpacity(
                0.77,
              )),
          Center(
            child: Text(
              'This Order is Empty',
              style: TextStyle(
                color: Constants.disableColor.withOpacity(
                  0.87,
                ),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCalculatorWidget(
      BuildContext context, CurrentOrderController currentOrderController) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    List<Widget> list = [];
    List<Widget> rowList = [];
    int itemCount = isTabletMode ? 10 : 5;

    List<Widget> calculatorActionWidgetList = [
      CommonUtils.eachCalculateButtonWidget(
        text: "1",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "1");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "2",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "2");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "3",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "3");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "Qty",
        containerColor: currentOrderController.currentOrderKeyboardState ==
                CurrentOrderKeyboardState.qty
            ? primaryColor.withOpacity(0.3)
            : null,
        onPressed: () {
          currentOrderController.currentOrderKeyboardState =
              CurrentOrderKeyboardState.qty;
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        icon: context.watch<ViewController>().isKeyboardHide
            ? Icons.keyboard_arrow_up_rounded
            : Icons.keyboard_arrow_down_rounded,
        iconSize: 32,
        onPressed: () {
          context.read<ViewController>().isKeyboardHide =
              !context.read<ViewController>().isKeyboardHide;
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "4",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "4");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "5",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "5");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "6",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "6");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        containerColor: currentOrderController.currentOrderKeyboardState ==
                CurrentOrderKeyboardState.disc
            ? primaryColor.withOpacity(0.3)
            : null,
        text: "Disc",
        onPressed: () {
          currentOrderController.currentOrderKeyboardState =
              CurrentOrderKeyboardState.disc;
          // _addManualDiscountProduct(currentOrderController);
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "Price",
        containerColor: currentOrderController.currentOrderKeyboardState ==
                CurrentOrderKeyboardState.price
            ? primaryColor.withOpacity(0.3)
            : null,
        onPressed: () {
          currentOrderController.currentOrderKeyboardState =
              CurrentOrderKeyboardState.price;
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "7",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "7");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "8",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "8");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "9",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "9");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "+/-",
        containerColor: currentOrderController.currentOrderKeyboardState ==
                CurrentOrderKeyboardState.refund
            ? primaryColor.withOpacity(0.3)
            : null,
        onPressed: () {
          currentOrderController.currentOrderKeyboardState =
              CurrentOrderKeyboardState.refund;
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        icon: Icons.arrow_forward_ios,
        iconSize: 21,
        onPressed: () {
          if (context.read<CurrentOrderController>().currentOrderList.isEmpty) {
            CommonUtils.showSnackBar(message: 'There is no order items.');
            return;
          }
          context.read<CurrentOrderController>().isContainCustomer = false;
          uploadOrderHistoryToDatabase();
          Navigator.pushNamed(context, OrderPaymentScreen.routeName);
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: ".",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, ".");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "0",
        onPressed: () {
          _updateCurrentOrder(currentOrderController, "0");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
          icon: Icons.backspace_outlined,
          iconColor: Constants.alertColor,
          onPressed: () {
            _updateCurrentOrder(currentOrderController, "", isBack: true);
          }),
      CommonUtils.eachCalculateButtonWidget(
        text: "Customer",
        containerColor: primaryColor,
        textColor: Colors.white,
        width: 100,
        onPressed: () async {
          context.read<ViewController>().isCustomerView = true;
          CustomerListDialog.customerListDialogWidget(context).then((value) {
            context.read<ViewController>().isCustomerView = false;
          });
        },
      ),
    ];

    for (var i = 0; i < calculatorActionWidgetList.length; i += (itemCount)) {
      int start = (list.length * (itemCount));
      int end = (itemCount) + (list.length * (itemCount));
      rowList.addAll(calculatorActionWidgetList.getRange(
          start, min(end, calculatorActionWidgetList.length)));
      list.add(SizedBox(
        width: isTabletMode
            ? (MediaQuery.of(context).size.width / 10) * 9
            : MediaQuery.of(context).size.width -
                (MediaQuery.of(context).size.width / 5.5) -
                ((MediaQuery.of(context).size.width / 5.3) * 3),
        child: Row(
          children: List.generate(
            rowList.length,
            (index) => Expanded(
              flex: rowList.length == (itemCount)
                  ? 1
                  : index == (rowList.length - 1)
                      ? 2
                      : 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (isTabletMode ? 4 : 8.0),
                  vertical: (isTabletMode ? 1.2 : 3),
                ),
                child: rowList[index],
              ),
            ),
          ),
        ),
      ));
      rowList = [];
      if (context.read<ViewController>().isKeyboardHide) {
        break;
      }
    }

    return Column(
      children: list,
    );
  }

  void _updateCurrentOrder(
    CurrentOrderController currentOrderController,
    String value, {
    bool? isBack,
  }) {
    if (currentOrderController.selectedIndex != null) {
      Product product = currentOrderController.currentOrderList
          .elementAt(currentOrderController.selectedIndex!);
      product.priceListItem ??= PriceListItem();
      if (currentOrderController.currentOrderKeyboardState ==
          CurrentOrderKeyboardState.price) {
        String price = product.priceListItem!.fixedPrice?.toString() ?? "";
        if (isBack == true) {
          price = price.substring(0, price.length - 1);
        } else {
          price += value;
        }
        product.priceListItem?.fixedPrice = double.tryParse(price);
        currentOrderController.notify();
      } else if (currentOrderController.currentOrderKeyboardState ==
          CurrentOrderKeyboardState.qty) {
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
          qty = (qty != "1" ? qty : "");
          qty += value;
        }
        if (isDelete) {
          currentOrderController.currentOrderList
              .removeAt(currentOrderController.selectedIndex!);
          currentOrderController.selectedIndex = null;
        } else {
          product.onhandQuantity = double.tryParse(qty);
        }
        currentOrderController.notify();
      }
      // else if (currentOrderController.currentOrderKeyboardState ==
      //     CurrentOrderKeyboardState.disc) {
      //   Product promotionProduct = product.cloneProduct();
      //   promotionProduct.onhandQuantity = 1;
      //   promotionProduct.priceListItem?.fixedPrice = 0;
      //   currentOrderController.currentOrderList.insert(
      //       currentOrderController.selectedIndex! + 1, promotionProduct);
      //   currentOrderController.notify();
      // }
    }
  }

  void _addManualDiscountProduct(
      CurrentOrderController currentOrderController) {
    if (currentOrderController.selectedIndex != null &&
        currentOrderController.currentOrderKeyboardState ==
            CurrentOrderKeyboardState.disc) {
      Product product = currentOrderController.currentOrderList
          .elementAt(currentOrderController.selectedIndex!);
      product.priceListItem ??= PriceListItem();
      Product promotionProduct = product.cloneProduct();
      promotionProduct.onhandQuantity = 1;
      promotionProduct.priceListItem?.fixedPrice = 0;
      currentOrderController.currentOrderList
          .insert(currentOrderController.selectedIndex! + 1, promotionProduct);
      currentOrderController.notify();
    }
  }

  Future<void> uploadOrderHistoryToDatabase() async {
    CurrentOrderController currentOrderController =
        context.read<CurrentOrderController>();
    DateTime orderDate = DateTime.now().toUtc();
    OrderHistory orderHistory = currentOrderController.orderHistory ??
        OrderHistory(
          dateOrder: orderDate.toString(),
          createDate: orderDate.toString(),
          createUid:
              context.read<LoginUserController>().loginUser?.userData?.id ?? 0,
          partnerId:
              context.read<LoginUserController>().loginUser?.partnerData?.id ??
                  0,
          employeeId:
              context.read<LoginUserController>().loginUser?.employeeData?.id ??
                  0,
          configId: context.read<LoginUserController>().posConfig?.id ?? 0,
          sessionId: context.read<LoginUserController>().posSession?.id ?? 0,
          sequenceNumber: orderDate.microsecond.toString(),
          amountTotal: currentOrderController
              .getTotalQty(currentOrderController.currentOrderList)
              .last,
          name:
              "${context.read<LoginUserController>().posConfig?.name}/ ${orderDate.microsecond}",
        );
    final Database db = await DatabaseHelper().db;
    OrderHistoryTable.insertOrUpdate(db, orderHistory).then((value) {
      orderHistory.id = value;
      currentOrderController.orderHistory = orderHistory;
      List<OrderLineID> orderLineIdList = [];
      OrderLineIdTable.deleteByOrderId(db, value);
      for (var data in currentOrderController.currentOrderList) {
        if ((data.onhandQuantity ?? 0) <= 0) {
          CommonUtils.showSnackBar(
              message: '${data.productName} is something wrong!');
        }

        OrderLineID orderLineID = OrderLineID(
          orderId: value,
          productId: data.productId,
          qty: data.onhandQuantity!,
          priceUnit: (data.priceListItem?.fixedPrice ?? 0) * 0.05,
          priceSubtotal: (data.priceListItem?.fixedPrice ?? 0) * 0.05,
          priceSubtotalIncl: (data.priceListItem?.fixedPrice ?? 0),
        );
        orderLineIdList.add(orderLineID);
      }
      OrderLineIdTable.insertOrUpdate(orderLineIdList).then((lineValue) async {
        OrderLineIdTable.getOrderLinesByOrderId(value).then((lineIds) =>
            currentOrderController.orderHistory?.lineIds = lineIds);
      });
    });
  }
}
