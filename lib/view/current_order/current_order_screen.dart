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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (context.watch<CurrentOrderController>().currentOrderList.isEmpty)
            ? Expanded(
                child: _noOrderWidget(),
              )
            : Expanded(
                child: _currentOrderListWidget(),
              ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (context
                    .watch<CurrentOrderController>()
                    .currentOrderList
                    .isNotEmpty)
                ? _totalWidget()
                : SizedBox(),
            CommonUtils.orderCalculatorWidget(context),
          ],
        )),
        isTabletMode ? Expanded(child: SizedBox()) : SizedBox(height: 8),
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
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: isTabletMode ? 80 : 100,
                            width: isTabletMode ? (_width ?? 100) - 16 : _width,
                            margin: isTabletMode ? EdgeInsets.all(8) : null,
                            decoration: BoxDecoration(
                              color: Constants.currentOrderDividerColor,
                              borderRadius: isTabletMode
                                  ? BorderRadius.circular(20)
                                  : null,
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
                                              text: e["name"],
                                              style: textStyle),
                                        ]),
                                      ),
                                    ),
                                    Text("${e["price"]} Ks".toString(),
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Constants.primaryColor,
                                        ))
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
}
