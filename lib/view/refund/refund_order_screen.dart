import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class RefundOrderScreen extends StatefulWidget {
  const RefundOrderScreen({super.key});
  static const String routeName = "/refund_order_screen";

  @override
  State<RefundOrderScreen> createState() => _RefundOrderScreenState();
}

class _RefundOrderScreenState extends State<RefundOrderScreen> {
  bool isTabletMode = false;
  double padding = 1.8;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    isTabletMode = CommonUtils.isTabletMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4),
      child: Column(
        children: [
          _currentOrderListWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (context
                      .watch<RefundOrderController>()
                      .currentOrderList
                      .isNotEmpty)
                  ? _totalWidget()
                  : SizedBox(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Consumer<ViewController>(builder: (_, controller, __) {
                    return Consumer<RefundOrderController>(
                        builder: (_, refundOrderController, __) {
                      return _orderCalculatorWidget(
                          context, refundOrderController);
                    });
                  })),
            ],
          )
        ],
      ),
    );
  }

  Widget _currentOrderListWidget() {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    return SingleChildScrollView(
      child: Consumer<RefundOrderController>(builder: (_, controller, __) {
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
                        if (controller.selectedIndex == i) {
                          controller.selectedIndex = -1;
                        } else {
                          controller.selectedIndex = i;
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: isTabletMode ? 70 : 100,
                            width: isTabletMode
                                ? (MediaQuery.of(context).size.width / padding)
                                : MediaQuery.of(context).size.width,
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
                                            text: e.barcode != null
                                                ? " [${e.barcode}]"
                                                : "",
                                            style: textStyle.copyWith(
                                                color: Constants.successColor),
                                          ),
                                          TextSpan(
                                              text: e.productName,
                                              style: textStyle),
                                        ]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                          "${((e.priceListItem?.fixedPrice ?? 0) * max(e.onhandQuantity ?? 0, 1)) - (((e.priceListItem?.fixedPrice ?? 0) * max(e.onhandQuantity ?? 0, 1)) * ((e.discount ?? 0) / 100))} Ks"
                                              .toString(), // product.salePrice
                                          style: textStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          )),
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "${e.onhandQuantity ?? 0} Unit at ${e.priceListItem?.fixedPrice?.toString() ?? "0"} Ks/Unit "
                                              "with a ${e.discount ?? 0.00} % discount"),
                                        ),
                                        // Container(
                                        //   width: 35,
                                        //   height: 35,
                                        //   decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(20),
                                        //       color: primaryColor),
                                        //   child: Center(
                                        //     child: Text(
                                        //       "%",
                                        //       style: TextStyle(
                                        //         color: Constants.accentColor,
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 16,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Text(
                                      'To Refund : ${e.refundQuantity ?? 0}',
                                      style: textStyle.copyWith(
                                          color: Constants.successColor),
                                    ),
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
                      // ),
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

  Widget _totalWidget() {
    return Consumer<RefundOrderController>(builder: (_, controller, __) {
      Map<String, double> map =
          controller.getTotalQty(controller.currentOrderList);
      return Container(
        width: isTabletMode
            ? (MediaQuery.of(context).size.width / padding)
            : MediaQuery.of(context).size.width,
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
                    "Total Item : ${controller.currentOrderList.length} | Total Qty : ${map["qty"] ?? 0}"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total : ${map["total"] ?? 0} Ks",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Taxes : ${map["tax"] ?? 0} Ks",
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

  Widget _orderCalculatorWidget(
      BuildContext context, RefundOrderController refundOrderController) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    List<Widget> list = [];
    List<Widget> rowList = [];
    int itemCount = isTabletMode ? 9 : 4;

    List<Widget> calculatorActionWidgetList = [
      CommonUtils.eachCalculateButtonWidget(
        text: "1",
        onPressed: () {
          refundOrderController.updateCurrentOrder("1");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "2",
        onPressed: () {
          refundOrderController.updateCurrentOrder("2");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "3",
        onPressed: () {
          refundOrderController.updateCurrentOrder("3");
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
          refundOrderController.updateCurrentOrder("4");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "5",
        onPressed: () {
          refundOrderController.updateCurrentOrder("5");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "6",
        onPressed: () {
          refundOrderController.updateCurrentOrder("6");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "7",
        onPressed: () {
          refundOrderController.updateCurrentOrder("7");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "8",
        onPressed: () {
          refundOrderController.updateCurrentOrder("8");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "9",
        onPressed: () {
          refundOrderController.updateCurrentOrder("9");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "0",
        onPressed: () {
          refundOrderController.updateCurrentOrder("0");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        icon: Icons.arrow_forward_ios,
        iconSize: 21,
        onPressed: () {
          if (context.read<RefundOrderController>().currentOrderList.isEmpty) {
            CommonUtils.showSnackBar(
                context: context, message: 'There is no order items.');
            return;
          }
          // todo :
          // CommonUtils.uploadOrderHistoryToDatabase(context);
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: ".",
        onPressed: () {
          refundOrderController.updateCurrentOrder(".");
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
          icon: Icons.backspace_outlined,
          iconColor: Constants.alertColor,
          onPressed: () {
            refundOrderController.updateCurrentOrder("", isBack: true);
          }),
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
}
