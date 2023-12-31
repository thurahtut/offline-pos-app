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
  List<int> byteList = [];
  var myTheme;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // for (int i = 0; i < 2; i++) {
      //   context
      //       .read<CurrentOrderController>()
      //       .currentOrderList
      //       .add(CommonUtils.itemList.first);
      // }
      // myTheme = pw.ThemeData.withFont(
      //   base: pw.Font.ttf(
      //       await rootBundle.load("assets/font/Outfit-Regular.ttf")),
      //   bold: pw.Font.ttf(await rootBundle.load("assets/font/Outfit-Bold.ttf")),
      // );

      // myTheme = pw.ThemeData.withFont(
      //   base: pw.Font.//PdfGoogleFonts.outfitRegular()
      // );

      final ByteData bytes = await rootBundle.load('assets/png/logo_small.png');
      byteList = bytes.buffer.asInt8List();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Row(
      children: [
        if (byteList.isNotEmpty) Expanded(flex: 2, child: _receiptWidget()),
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
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.SizedBox(
                  height: 90,
                  child: pw.Image(
                      pw.MemoryImage(
                        Uint8List.fromList(byteList),
                      ),
                      fit: pw.BoxFit.fitHeight)),
              pw.Text(
                CommonUtils.companyList.first,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 16,
                ),
              ),
              pw.Text(
                'Tel : +959 123 456 789',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 16,
                ),
              ),
              pw.Text(
                'info@gmail.com',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 16,
                ),
              ),
              pw.Text(
                'https://www.google.com',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 16,
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
                  fontSize: 16,
                ),
              ),
              pw.SizedBox(height: 20),
              ...getOrderItem(doc),
              _totalWidget(),
              pw.SizedBox(height: 20),
              _changeWidget(),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  List<pw.Widget> getOrderItem(pw.Document doc) {
    List<pw.Widget> widgets = [];
    for (int i = 0;
        i < context.read<CurrentOrderController>().currentOrderList.length;
        i++) {
      widgets.add(_eachWidget(
          context.read<CurrentOrderController>().currentOrderList[i]));
    }
    return widgets;
  }

  pw.Widget _eachWidget(Product e) {
    pw.TextStyle textStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      // fontWeight: pw.FontWeight.w500,
    );
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          margin: pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(20),
          ),
          child: pw.Center(
            child: pw.Column(children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.RichText(
                      maxLines: 2,
                      // overflow: pw.TextOverflow.ellipsis,
                      text: pw.TextSpan(text: "", children: [
                        // pw.TextSpan(
                        //   text: "[${e["id"]}]",
                        //   style: textStyle.copyWith(
                        //       color: PdfColor.fromInt(
                        //           Constants.successColor.value)),
                        // ),
                        pw.TextSpan(text: e.productName, style: textStyle),
                      ]),
                    ),
                  ),
                  pw.Text("${0} Ks".toString(), //e.price
                      style: textStyle.copyWith(
                        // fontWeight: FontWeight.bold,
                        color: PdfColor.fromInt(Constants.primaryColor.value),
                      ))
                ],
              ),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                pw.Text(
                    "1 Unit at ${0} Ks/Unit with a 0.00 % discount"), //e.price
              ]),
            ]),
          ),
        ),
        // pw.Padding(
        //   padding: const pw.EdgeInsets.symmetric(horizontal: 14.0),
        //   child: pw.Divider(
        //     thickness: 0.6,
        //     height: 6,
        //     color: PdfColor.fromInt(
        //         Constants.disableColor.withOpacity(0.96).value),
        //   ),
        // ),
      ],
    );
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
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "${list.last} Ks",
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 22,
                  // fontWeight: pw.FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _changeWidget() {
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
                  fontSize: 25,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            "300",
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 22,
              // fontWeight: pw.FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherActionButtons() {
    return Column(
      children: [
        SizedBox(height: 20),
        BorderContainer(
          width: MediaQuery.of(context).size.width / 4.5,
          text: 'Print',
          textColor: Colors.white,
          containerColor: Constants.primaryColor,
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
        SizedBox(height: 20),
        BorderContainer(
          width: MediaQuery.of(context).size.width / 4.5,
          text: 'Mail',
          textColor: Constants.primaryColor,
        ),
        SizedBox(height: 20),
        BorderContainer(
          width: MediaQuery.of(context).size.width / 4.5,
          text: 'New Order',
          textColor: Colors.white,
          containerColor: Constants.primaryColor,
          onTap: () {
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
