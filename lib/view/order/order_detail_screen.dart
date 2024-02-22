import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/controller/order_detail_controller.dart';
import 'package:offline_pos/model/order_line_id.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  static const String routeName = "/order_detail_screen";
  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Future<void> _getOrder() async {
    context.read<OrderDetailController>().orderHistory =
        await OrderHistoryTable.getOrderById(widget.orderId);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OrderDetailController>().resetOrderDetailController();
      _getOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 2,
          minWidth: (MediaQuery.of(context).size.width / 2) -
              MediaQuery.of(context).size.width / 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 30,
            ),
            child: BorderContainer(
              text: 'Back',
              width: 140,
              borderWithPrimaryColor: true,
              textColor: primaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Constants.greyColor2.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 30,
                  vertical: 10),
              padding: EdgeInsets.all(20),
              child: _childrenWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _childrenWidget() {
    var spacer = SizedBox(height: 10);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderWidget(),
        spacer,
        _headerOfLinesAndPayment(),
        Expanded(
            child: context.watch<OrderDetailController>().headerIndex == 0
                ? _productLinesWidget()
                : _paymentsWidget()),
      ],
    );
  }

  Widget _orderWidget() {
    var spacer = SizedBox(height: 8);
    return Consumer<OrderDetailController>(builder: (_, controller, __) {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Order Ref")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(
                          controller.orderHistory?.name ?? ''),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Session")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(
                          controller.orderHistory?.sessionName ?? ''),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Return Status")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo('Nothing Returned'),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(
                        child: _textForDetailInfoTitle("Is Exchanged Order")),
                    Expanded(
                      flex: 2,
                      child: CheckboxListTile(
                        value: false,
                        onChanged: null,
                        side: MaterialStateBorderSide.resolveWith(
                            (_) => BorderSide(width: 2, color: primaryColor)),
                        checkColor: primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Date")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(
                        CommonUtils.getLocaleDateTime(
                          "hh:mm:ss dd-MM-yyyy",
                          controller.orderHistory?.createDate,
                        ),
                      ),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Cashier")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(
                          controller.orderHistory?.employeeName ?? ''),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Customer")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(
                          controller.orderHistory?.partnerName ?? ''),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(
                        child: _textForDetailInfoTitle("Is Returned Order")),
                    Expanded(
                      flex: 2,
                      child: CheckboxListTile(
                        value: false,
                        onChanged: null,
                        side: MaterialStateBorderSide.resolveWith(
                            (_) => BorderSide(width: 2, color: primaryColor)),
                        checkColor: primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfoTitle("Order Condition")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(
                          controller.orderHistory?.orderCondition ?? ''),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _headerOfLinesAndPayment() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(
            minHeight: 50,
            maxHeight: 70,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _actionTitleList(context, 0).length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Center(
                  child: InkWell(
                onTap: () {
                  context.read<OrderDetailController>().headerIndex = index;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.greyColor2),
                    // borderRadius: BorderRadius.circular(4),
                    color: context.watch<OrderDetailController>().headerIndex ==
                            index
                        ? primaryColor
                        : null,
                  ),
                  child: _actionTitleList(context, index)[index],
                ),
              ));
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _actionTitleList(BuildContext context, int index) {
    return [
      _textForDetailInfo(
        'Products',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        textColor: context.watch<OrderDetailController>().headerIndex == 0
            ? Colors.white
            : null,
      ),
      _textForDetailInfo(
        'Payments',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        textColor: context.watch<OrderDetailController>().headerIndex == 1
            ? Colors.white
            : null,
      ),
    ];
  }

  Widget _productLinesWidget() {
    return Consumer<OrderDetailController>(builder: (_, controller, __) {
      double totalTaxes = 0;
      double totalPaidAmt = 0;
      for (OrderLineID orderLineID in controller.orderHistory?.lineIds ?? []) {
        totalTaxes += (orderLineID.priceSubtotalIncl ?? 0) -
            (orderLineID.priceSubtotal ?? 0);
        totalPaidAmt += (orderLineID.priceSubtotalIncl ?? 0);
      }
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20.0,
                      horizontalMargin: 20,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Constants.greyColor),
                      columns: [
                        DataColumn(label: _textForDetailInfoTitle('#Session')),
                        DataColumn(
                          label: SizedBox(
                            width: 300,
                            child: _textForDetailInfoTitle('Full Product Name'),
                          ),
                        ),
                        // DataColumn(
                        //     label: _textForDetailInfoTitle('Unit of measure')),
                        // DataColumn(
                        //     label: _textForDetailInfoTitle('Lot/serial Number')),
                        // DataColumn(label: _textForDetailInfoTitle('Line Note')),
                        DataColumn(label: _textForDetailInfoTitle('Quantity')),
                        // DataColumn(label: _textForDetailInfoTitle('Bag Qty')),
                        // DataColumn(label: _textForDetailInfoTitle('Return Qty')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Customer Note')),
                        DataColumn(label: _textForDetailInfoTitle('UoM')),
                        DataColumn(label: _textForDetailInfoTitle('Packaging')),
                        // DataColumn(
                        //     label: _textForDetailInfoTitle('Secondary Qty')),
                        // DataColumn(
                        //     label: _textForDetailInfoTitle('Secondary UoM')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Unit Price')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Discount(%)')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Total Cost')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Discount Code')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Discount Reason')),
                        DataColumn(
                            label: _textForDetailInfoTitle('Taxes to Apply')),
                        DataColumn(
                            label: _textForDetailInfoTitle(
                                'SubTotal without Tax')),
                        DataColumn(label: _textForDetailInfoTitle('SubTotal')),
                        DataColumn(
                            label:
                                _textForDetailInfoTitle('Refunded Quantity')),
                      ],
                      rows: _productLinesDataRow(controller),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(flex: 2, child: SizedBox()),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: _textForDetailInfoTitle(
                                    "Taxes: ",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: _textForDetailInfo(
                                    '$totalTaxes Ks',
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: _textForDetailInfoTitle(
                                    "Total: ",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: _textForDetailInfo(
                                    '${controller.orderHistory?.amountTotal ?? 0} Ks ',
                                    textAlign: TextAlign.end,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 150, child: Divider()),
                            Row(
                              children: [
                                Expanded(
                                  child: _textForDetailInfoTitle(
                                    "Total Paid (with rounding): ",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: _textForDetailInfo(
                                    "${totalPaidAmt.toStringAsFixed(2)} Ks",
                                    textAlign: TextAlign.end,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  List<DataRow> _productLinesDataRow(OrderDetailController controller) {
    List<DataRow> dataRow = [];
    for (int i = 0; i < (controller.orderHistory?.lineIds ?? []).length; i++) {
      OrderLineID? data = controller.orderHistory?.lineIds?[i];
      dataRow.add(DataRow(cells: [
        DataCell(_textForDetailInfo('${i + 1}')),
        DataCell(
          SizedBox(
            width: 300,
            child: _textForDetailInfo(data?.fullProductName ?? ''),
          ),
        ),
        // DataCell(_textForDetailInfo('')),
        // DataCell(_textForDetailInfo('')),
        // DataCell(_textForDetailInfo('')),
        DataCell(_textForDetailInfo('${data?.qty ?? 0}')),
        // DataCell(_textForDetailInfo('')),
        // DataCell(_textForDetailInfo('0.0')),
        DataCell(_textForDetailInfo('Unit')),
        DataCell(_textForDetailInfo('')),
        DataCell(_textForDetailInfo('')),
        // DataCell(_textForDetailInfo('1.00')),
        // DataCell(_textForDetailInfo('')),
        DataCell(_textForDetailInfo('${data?.priceUnit}')),
        DataCell(_textForDetailInfo('0.00')),
        DataCell(_textForDetailInfo('0.00 Ks')),
        DataCell(_textForDetailInfo('')),
        DataCell(_textForDetailInfo('')),
        DataCell(_textForDetailInfo('')),
        DataCell(_textForDetailInfo('${data?.priceSubtotal}')),
        DataCell(_textForDetailInfo('${data?.priceSubtotalIncl}')),
        DataCell(_textForDetailInfo('')),
      ]));
    }
    return dataRow;
  }

  Widget _paymentsWidget() {
    final double width = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).size.width / 15);
    return Consumer<OrderDetailController>(builder: (_, controller, __) {
      return SingleChildScrollView(
        child: DataTable(
          // columnSpacing: 20.0,
          // horizontalMargin: 20,
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Constants.greyColor),
          columns: [
            DataColumn2(
              label: SizedBox(
                width: width / 4,
                child: _textForDetailInfoTitle('#'),
              ),
            ),
            DataColumn2(
              label: SizedBox(
                width: width / 4,
                child: _textForDetailInfoTitle('Date'),
              ),
            ),
            DataColumn2(
              label: SizedBox(
                width: width / 4,
                child: _textForDetailInfoTitle('Payment Method'),
              ),
            ),
            DataColumn2(
                label: SizedBox(
              width: width / 4,
              child: _textForDetailInfoTitle('Amount'),
            )),
          ],
          rows: _paymentsDataRow(controller),
        ),
      );
    });
  }

  List<DataRow> _paymentsDataRow(OrderDetailController controller) {
    List<DataRow> dataRow = [];
    for (int i = 0;
        i < (controller.orderHistory?.paymentIds ?? []).length;
        i++) {
      PaymentTransaction? data = controller.orderHistory?.paymentIds?[i];
      dataRow.add(DataRow(cells: [
        DataCell(_textForDetailInfo('${i + 1}')),
        DataCell(_textForDetailInfo(CommonUtils.getLocaleDateTime(
          "dd-MM-yyyy hh:mm:ss",
          data?.paymentDate,
        ))),
        DataCell(_textForDetailInfo('${data?.paymentMethodName}')),
        DataCell(_textForDetailInfo('${data?.amount}')),
      ]));
    }
    return dataRow;
  }

  Widget _textForDetailInfoTitle(
    String text, {
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? Constants.textColor,
        fontSize: fontSize ?? 17,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    );
  }

  Widget _textForDetailInfo(
    String text, {
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      maxLines: 2,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? Constants.textColor,
        fontSize: fontSize ?? 17,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
