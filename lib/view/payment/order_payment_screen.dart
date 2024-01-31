import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

class OrderPaymentScreen extends StatefulWidget {
  static const String routeName = "/order_payment_screen";
  const OrderPaymentScreen({super.key});

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _textNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CurrentOrderController>().getAllPaymentMethod();
    });
    super.initState();
  }

  @override
  void dispose() {
    _textNode.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SaleAppBar(),
      body: _bodyWidget(),
    ));
  }

  Widget _bodyWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return RawKeyboardListener(
      focusNode: _textNode,
      onKey: (event) {
        _handleKeyEvent(event, context.read<CurrentOrderController>());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: isTabletMode
                ? 10
                : (MediaQuery.of(context).size.width / 3) / 2.5),
        child: Column(
          children: [
            _actionButtonsWidget(),
            SizedBox(height: 40),
            _paymentTypeAndAmountWidget(),
          ],
        ),
      ),
    );
  }

  Row _actionButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BorderContainer(
          text: 'Back',
          width: MediaQuery.of(context).size.width / 8.5,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        BorderContainer(
          text: 'Validate',
          width: MediaQuery.of(context).size.width / 8.5,
          containerColor: primaryColor,
          textColor: Colors.white,
          onTap: () async {
            CurrentOrderController currentOrderController =
                context.read<CurrentOrderController>();
            final Database db = await DatabaseHelper().db;
            double totalAmt = currentOrderController
                .getTotalQty(currentOrderController.currentOrderList)
                .last;
            double totalPayAmt = 0;
            PaymentTransactionTable.deleteByOrderId(
                db, currentOrderController.orderHistory?.id ?? 0);
            for (var data
                in currentOrderController.paymentTransactionList.values) {
              totalPayAmt += (double.tryParse(data.amount ?? '') ?? 0);
              data.orderId = currentOrderController.orderHistory?.id ?? 0;
              data.paymentDate =
                  currentOrderController.orderHistory?.createDate ?? '';
              if ((double.tryParse(data.amount ?? '') ?? 0) <= 0) {
                currentOrderController.paymentTransactionList
                    .remove(data.paymentMethodId);
              }
            }
            if (totalAmt > totalPayAmt) {
              if (mounted) {
                CommonUtils.showSnackBar(
                  context: context,
                  message: 'Pay amount is required!',
                );
              }
              return;
            }

            insertPaymentTransaction(
                    db,
                    currentOrderController.paymentTransactionList.values
                        .toList())
                .then((value) {
              // currentOrderController.currentOrderList = [];
              OrderHistoryTable.updateValue(
                  db,
                  currentOrderController.orderHistory?.id ?? 0,
                  RECEIPT_NUMBER,
                  'Order_${DateTime.now().millisecondsSinceEpoch}');
              OrderHistoryTable.updateValue(
                  db,
                  currentOrderController.orderHistory?.id ?? 0,
                  STATE_IN_OT,
                  OrderState.paid.text);
              var count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 1;
              });
              Navigator.pushNamed(context, OrderPaymentReceiptScreen.routeName);
            });
          },
        ),
      ],
    );
  }

  Future<void> insertPaymentTransaction(final Database db,
      List<PaymentTransaction> paymentTransactionList) async {
    for (var data in paymentTransactionList) {
      PaymentTransactionTable.insertWithDb(db, data);
    }
  }

  Widget _paymentTypeAndAmountWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return isTabletMode
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paymentTypeWidget(),
              SizedBox(height: 10),
              _editAmountWidget(),
              SizedBox(height: 10),
              _paymentCalculatorWidget(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _paymentTypeWidget()),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _editAmountWidget(),
                      SizedBox(height: 10),
                      _paymentCalculatorWidget(),
                    ],
                  ))
            ],
          );
  }

  Widget _paymentTypeWidget() {
    return Consumer<CurrentOrderController>(builder: (_, controller, __) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ...controller.paymentMethodList
            .map(
              (e) => InkWell(
                onTap: () {
                  _textNode.requestFocus();
                  double totalAmt =
                      controller.getTotalQty(controller.currentOrderList).last;
                  double totalPayAmt = 0;

                  for (var data in controller.paymentTransactionList.values) {
                    totalPayAmt += (double.tryParse(data.amount ?? '') ?? 0);
                  }

                  controller.selectedPaymentMethodId = e.id ?? -1;
                  controller.paymentTransactionList[e.id ?? -1] ??=
                      PaymentTransaction(
                    paymentMethodId: e.id,
                    paymentMethodName: e.name,
                  );
                  controller.paymentTransactionList[e.id ?? -1]?.amount =
                      (totalPayAmt < totalAmt ? totalAmt - totalPayAmt : 0)
                          .toString();
                  controller.notify();
                },
                focusColor: Colors.transparent,
                overlayColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.transparent),
                highlightColor: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: controller
                                .paymentTransactionList[
                                    controller.selectedPaymentMethodId]
                                ?.paymentMethodId ==
                            e.id
                        ? primaryColor
                        : null,
                    border: Border.all(
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: (controller.paymentTransactionList[
                                            controller.selectedPaymentMethodId])
                                        ?.paymentMethodId ==
                                    e.id
                                ? Colors.white
                                : primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          (double.tryParse(controller
                                              .paymentTransactionList[e.id]
                                              ?.amount ??
                                          '') ??
                                      0) <=
                                  0
                              ? ''
                              : CommonUtils.priceFormat.format(double.tryParse(
                                      controller.paymentTransactionList[e.id]
                                              ?.amount ??
                                          '') ??
                                  0),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: controller
                                        .paymentTransactionList[
                                            controller.selectedPaymentMethodId]
                                        ?.paymentMethodId ==
                                    e.id
                                ? Colors.white
                                : primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList()
      ]);
    });
  }

  Widget _editAmountWidget() {
    return Consumer<CurrentOrderController>(
      builder: (_, controller, __) {
        double totalAmt =
            controller.getTotalQty(controller.currentOrderList).last;
        double totalPayAmt = 0;
        double remainingAmt = totalAmt;

        // ;
        for (var data in controller.paymentTransactionList.values) {
          totalPayAmt += (double.tryParse(data.amount ?? '') ?? 0);
        }
        remainingAmt = totalAmt - totalPayAmt;
        return Container(
          height: 200,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 45),
          decoration: BoxDecoration(
            color: Constants.greyColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(text: "", children: [
                      TextSpan(
                        text: "Remaining ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${CommonUtils.priceFormat.format(totalPayAmt >= totalAmt ? 0 : remainingAmt)} Ks',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ]),
                  ),
                  Expanded(child: SizedBox()),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(text: "", children: [
                      TextSpan(
                        text: "Change ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${CommonUtils.priceFormat.format(totalPayAmt >= totalAmt ? (double.tryParse(controller.paymentTransactionList[controller.selectedPaymentMethodId]?.amount ?? '') ?? 0) - (totalAmt - (totalPayAmt - (double.tryParse(controller.paymentTransactionList[controller.selectedPaymentMethodId]?.amount ?? '') ?? 0))) : 0)} Ks',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.56),
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'Total Due ${CommonUtils.priceFormat.format(totalAmt)} Ks',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.56),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(child: SizedBox(height: 6)),
              Text(
                controller.paymentTransactionList.isEmpty &&
                        controller
                                .paymentTransactionList[
                                    controller.selectedPaymentMethodId]
                                ?.paymentMethodId ==
                            null
                    ? 'Please select a payment method'
                    : '',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Constants.alertColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentCalculatorWidget() {
    return Consumer<CurrentOrderController>(
        builder: (_, currentOrderController, __) {
      return Column(
        children: [
          _eachCalculatorRowWidget(
            [
              CommonUtils.eachCalculateButtonWidget(
                text: "1",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "1");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "2",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "2");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "3",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "3");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "+10",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "10",
                      valueAdding: true);
                },
              ),
              context.watch<CurrentOrderController>().isContainCustomer == true
                  ? CommonUtils.eachCalculateButtonWidget(
                      text: "BG Bakerys",
                      width: 150,
                      prefixSvg: "assets/svg/account_circle.svg",
                      svgColor: primaryColor,
                      onPressed: () {},
                    )
                  : CommonUtils.eachCalculateButtonWidget(
                      text: "Invoice",
                      width: 150,
                      prefixSvg: "assets/svg/receipt_long.svg",
                      svgColor: primaryColor,
                      onPressed: () {},
                    ),
            ],
          ),
          SizedBox(height: 4),
          _eachCalculatorRowWidget(
            [
              CommonUtils.eachCalculateButtonWidget(
                text: "4",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "4");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "5",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "5");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "6",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "6");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                  text: "+20",
                  onPressed: () {
                    _updatePayAmount(currentOrderController, "20",
                        valueAdding: true);
                  }),
              context.watch<CurrentOrderController>().isContainCustomer == true
                  ? CommonUtils.eachCalculateButtonWidget(
                      text: "Invoice",
                      width: 150,
                      prefixSvg: "assets/svg/receipt_long.svg",
                      svgColor: primaryColor,
                      onPressed: () {},
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 4),
          _eachCalculatorRowWidget(
            [
              CommonUtils.eachCalculateButtonWidget(
                text: "7",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "7");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "8",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "8");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "9",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "9");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: "+50",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "50",
                      valueAdding: true);
                },
              ),
            ],
          ),
          SizedBox(height: 4),
          _eachCalculatorRowWidget(
            [
              CommonUtils.eachCalculateButtonWidget(
                  text: "+/-", onPressed: () {}),
              CommonUtils.eachCalculateButtonWidget(
                text: "0",
                onPressed: () {
                  _updatePayAmount(currentOrderController, "0");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                text: ".",
                onPressed: () {
                  _updatePayAmount(currentOrderController, ".");
                },
              ),
              CommonUtils.eachCalculateButtonWidget(
                icon: Icons.backspace_outlined,
                iconColor: Constants.alertColor,
                onPressed: () {
                  _updatePayAmount(currentOrderController, "", isBack: true);
                },
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _eachCalculatorRowWidget(List<Widget> widgets) {
    return Row(
      children: widgets
          .map((e) => Row(
                children: [
                  e,
                  SizedBox(
                    width: 4,
                  )
                ],
              ))
          .toList(),
    );
  }

  double parseValueAmount(String str) {
    double value = double.tryParse(str) ?? 0;
    return value;
  }

  void _updatePayAmount(
    CurrentOrderController currentOrderController,
    String value, {
    bool? isBack,
    bool? valueAdding,
  }) {
    if (currentOrderController.paymentTransactionList[
            currentOrderController.selectedPaymentMethodId] !=
        null) {
      PaymentTransaction paymentTransaction =
          currentOrderController.paymentTransactionList[
              currentOrderController.selectedPaymentMethodId]!;
      String price = paymentTransaction.amount?.toString() ?? "";
      if (isBack == true) {
        if (paymentTransaction.firstTime == true) {
          price = "";
          paymentTransaction.firstTime = false;
        } else {
          price = price.substring(0, price.length - 1);
        }
      } else if (valueAdding == true) {
        double val =
            (double.tryParse(price) ?? 0) + (double.tryParse(value) ?? 0);
        price = val.toString();
      } else {
        if (paymentTransaction.firstTime == true) {
          price = "";
          paymentTransaction.firstTime = false;
        } 
        price += value;
      }
      currentOrderController
          .paymentTransactionList[
              currentOrderController.selectedPaymentMethodId]!
          .amount = price;
      currentOrderController.notify();
    }
  }

  void _handleKeyEvent(RawKeyEvent event, CurrentOrderController controller) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        _updatePayAmount(controller, "", isBack: true);
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
        _updatePayAmount(controller, event.logicalKey.keyLabel);
      }
    }
  }
}
