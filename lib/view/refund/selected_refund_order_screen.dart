import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class SelectedRefundOrderScreen extends StatefulWidget {
  const SelectedRefundOrderScreen({super.key});
  static const String routeName = "/selected_refund_order_screen";

  @override
  State<SelectedRefundOrderScreen> createState() =>
      _SelectedRefundOrderScreenState();
}

class _SelectedRefundOrderScreenState extends State<SelectedRefundOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              BorderContainer(
                text: 'Back',
                width: 140,
                borderWithPrimaryColor: true,
                textColor: Colors.white,
                containerColor: primaryColor,
                onTap: () {
                  Navigator.pop(context);
                  context.read<RefundOrderController>().selectedOrderList = [];
                },
              ),
              Expanded(
                child: SizedBox(),
              ),
              BorderContainer(
                text: 'Refund',
                width: 140,
                borderWithPrimaryColor: true,
                textColor: Colors.white,
                containerColor: primaryColor,
                onTap: () async {
                  CurrentOrderController currentOrderController =
                      context.read<CurrentOrderController>();
                  RefundOrderController refundOrderController =
                      context.read<RefundOrderController>();
                  currentOrderController.resetCurrentOrderController();
                  await CommonUtils.createOrderHistory(
                      NavigationService.navigatorKey.currentContext!);
                  currentOrderController.currentOrderList =
                      refundOrderController.selectedOrderList;
                  currentOrderController.selectedCustomer =
                      refundOrderController.selectedCustomer;
                  currentOrderController.isRefund = true;
                  if (mounted) {
                    CommonUtils.uploadOrderHistoryToDatabase(context,
                        isNavigate: true);
                    refundOrderController.orderId =
                        currentOrderController.orderHistory?.id;
                  }
                },
              ),
              // Expanded(
              //   flex: 3,
              //   child: SizedBox(),
              // )
            ],
          ),
          SizedBox(height: 20),
          _selectedRefundOrderListWidget(context),
          _totalWidget(context),
        ],
      ),
    );
  }

  Widget _selectedRefundOrderListWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    double padding = 1.8;
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
            ...controller.selectedOrderList
                .asMap()
                .map(
                  (i, e) => MapEntry(
                    i,
                    Column(
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
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "${e.onhandQuantity ?? 0} Unit at ${e.priceListItem?.fixedPrice?.toString() ?? "0"} Ks/Unit "
                                        "with a ${e.discount ?? 0.00} % discount"),
                                  ),
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
                  ),
                )
                .values
                .toList(),
          ],
        );
      }),
    );
  }

  Widget _totalWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    double padding = 1.8;
    return Consumer<RefundOrderController>(builder: (_, controller, __) {
      Map<String, double> map =
          controller.getTotalQty(controller.selectedOrderList);
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
                    "Total Item : ${controller.selectedOrderList.length} | Total Qty : ${map["qty"] ?? 0}"),
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
}
