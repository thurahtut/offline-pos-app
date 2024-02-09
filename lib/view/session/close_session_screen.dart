import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/controller/close_session_controller.dart';
import 'package:sqflite/sqflite.dart';

class CloseSessionScreen extends StatefulWidget {
  const CloseSessionScreen({
    super.key,
    required this.mainContext,
    required this.bContext,
  });
  final BuildContext mainContext;
  final BuildContext bContext;

  @override
  State<CloseSessionScreen> createState() => _CloseSessionScreenState();
}

class _CloseSessionScreenState extends State<CloseSessionScreen> {
  final TextEditingController noteTextController = TextEditingController();

  @override
  void dispose() {
    noteTextController.dispose();
    super.dispose();
  }

  _init() {
    int sessionId = context.read<LoginUserController>().posSession?.id ?? 0;

    OrderHistoryTable.getTotalSummary(sessionId).then((value) {
      context.read<CloseSessionController>().totalSummaryMap = value;
    });
    PaymentMethodTable.getActivePaymentMethod().then((paymentMethods) {
      context.read<CloseSessionController>().paymentTransactionList = {};
      for (PaymentMethod e in paymentMethods ?? []) {
        context
            .read<CloseSessionController>()
            .paymentTransactionList[e.id ?? 0] = PaymentTransaction(
          paymentMethodId: e.id,
          paymentMethodName: e.name,
          createDate: DateTime.now().toString(),
          createUid:
              context.read<LoginUserController>().loginUser?.userData?.id ?? 0,
          isChange: false,
          paymentStatus: "",
          sessionId: sessionId,
        );
      }

      PaymentTransactionTable.getTotalTransactionSummary(sessionId)
          .then((tSummary) {
        for (var element in tSummary) {
          context
              .read<CloseSessionController>()
              .paymentTransactionList[
                  int.tryParse(element["id"]?.toString() ?? "") ?? 0]
              ?.amount = element["tPaid"]?.toString();
        }
        context.read<CloseSessionController>().notify();
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CloseSessionController>().resetCloseSessionController();
      _init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  Widget _bodyWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _overallWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _transactionDetailsWidget(),
                        SizedBox(height: 10),
                        _noteWidget(),
                        SizedBox(height: 4),
                        _warningConfirmWidget(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _actionWidget(),
        ],
      ),
    );
  }

  Widget _overallWidget() {
    TextStyle textStyle = TextStyle(
      fontSize: 18,
      color: Constants.textColor,
      fontWeight: FontWeight.bold,
    );
    return Consumer<CloseSessionController>(builder: (_, controller, __) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Total ${controller.totalSummaryMap["totalOrderHistory"] ?? 0} orders',
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "${CommonUtils.priceFormat.format(controller.totalSummaryMap["totalAmt"] ?? 0)} Ks",
                          style: textStyle,
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Payments',
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "${CommonUtils.priceFormat.format(controller.totalSummaryMap["totalPaid"] ?? 0)} Ks",
                          style: textStyle,
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Customer Account',
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "${CommonUtils.priceFormat.format(controller.totalSummaryMap["totalCustomerAmt"] ?? 0)} Ks",
                          style: textStyle,
                        )),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 3,
            height: 70,
            decoration: BoxDecoration(
              color: Constants.greyColor2,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              CommonUtils.priceFormat.format(60000),
              style: textStyle,
            ),
          ),
        ],
      );
    });
  }

  Widget _transactionDetailsWidget() {
    return Column(
      children: [
        _headerTransactionWidget(),
        ..._eachTransactionWidget(),
      ],
    );
  }

  Widget _headerTransactionWidget() {
    TextStyle textStyle = TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    double width = (MediaQuery.of(widget.mainContext).size.width / 1.4) / 5;
    return Container(
      color: primaryColor,
      height: 70,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: width * 2,
            child: Text(
              'Payment Method'.toUpperCase(),
              style: textStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: width,
            child: Text(
              'Expected'.toUpperCase(),
              style: textStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: width,
            child: Text(
              'Counter'.toUpperCase(),
              style: textStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: width,
            child: Text(
              'Difference'.toUpperCase(),
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _eachTransactionWidget() {
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Constants.textColor,
      fontWeight: FontWeight.bold,
    );
    double width = (MediaQuery.of(widget.mainContext).size.width / 1.4) / 5;
    return context
            .watch<CloseSessionController>()
            .paymentTransactionList
            .isEmpty
        ? []
        : context
            .read<CloseSessionController>()
            .paymentTransactionList
            .values
            .map((e) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.15))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 2,
                        child: Text(
                          e.paymentMethodName ?? '',
                          style: textStyle,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Text(
                          '${CommonUtils.priceFormat.format(double.tryParse(getAmount(e.paymentMethodName, e.amount) ?? '') ?? 0)} Ks',
                          style: textStyle,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: (double.tryParse(getAmount(
                                            e.paymentMethodName, e.amount) ??
                                        '') ??
                                    0) >
                                0
                            ? TextField(
                                style: TextStyle(
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: textStyle.copyWith(
                                      color: Constants.disableColor),
                                  // contentPadding: EdgeInsets.all(20),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                ),
                                onChanged: (value) {
                                  e.payingAmount = value;
                                  context
                                      .read<CloseSessionController>()
                                      .notify();
                                },
                              )
                            : Text(
                                '',
                                style: textStyle,
                              ),
                      ),
                      SizedBox(
                        width: width,
                        child: Text(
                          '${(double.tryParse(e.payingAmount ?? '') ?? 0) - (double.tryParse(getAmount(e.paymentMethodName, e.amount) ?? '') ?? 0)}',
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                if (e.paymentMethodName?.toLowerCase().contains('cash') ??
                    false)
                  Container(
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(width: 3))),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.15))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: (width - 3.5) * 2,
                                child: Text(
                                  'Opening',
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: Text(
                                  '${CommonUtils.priceFormat.format(60000)} Ks',
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: (width - 64),
                                child: Text(
                                  '',
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: (width - 64),
                                child: Text(
                                  '',
                                  style: textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.15))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: (width - 3.5) * 2,
                                child: Text(
                                  '+ Payments in ${e.paymentMethodName ?? ''}',
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: Text(
                                  '${CommonUtils.priceFormat.format(double.tryParse(e.amount ?? '') ?? 0)} Ks',
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: (width - 64),
                                child: Text(
                                  '',
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: (width - 64),
                                child: Text(
                                  '',
                                  style: textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList();
  }

  String? getAmount(String? paymentMethodName, String? amount) {
    return paymentMethodName?.toLowerCase().contains('cash') ?? false
        ? ((double.tryParse(amount ?? '') ?? 0) + 60000).toString()
        : amount;
  }

  Container _noteWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all()),
      child: TextField(
        controller: noteTextController,
        keyboardType: TextInputType.multiline,
        maxLines: 2,
        style: TextStyle(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          hintText: "Note",
          hintStyle: TextStyle(
            color: Constants.disableColor.withOpacity(0.9),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _warningConfirmWidget() {
    return CheckboxListTile(
      value: false,
      onChanged: (bool? value) {},
      controlAffinity: ListTileControlAffinity.leading,
      side: MaterialStateBorderSide.resolveWith(
          (_) => BorderSide(width: 2, color: primaryColor)),
      checkColor: primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      title: Text(
          'Accept payments difference and post a profit/loss journal entry'),
    );
  }

  Container _actionWidget() {
    return Container(
      height: 70,
      padding: EdgeInsets.all(8),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          BorderContainer(
            text: 'Continue Selling',
            textColor: Colors.white,
            containerColor: primaryColor,
            width: MediaQuery.of(context).size.width / 8,
            textSize: 15,
            onTap: () {
              Navigator.pop(widget.bContext);
            },
          ),
          SizedBox(width: 8),
          BorderContainer(
            text: 'Keep Session Open',
            textColor: Colors.white,
            containerColor: primaryColor,
            width: MediaQuery.of(context).size.width / 8,
            textSize: 15,
          ),
          SizedBox(width: 8),
          BorderContainer(
            text: 'Close Session',
            textColor: Colors.white,
            containerColor: primaryColor,
            width: MediaQuery.of(context).size.width / 8,
            textSize: 15,
            onTap: () async {
              int sessionId =
                  context.read<LoginUserController>().posSession?.id ?? 0;

              final Database db = await DatabaseHelper().db;
              OrderHistoryTable.getOrderHistoryList(
                      db: db, isCloseSession: true)
                  .then((value) async {
                if (value.isNotEmpty) {
                  // _syncOrderHistory(value: value, sessionId: sessionId, db: db)
                  //     .then((value) => Navigator.pop(widget.bContext));
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _syncOrderHistory(
      {required List<Map<String, dynamic>> value,
      required int sessionId,
      Database? db}) async {
    for (var mapArg in value) {
      await Api.closeSession(
        closeSession: mapArg,
        sessionId: sessionId,
      ).then((closeResult) {
        if (closeResult != null &&
            closeResult.statusCode == 200 &&
            closeResult.data != null) {
          OrderHistoryTable.updateValue(
            db: db,
            whereColumnName: SEQUENCE_NUMBER,
            whereValue: mapArg[SEQUENCE_NUMBER],
            columnName: ORDER_CONDITION,
            value: OrderCondition.sync.text,
          );
        } else if (closeResult == null || closeResult.statusCode != 200) {
          CommonUtils.showSnackBar(
              context: widget.mainContext,
              message: closeResult!.statusMessage ?? 'Something was wrong!');
        }
      });
    }
  }
}
