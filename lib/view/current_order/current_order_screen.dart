import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class CurrentOrderScreen extends StatefulWidget {
  const CurrentOrderScreen({super.key});

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  double? _width;
  bool isTabletMode = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      _width = isTabletMode
          ? (MediaQuery.of(context).size.width / 10) * 9
          : MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width / 5.5) -
              ((MediaQuery.of(context).size.width / 5.3) * 3);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
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
            if (!context.watch<ViewController>().isKeyboardHide)
              isTabletMode
                  ? _keyboardAndSummaryWidget()
                  : _keyboardAndSummaryWidget(),
            SizedBox(height: 8),
          ],
        ),
        InkWell(
            onTap: () {
              context.read<ViewController>().isKeyboardHide =
                  !context.read<ViewController>().isKeyboardHide;
            },
            child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.greyColor2.withOpacity(0.6),
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(context.watch<ViewController>().isKeyboardHide
                    ? Icons.arrow_forward_ios
                    : Icons.arrow_back_ios))),
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
            child: _orderCalculatorWidget(context)),
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
                .map((e) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: isTabletMode ? 70 : 100,
                          width: isTabletMode ? (_width ?? 100) - 16 : _width,
                          margin: isTabletMode ? EdgeInsets.all(8) : null,
                          decoration: BoxDecoration(
                            color: Constants.currentOrderDividerColor,
                            borderRadius:
                                isTabletMode ? BorderRadius.circular(20) : null,
                          ),
                          child: Center(
                            child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(text: "", children: [
                                        TextSpan(
                                          text: "[${e["id"]}]",
                                          style: textStyle.copyWith(
                                              color: Constants.successColor),
                                        ),
                                        TextSpan(
                                            text: e["name"], style: textStyle),
                                      ]),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ProductUntiDialog.productUnitWidget(
                                          context,
                                          object: e);
                                    },
                                    child: Text("${e["price"]} Ks".toString(),
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Constants.primaryColor,
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
                                        color: Constants.primaryColor),
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
                    ))
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
        width: _width,
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
                        color: Constants.primaryColor,
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
      width: _width,
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
  
  final List<Widget> _calculatorActionWidgetList = [
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
      icon: Icons.keyboard_arrow_down_rounded,
      iconSize: 32,
      onPressed: () {},
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
      onPressed: () {},
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
      containerColor: Constants.primaryColor,
      textColor: Colors.white,
      width: 100,
      onPressed: () {
        if (NavigationService.navigatorKey.currentContext != null) {
          NavigationService.navigatorKey.currentContext!
              .read<ViewController>()
              .isCustomerView = true;
          CustomerListDialog.customerListDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
    ),
  ];

  Widget _orderCalculatorWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    List<Widget> list = [];
    List<Widget> rowList = [];

    for (var i = 0;
        i < _calculatorActionWidgetList.length;
        i += (isTabletMode ? 10 : 5)) {
      int start = (list.length * (isTabletMode ? 10 : 5));
      int end =
          (isTabletMode ? 10 : 5) + (list.length * (isTabletMode ? 10 : 5));
      rowList.addAll(_calculatorActionWidgetList.getRange(
          start, min(end, _calculatorActionWidgetList.length)));
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
              flex: rowList.length == (isTabletMode ? 10 : 5)
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
    }

    return Column(
      children: list,
    );
  }
}
