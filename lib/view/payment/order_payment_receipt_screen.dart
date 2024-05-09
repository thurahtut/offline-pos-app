import 'package:offline_pos/components/export_files.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderPaymentReceiptScreen extends StatefulWidget {
  const OrderPaymentReceiptScreen({super.key, required this.isNewOrder});
  static const String routeName = "/order_payment_receipt_screen";
  final bool? isNewOrder;

  @override
  State<OrderPaymentReceiptScreen> createState() =>
      _OrderPaymentReceiptScreenState();
}

class _OrderPaymentReceiptScreenState extends State<OrderPaymentReceiptScreen> {
  var myTheme;

  ByteData? fontData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fontData = await rootBundle.load("assets/font/PyidaungsuRegular.ttf");
      // setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.read<CurrentOrderController>().resetCurrentOrderController();
      },
      child: Scaffold(
        body: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Row(
      children: [
        Expanded(flex: 2, child: _receiptWidget()),
        VerticalDivider(width: 2),
        Expanded(child: _otherActionButtons()),
      ],
    );
  }

  Widget _receiptWidget() {
    return PdfPreview(
      initialPageFormat: PdfPageFormat.roll80,
      allowSharing: false,
      allowPrinting: false,
      canChangeOrientation: false,
      canChangePageFormat: false,
      maxPageWidth: PdfPageFormat.roll80.width * 2.2,
      build: (format) => _generatePdf(),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final doc = pw.Document(
      theme: myTheme,
    );
    Map<String, double> map = context
        .read<CurrentOrderController>()
        .getTotalQty(context.read<CurrentOrderController>().currentOrderList);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: pw.EdgeInsets.all(8),
        build: (pw.Context bContext) {
          return pw.Container(
              width: PdfPageFormat.roll80.width,
              padding: pw.EdgeInsets.only(
                right: 4,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  if (context.read<ThemeSettingController>().appConfig?.logo !=
                      null)
                    pw.SizedBox(
                        height: 160,
                        child: pw.Image(
                            pw.MemoryImage(
                              context
                                  .read<ThemeSettingController>()
                                  .appConfig!
                                  .logo!, //  Uint8List.fromList(byteList),
                            ),
                            fit: pw.BoxFit.fitHeight)),
                  pw.Text(
                    'SSS International Co.,ltd',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 7,
                    ),
                  ),
                  pw.Text(
                    'contact@sssretail.com',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 7,
                    ),
                  ),
                  pw.Text(
                    'https://www.sssretail.com',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 7,
                    ),
                  ),
                  pw.Text(
                    context
                            .read<LoginUserController>()
                            .posConfig
                            ?.receiptHeader ??
                        '',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 7,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  pw.SizedBox(
                    width: PdfPageFormat.roll80.width / 2,
                    child: pw.Divider(
                      borderStyle: pw.BorderStyle.dashed,
                      thickness: 0.6,
                      height: 2,
                    ),
                  ),
                  pw.Text(
                    'Served by : ${context.read<LoginUserController>().loginEmployee?.name}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 7,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.SizedBox(child: pw.Divider()),
                  getHeaderWidget(doc),
                  pw.SizedBox(child: pw.Divider()),
                  ...getOrderItem(doc),
                  _totalWidget(map),
                  pw.SizedBox(height: 40),
                  ..._transactionWidget(),
                  pw.SizedBox(height: 40),
                  _changeWidget(),
                  pw.SizedBox(height: 20),
                  _totalDisWidget(map),
                  if ((map["tax"] ?? 0) > 0) pw.SizedBox(height: 20),
                  if ((map["tax"] ?? 0) > 0) _s5TaxWidget(map),
                  pw.SizedBox(height: 20),
                  _totalTaxWidget(map),
                  pw.SizedBox(height: 20),
                  _totalQtyWidget(map),
                  pw.SizedBox(height: 10),
                  if (context.read<CurrentOrderController>().selectedCustomer !=
                      null)
                    pw.SizedBox(
                      width: PdfPageFormat.roll80.width / 2,
                      child: pw.Divider(
                        borderStyle: pw.BorderStyle.dashed,
                        thickness: 0.6,
                        height: 2,
                      ),
                    ),
                  if (context.read<CurrentOrderController>().selectedCustomer !=
                      null)
                    pw.SizedBox(height: 10),
                  if (context.read<CurrentOrderController>().selectedCustomer !=
                      null)
                    pw.Text(
                      context
                              .read<CurrentOrderController>()
                              .selectedCustomer!
                              .name ??
                          '',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(Constants.textColor.value),
                        fontSize: 9,
                        font: fontData != null ? pw.Font.ttf(fontData!) : null,
                      ),
                    ),
                  pw.SizedBox(height: 30),
                  ..._thankYouWidget(),
                  pw.SizedBox(height: 40),
                  ..._orderIdWidget(),
                ],
              ));
        },
      ),
    );

    return doc.save();
  }

  pw.Widget getHeaderWidget(pw.Document doc) {
    pw.TextStyle textStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 7,
      fontWeight: pw.FontWeight.bold,
      font: fontData != null ? pw.Font.ttf(fontData!) : null,
      // fontWeight: pw.FontWeight.w500,
    );
    double maxPageWidth = PdfPageFormat.roll80.width;
    return pw.Row(children: [
      pw.Expanded(
        // width: (maxPageWidth / 8) * 3,
        child: pw.Text(
          "Description",
          style: textStyle,
        ),
      ),
      pw.SizedBox(
        width: (maxPageWidth / 8),
        child: pw.Text(
          "Qty",
          style: textStyle,
        ),
      ),
      pw.SizedBox(
        width: (maxPageWidth / 8) * 2,
        child: pw.Text(
          "Price",
          style: textStyle,
        ),
      ),
      pw.SizedBox(
        width: (maxPageWidth / 8) * 1.7,
        child: pw.Text(
          "Amount",
          style: textStyle,
        ),
      ),
    ]);
  }

  List<pw.Widget> getOrderItem(pw.Document doc) {
    List<pw.Widget> widgets = [];
    for (int i = 0;
        i < context.read<CurrentOrderController>().currentOrderList.length;
        i++) {
      widgets.add(_eachWidget(
          context.read<CurrentOrderController>().currentOrderList[i]));
      widgets.add(pw.SizedBox(height: 8));
    }
    return widgets;
  }

  pw.Widget _eachWidget(Product e) {
    pw.TextStyle textStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 7,
      fontWeight: pw.FontWeight.normal,
      font: fontData != null ? pw.Font.ttf(fontData!) : null,
      // fontWeight: pw.FontWeight.w500,
    );
    double maxPageWidth = PdfPageFormat.roll80.width;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Expanded(
              // width: (maxPageWidth / 8) * 3,
              child: pw.RichText(
                maxLines: 2,
                // overflow: pw.TextOverflow.ellipsis,
                text: pw.TextSpan(text: "", children: [
                  pw.TextSpan(
                    text: e.barcode != null ? " [${e.barcode}]" : "",
                    style: textStyle,
                  ),
                  pw.TextSpan(text: e.productName, style: textStyle),
                ]),
              ),
            ),
            pw.SizedBox(
              width: (maxPageWidth / 8),
              child: pw.Text(
                "${e.onhandQuantity ?? 0}",
                style: textStyle,
              ),
            ),
            pw.SizedBox(
              width: (maxPageWidth / 8) * 2,
              child: pw.Text(
                "${e.priceListItem?.fixedPrice ?? 0}",
                style: textStyle,
              ),
            ),
            pw.SizedBox(
              width: (maxPageWidth / 8) * 1.7,
              child: pw.Text(
                "${((e.priceListItem?.fixedPrice ?? 0) * (e.onhandQuantity ?? 0)) - (((e.priceListItem?.fixedPrice ?? 0) * (e.onhandQuantity ?? 0)) * ((e.discount ?? 0)) / 100)}",
                style: textStyle,
              ),
            ),
          ],
        ),
        if (e.discount != null && e.discount != 0)
          pw.RichText(
            // maxLines: 2,
            // overflow: pw.TextOverflow.ellipsis,
            text: pw.TextSpan(text: "", children: [
              pw.TextSpan(
                  text:
                      "\n ${(e.priceListItem?.fixedPrice ?? 0) * (e.onhandQuantity ?? 0)} \n Discount: ${double.tryParse(e.discount?.toString() ?? '0')?.toStringAsFixed(2) ?? 0.00}%",
                  style: textStyle.copyWith(
                    fontSize: 9,
                  )),
            ]),
          ),
      ],
    );
  }

  pw.Widget _totalWidget(Map<String, double> map) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14.0),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.SizedBox(
              width: PdfPageFormat.roll80.width / 6,
              child: pw.Divider(
                thickness: 0.6,
                height: 2,
                color: PdfColors.black,
                borderStyle: pw.BorderStyle.dashed,
              ),
            ),
          ]),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Expanded(
                child: pw.Center(
                  child: pw.Text(
                    "TOTAL",
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#171717"),
                      fontSize: 10.6,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 4),
              pw.Text(
                "${CommonUtils.priceFormat.format(map["total"] ?? 0)} Ks",
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 11.6,
                  // fontWeight: pw.FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _transactionWidget() {
    List<pw.Widget> widgets = [];
    if (context.read<CurrentOrderController>().paymentTransactionList.isEmpty) {
      return widgets;
    }

    double? fontSize = 9;
    for (var e in context
        .read<CurrentOrderController>()
        .paymentTransactionList
        .values) {
      widgets.add(
        pw.SizedBox(
          width: PdfPageFormat.roll80.width,
          child: pw.Row(
            children: [
              pw.Center(
                child: pw.Text(
                  e.paymentMethodName ?? '',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#171717"),
                    fontSize: fontSize,
                    font: fontData != null ? pw.Font.ttf(fontData!) : null,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.SizedBox(),
              ),
              pw.Text(
                CommonUtils.priceFormat.format(
                    (double.tryParse(e.amount ?? "") ?? 0) +
                        (e.paymentMethodName?.toLowerCase().contains('cash') ??
                                false
                            ? (context
                                    .read<CurrentOrderController>()
                                    .orderHistory
                                    ?.changeAmt ??
                                0)
                            : 0)),
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: fontSize,
                  // fontWeight: pw.FontWeight.w400,
                ),
              ),
              pw.SizedBox(width: 12),
            ],
          ),
        ),
      );
      widgets.add(pw.SizedBox(height: 8));
    }
    return widgets;
  }

  pw.Widget _changeWidget() {
    // Map<String, double> map = context
    //     .read<CurrentOrderController>()
    //     .getTotalQty(context.read<CurrentOrderController>().currentOrderList);
    // double totalAmt = map["total"] ?? 0;
    // double totalPayAmt = 0;

    // // ;
    // for (var data in context
    //     .read<CurrentOrderController>()
    //     .paymentTransactionList
    //     .values) {
    //   totalPayAmt += (double.tryParse(data.amount ?? '') ?? 0);
    // }
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Expanded(
            child: pw.Center(
              child: pw.Text(
                "CHANGE",
                style: pw.TextStyle(
                  color: PdfColor.fromHex("#171717"),
                  fontSize: 10.6,
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Text(
            "${context.read<CurrentOrderController>().orderHistory?.changeAmt ?? 0.00}Ks",
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 11.6,
              // fontWeight: pw.FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _totalDisWidget(Map<String, double> map) {
    double? fontSize = 9;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Expanded(
          child: pw.Text(
            "Discounts",
            textAlign: pw.TextAlign.start,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#262927"),
              fontSize: fontSize,
            ),
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          "${map["tDis"] ?? 0} Ks",
          style: pw.TextStyle(
            color: PdfColor.fromHex("#171717"),
            fontSize: fontSize,
            // fontWeight: pw.FontWeight.w400,
          ),
        ),
        pw.SizedBox(width: 12),
      ],
    );
  }

  pw.Widget _totalTaxWidget(Map<String, double> map) {
    double? fontSize = 9;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Expanded(
          child: pw.Text(
            "Total Taxes",
            textAlign: pw.TextAlign.start,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#262927"),
              fontSize: fontSize,
            ),
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          "${map["tax"] ?? 0} Ks",
          style: pw.TextStyle(
            color: PdfColor.fromHex("#171717"),
            fontSize: fontSize,
            // fontWeight: pw.FontWeight.w400,
          ),
        ),
        pw.SizedBox(width: 12),
      ],
    );
  }

  pw.Widget _s5TaxWidget(Map<String, double> map) {
    double? fontSize = 9;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Expanded(
          child: pw.Text(
            "S5",
            textAlign: pw.TextAlign.start,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#262927"),
              fontSize: fontSize,
            ),
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          "${map["tax"] ?? 0} Ks",
          style: pw.TextStyle(
            color: PdfColor.fromHex("#171717"),
            fontSize: fontSize,
            // fontWeight: pw.FontWeight.w400,
          ),
        ),
        pw.SizedBox(width: 12),
      ],
    );
  }

  pw.Widget _totalQtyWidget(Map<String, double> map) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Center(
          child: pw.Text(
            "Total Items : ${context.read<CurrentOrderController>().currentOrderList.length} | Total Qty : ${map["qty"] ?? 0}",
            style: pw.TextStyle(
              color: PdfColor.fromHex("#262927"),
              fontSize: 9,
            ),
          ),
        ),
        pw.Expanded(child: pw.SizedBox()),
      ],
    );
  }

  List<pw.Widget> _thankYouWidget() {
    return [
      pw.Container(
        width: PdfPageFormat.roll80.width,
        padding: pw.EdgeInsets.only(right: 8),
        child: pw.Text(
          context.read<LoginUserController>().posConfig?.receiptFooter ?? '',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#262927"),
            fontSize: 8.8,
            font: fontData != null ? pw.Font.ttf(fontData!) : null,
          ),
        ),
      ),
    ];
  }

  List<pw.Widget> _orderIdWidget() {
    pw.TextStyle textStyle = pw.TextStyle(
      color: PdfColor.fromHex("#262927"),
      fontSize: 11,
      fontWeight: pw.FontWeight.normal,
      height: 0.8,
      decorationStyle: pw.TextDecorationStyle.double,
    );
    return [
      pw.Text(
        context
                .read<CurrentOrderController>()
                .orderHistory
                ?.receiptNumber
                ?.toString() ??
            '',
        textAlign: pw.TextAlign.center,
        style: textStyle,
      ),
      pw.Text(
        CommonUtils.getLocaleDateTime(
          "dd-MM-yyyy hh:mm:ss",
          context.read<CurrentOrderController>().orderHistory?.createDate,
        ),
        style: textStyle,
      ),
    ];
  }

  Widget _otherActionButtons() {
    return Column(
      children: [
        SizedBox(height: 20),
        BorderContainer(
          width: MediaQuery.of(context).size.width / 4.5,
          text: 'Print',
          textColor: Colors.white,
          containerColor: primaryColor,
          onTap: () async {
            // List<int> d = await _generatePdf();
            // Uint8List byte = Uint8List.fromList(d);
            // // Get temporary directory
            // final dir = await getTemporaryDirectory();

            // // for download receipt image
            // await for (var page in Printing.raster(byte, pages: [0])) {
            //   var file =
            //       File('${dir.path}/order_id_${DateTime.now().toString()}.png');
            //   final byteData = await page.toPng();
            //   await file.writeAsBytes(byteData, flush: true);
            //   final result = await ImageGallerySaver.saveImage(
            //       byteData.buffer.asUint8List());
            //   print(result);
            //   // final image = page.toImage(); // ...or page.toPng()
            //   // print(image);
            // }
            // if (Platform.isAndroid || Platform.isIOS) {
            //   Printer? pri = await Printing.pickPrinter(context: context);
            //   await Printing.directPrintPdf(
            //       printer: pri!,
            //       onLayout: (PdfPageFormat format) async => _generatePdf());
            // } else {
            List<Printer> printers = await Printing.listPrinters();
            Printer? printer;
            for (var pri in printers) {
              if (pri.isDefault) {
                printer = pri;
                break;
              }
            }
            if (mounted) {
              printer ??= await Printing.pickPrinter(context: context);
            }
            if (printer != null) {
              await Printing.directPrintPdf(
                onLayout: (PdfPageFormat format) async => _generatePdf(),
                printer: printer,
                format: PdfPageFormat.roll80,
                usePrinterSettings: true,
              );
            } else if (mounted) {
              CommonUtils.showSnackBar(
                  context: context, message: "There is no printer!");
            }
          },
        ),
        // SizedBox(height: 20),
        // BorderContainer(
        //   width: MediaQuery.of(context).size.width / 4.5,
        //   text: 'Mail',
        //   textColor: primaryColor,
        // ),
        SizedBox(height: 20),
        widget.isNewOrder == false ||
                context.read<CurrentOrderController>().isRefund == true
            ? BorderContainer(
                width: MediaQuery.of(context).size.width / 4.5,
                text: 'Back',
                textColor: Colors.white,
                containerColor: primaryColor,
                onTap: () {
                  context
                      .read<CurrentOrderController>()
                      .resetCurrentOrderController();
                  context.read<OrderListController>().isRefund = false;
                  context
                      .read<RefundOrderController>()
                      .resetRefundOrderController();
                  Navigator.pop(context);
                },
              )
            : BorderContainer(
                width: MediaQuery.of(context).size.width / 4.5,
                text: 'New Order',
                textColor: Colors.white,
                containerColor: primaryColor,
                onTap: () {
                  context
                      .read<CurrentOrderController>()
                      .resetCurrentOrderController();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      ModalRoute.withName("/Home"));
                },
              ),
      ],
    );
  }
}
