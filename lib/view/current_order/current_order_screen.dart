import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class CurrentOrderScreen extends StatefulWidget {
  const CurrentOrderScreen({super.key, required this.width});
  final double width;

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  bool isTabletMode = false;

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
              return _orderCalculatorWidget(context);
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
                .map(
                  (e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: isTabletMode ? 70 : 100,
                        width: isTabletMode ? widget.width - 16 : widget.width,
                        margin: isTabletMode ? EdgeInsets.all(8) : null,
                        decoration: BoxDecoration(
                          color: Constants.currentOrderDividerColor,
                          borderRadius:
                              isTabletMode ? BorderRadius.circular(20) : null,
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
                                            color: Constants.successColor),
                                      ),
                                      TextSpan(
                                          text: e.productName,
                                          style: textStyle),
                                    ]),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    ProductUntiDialog.productUnitWidget(context,
                                        product: e);
                                  },
                                  child: Text(
                                      "${0} Ks".toString(), // product.salePrice
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
                                      "1 Unit at 900.00 Ks/Unit with a 0.00 % discount"),
                                ),
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
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
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Divider(
                          thickness: 0.6,
                          height: 6,
                          color: Constants.disableColor.withOpacity(0.96),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ],
        );
      }),
    );
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

  Widget _orderCalculatorWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    List<Widget> list = [];
    List<Widget> rowList = [];
    int itemCount = isTabletMode ? 10 : 5;

    List<Widget> calculatorActionWidgetList = [
      CommonUtils.eachCalculateButtonWidget(
        text: "1",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "2",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "3",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "Qty",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        icon: NavigationService.navigatorKey.currentContext != null &&
                NavigationService.navigatorKey.currentContext!
                    .watch<ViewController>()
                    .isKeyboardHide
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
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "5",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "6",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "Disc",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "Price",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "7",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "8",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "9",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "+/-",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        icon: Icons.arrow_forward_ios,
        iconSize: 21,
        onPressed: () {
          if (context.read<CurrentOrderController>().currentOrderList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              'There is no order items.',
              textAlign: TextAlign.center,
            )));
            return;
          }
          context.read<CurrentOrderController>().isContainCustomer = false;
          Navigator.pushNamed(context, OrderPaymentScreen.routeName);
        },
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: ".",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
        text: "0",
        onPressed: () {},
      ),
      CommonUtils.eachCalculateButtonWidget(
          icon: Icons.backspace_outlined,
          iconColor: Constants.alertColor,
          onPressed: () {}),
      CommonUtils.eachCalculateButtonWidget(
        text: "Customer",
        containerColor: primaryColor,
        textColor: Colors.white,
        width: 100,
        onPressed: () async {
          context.read<ViewController>().isCustomerView = true;
          CustomerListDialog.customerListDialogWidget(context).then((value) {
            if (NavigationService.navigatorKey.currentContext != null) {
              NavigationService.navigatorKey.currentContext!
                  .read<ViewController>()
                  .isCustomerView = false;
            }
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
}
