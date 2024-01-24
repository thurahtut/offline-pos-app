import 'dart:math';

import 'package:offline_pos/components/export_files.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderPaymentReceiptScreen extends StatefulWidget {
  const OrderPaymentReceiptScreen({super.key});
  static const String routeName = "/order_payment_receipt_screen";

  @override
  State<OrderPaymentReceiptScreen> createState() =>
      _OrderPaymentReceiptScreenState();
}

class _OrderPaymentReceiptScreenState extends State<OrderPaymentReceiptScreen> {
  var myTheme;

  ByteData? font;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      font = await rootBundle.load("assets/font/Padauk-Regular.ttf");
      setState(() {});
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
      maxPageWidth: PdfPageFormat.roll80.width * 2,
      pdfPreviewPageDecoration: BoxDecoration(boxShadow: []),
      build: (format) => _generatePdf(),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final doc = pw.Document(
      theme: myTheme,
    );

    doc.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(8),
        build: (pw.Context bContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
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
                CommonUtils.companyList.first,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 20,
                ),
              ),
              pw.Text(
                'Tel : +959 123 456 789',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 20,
                ),
              ),
              pw.Text(
                'info@gmail.com',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 20,
                ),
              ),
              pw.Text(
                'https://www.google.com',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 20,
                ),
              ),
              pw.SizedBox(
                width: 150,
                child: pw.Divider(borderStyle: pw.BorderStyle.dashed),
              ),
              pw.Text(
                'Date : ${DateTime.now().toString()}',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 20,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.SizedBox(
                // width: 150,
                child: pw.Divider(thickness: 2),
              ),
              getHeaderWidget(doc),
              pw.SizedBox(
                // width: 150,
                child: pw.Divider(thickness: 2),
              ),
              ...getOrderItem(doc),
              _totalWidget(),
              pw.SizedBox(height: 20),
              ..._transactionWidget(),
              pw.SizedBox(height: 20),
              _changeWidget(),
              pw.SizedBox(height: 20),
              _totalQtyWidget(),
              pw.SizedBox(height: 20),
              ..._thankYouWidget(),
              pw.SizedBox(height: 40),
              ..._orderIdWidget(),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget getHeaderWidget(pw.Document doc) {
    pw.TextStyle textStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      // fontWeight: pw.FontWeight.w500,
    );
    double maxPageWidth = PdfPageFormat.roll80.width * 2;
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
        width: (maxPageWidth / 8) * 2,
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
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      // fontWeight: pw.FontWeight.w500,
    );
    double maxPageWidth = PdfPageFormat.roll80.width * 2;
    return pw.Row(children: [
      pw.Expanded(
        // width: (maxPageWidth / 8) * 3,
        child: pw.RichText(
          maxLines: 2,
          // overflow: pw.TextOverflow.ellipsis,
          text: pw.TextSpan(text: "", children: [
            pw.TextSpan(
              text: "[${e.productId}]",
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
        width: (maxPageWidth / 8) * 2,
        child: pw.Text(
          "${(e.priceListItem?.fixedPrice ?? 0) * max(e.onhandQuantity ?? 0, 1)} Ks",
          style: textStyle,
        ),
      ),
    ]);
  }

  pw.Widget _totalWidget() {
    List list = context
        .read<CurrentOrderController>()
        .getTotalQty(context.read<CurrentOrderController>().currentOrderList);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14.0),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.SizedBox(
              width: 150,
              child: pw.Divider(
                thickness: 0.6,
                height: 6,
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
                    "Total",
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#171717"),
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "${list.last} Ks",
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 33,
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
    for (var e in context
        .read<CurrentOrderController>()
        .paymentTransactionList
        .values) {
      widgets.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Center(
              child: pw.Text(
                e.paymentMethodName ?? '',
                style: pw.TextStyle(
                  color: PdfColor.fromHex("#171717"),
                fontSize: 20,
                ),
              ),
            ),
          pw.Expanded(
            child: pw.SizedBox(height: 4),
          ),
          pw.Text(
            "${e.amount ?? 0} Ks",
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 20,
              // fontWeight: pw.FontWeight.w400,
            ),
          ),
        ],
      ));
      widgets.add(pw.SizedBox(height: 8));
    }
    return widgets;
  }

  pw.Widget _changeWidget() {
    double totalAmt = context
        .read<CurrentOrderController>()
        .getTotalQty(context.read<CurrentOrderController>().currentOrderList)
        .last;
    double totalPayAmt = 0;

    // ;
    for (var data in context
        .read<CurrentOrderController>()
        .paymentTransactionList
        .values) {
      totalPayAmt += (double.tryParse(data.amount ?? '') ?? 0);
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Expanded(
            child: pw.Center(
              child: pw.Text(
                "Change",
                style: pw.TextStyle(
                  color: PdfColor.fromHex("#171717"),
                  fontSize: 35,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            totalPayAmt > totalAmt ? '${totalPayAmt - totalAmt} Ks' : "0.00K",
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 33,
              // fontWeight: pw.FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _totalQtyWidget() {
    List list = context
        .read<CurrentOrderController>()
        .getTotalQty(context.read<CurrentOrderController>().currentOrderList);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Center(
          child: pw.Text(
            "Total Item : ${context.read<CurrentOrderController>().currentOrderList.length} | Total Qty : ${list.first}",
            style: pw.TextStyle(
              color: PdfColor.fromHex("#262927"),
              fontSize: 26,
            ),
          ),
        ),
        pw.Expanded(child: pw.SizedBox()),
      ],
    );
  }

  List<pw.Widget> _thankYouWidget() {
    double size = 26;
    return [
      pw.Text(
        "Thank you for shopping with us.",
        style: pw.TextStyle(
          color: PdfColor.fromHex("#262927"),
          fontSize: size,
        ),
      ),
      pw.Text(
        "See you again.",
        style: pw.TextStyle(
          color: PdfColor.fromHex("#262927"),
          fontSize: size,
        ),
      ),
      pw.Text(
        "(၀ယ်ပြီးပစ္စည်းပြန်မလဲပေးပါ။)",
        style: pw.TextStyle(
          color: PdfColor.fromHex("#262927"),
          fontSize: size,
          font: font != null ? pw.Font.ttf(font!) : null,
        ),
      ),
      pw.Text(
        "Customer Service Hotline: +959123456789",
        style: pw.TextStyle(
          color: PdfColor.fromHex("#262927"),
          fontSize: size,
        ),
      ),
    ];
  }

  List<pw.Widget> _orderIdWidget() {
    double size = 30;
    return [
      pw.Text(
        context
                .read<CurrentOrderController>()
                .orderHistory
                ?.sequenceNumber
                ?.toString() ??
            '',
        style: pw.TextStyle(
          color: PdfColor.fromHex("#262927"),
          fontSize: size,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        context.read<CurrentOrderController>().orderHistory?.createDate ?? '',
        style: pw.TextStyle(
          color: PdfColor.fromHex("#262927"),
          fontSize: size,
          fontWeight: pw.FontWeight.bold,
        ),
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
            await Printing.directPrintPdf(
              onLayout: (PdfPageFormat format) async => _generatePdf(),
              printer: Printer(url: "Printer-80"),
              format: PdfPageFormat.roll80,
            );
            // }
          },
        ),
        // SizedBox(height: 20),
        // BorderContainer(
        //   width: MediaQuery.of(context).size.width / 4.5,
        //   text: 'Mail',
        //   textColor: primaryColor,
        // ),
        SizedBox(height: 20),
        BorderContainer(
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
