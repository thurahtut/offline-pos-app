import 'package:offline_pos/components/export_files.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SummaryReportScreen extends StatefulWidget {
  const SummaryReportScreen({super.key});
  static const String routeName = "/summary_report_screen";

  @override
  State<SummaryReportScreen> createState() => _SummaryReportScreenState();
}

class _SummaryReportScreenState extends State<SummaryReportScreen> {
  ByteData? fontData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<SummaryReportController>().resetSummaryReportController();
      context.read<SummaryReportController>().getTotalSummaryByCategory(
          sessionId: context.read<LoginUserController>().posSession?.id ?? 0);

      fontData = await rootBundle.load("assets/font/PyidaungsuRegular.ttf");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.read<SummaryReportController>().resetSummaryReportController();
      },
      child: Scaffold(
        body: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Consumer<SummaryReportController>(builder: (_, controller, __) {
      return Row(
        children: [
          Expanded(flex: 2, child: _receiptWidget(controller)),
          VerticalDivider(width: 2),
          Expanded(child: _otherActionButtons(controller)),
        ],
      );
    });
  }

  Widget _receiptWidget(SummaryReportController controller) {
    return PdfPreview(
      initialPageFormat: PdfPageFormat.roll80,
      allowSharing: false,
      allowPrinting: false,
      canChangeOrientation: false,
      canChangePageFormat: false,
      maxPageWidth: PdfPageFormat.roll80.width * 2.2,
      build: (format) => _generatePdf(controller),
    );
  }

  Future<Uint8List> _generatePdf(SummaryReportController controller) async {
    final doc = pw.Document();
    var spacer = pw.SizedBox(height: 20);

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
                  pw.Text(
                    'SSS International Co.,ltd',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(
                          const Color.fromARGB(255, 151, 137, 137).value),
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
                  pw.Text(
                    'User : ${context.read<LoginUserController>().loginEmployee?.name}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 7,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  pw.Text(
                    'Sale Summary',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#171717"),
                      fontSize: 10.6,
                      fontWeight: pw.FontWeight.bold,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  pw.Text(
                    'Session : ${context.read<LoginUserController>().posSession?.name ?? ''}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 8,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  pw.Text(
                    'From Date : ${CommonUtils.getLocaleDateTime("dd-MM-yyyy hh:mm:ss", DateTime.now().toString())}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 8,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  pw.Text(
                    'To Date : ${CommonUtils.getLocaleDateTime("dd-MM-yyyy hh:mm:ss", DateTime.now().toString())}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(Constants.textColor.value),
                      fontSize: 8,
                      font: fontData != null ? pw.Font.ttf(fontData!) : null,
                    ),
                  ),
                  spacer,
                  ..._saleSummaryWidget(controller),
                  spacer,
                  ..._discountWidget(controller),
                  spacer,
                  ..._refundWidget(),
                  spacer,
                  ..._totalTaxWidget(controller),
                  spacer,
                  ..._netSaleWidget(controller),
                  spacer,
                  ..._paymentTransactionWidget(controller),
                  spacer,
                  ..._transactionSummary(controller),
                  spacer,
                  ..._endWidget(),
                ]),
          );
        },
      ),
    );
    return doc.save();
  }

  List<pw.Widget> _saleSummaryWidget(SummaryReportController controller) {
    List<pw.Widget> list = [
      pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Sale Summary',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontWeight: pw.FontWeight.bold,
              fontSize: 10.2,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )),
    ];
    if (controller.summaryReportMap.isEmpty) {
      return list;
    }

    double totalAmt = controller.summaryReportMap.fold(
        0,
        (sum, item) =>
            sum + (double.tryParse(item['totalAmt']?.toString() ?? '') ?? 0));

    return [
      ...list,
      ...controller.summaryReportMap
          .map(
            (e) => pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        'Total Sale for ${e[POS_CATEGORY_NAME] ?? ''}',
                        textAlign: pw.TextAlign.start,
                        maxLines: 3,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(Constants.textColor.value),
                          fontSize: 8,
                          font:
                              fontData != null ? pw.Font.ttf(fontData!) : null,
                        ),
                      ),
                    ),
                    pw.Text(
                      '${e['totalAmt']?.toString() ?? ''} Ks',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(Constants.textColor.value),
                        fontSize: 8,
                        font: fontData != null ? pw.Font.ttf(fontData!) : null,
                      ),
                    )
                  ],
                )),
          )
          .toList(),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                'Total Sales',
                textAlign: pw.TextAlign.start,
                maxLines: 3,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Colors.black.value),
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  font: fontData != null ? pw.Font.ttf(fontData!) : null,
                ),
              ),
            ),
            pw.Text(
              '$totalAmt Ks',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColor.fromHex("#171717"),
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
                font: fontData != null ? pw.Font.ttf(fontData!) : null,
              ),
            )
          ],
        ),
      ),
    ];
  }

  List<pw.Widget> _discountWidget(SummaryReportController controller) {
    return [
      pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Discounts',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 10.2,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Discount Amount:',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
          pw.Text(
            '${controller.discountMap?['disco'] ?? ''} Ks',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
        ],
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total FOC Discount:',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
          pw.Text(
            '${controller.discountMap?['foc'] ?? ''} Ks',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
        ],
      ),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                'Total Discount:',
                textAlign: pw.TextAlign.start,
                maxLines: 3,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Colors.black.value),
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  font: fontData != null ? pw.Font.ttf(fontData!) : null,
                ),
              ),
            ),
            pw.Text(
              '${(controller.discountMap?['disco'] ?? 0) + (controller.discountMap?['foc'] ?? 0)} Ks',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColor.fromHex("#171717"),
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
                font: fontData != null ? pw.Font.ttf(fontData!) : null,
              ),
            )
          ],
        ),
      ),
    ];
  }

  List<pw.Widget> _refundWidget() {
    return [
      pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Refunds',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 10.2,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total Refund',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
          pw.Text(
            '0.00 Ks',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )
        ],
      ),
    ];
  }

  List<pw.Widget> _totalTaxWidget(SummaryReportController controller) {
    if (controller.summaryReportMap.isEmpty) {
      return [];
    }

    double totalAmt = controller.summaryReportMap.fold(
        0,
        (sum, item) =>
            sum + (double.tryParse(item['totalTax']?.toString() ?? '') ?? 0));

    return [
      pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Tax Collected',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 10.2,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total Tax Collected :',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
          pw.Text(
            '$totalAmt Ks',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constants.textColor.value),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )
        ],
      ),
    ];
  }

  List<pw.Widget> _netSaleWidget(SummaryReportController controller) {
    double totalAmt = controller.summaryReportMap.fold(
        0,
        (sum, item) =>
            sum + (double.tryParse(item['totalAmt']?.toString() ?? '') ?? 0));
    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Net Sales : ',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 10.2,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          ),
          pw.Text(
            '$totalAmt Ks',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 10.2,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )
        ],
      ),
    ];
  }

  List<pw.Widget> _paymentTransactionWidget(SummaryReportController controller,
      {double? openingAmt}) {
    List<pw.Widget> list = [
      if (openingAmt == null)
        pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'Payment Transactions',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColor.fromHex("#171717"),
                fontSize: 10.2,
                fontWeight: pw.FontWeight.bold,
                font: fontData != null ? pw.Font.ttf(fontData!) : null,
              ),
            )),
    ];
    if (controller.transactionReportMap.isEmpty) {
      return list;
    }

    double totalAmt = controller.transactionReportMap.fold(
        0,
        (sum, item) =>
            sum + (double.tryParse(item['tPaid']?.toString() ?? '') ?? 0));
    if (openingAmt != null && openingAmt != 0) {
      totalAmt += openingAmt;
    }

    return [
      ...list,
      ...controller.transactionReportMap
          .map(
            (e) => pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        '${e['name'] ?? ''}',
                        textAlign: pw.TextAlign.start,
                        maxLines: 3,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(Constants.textColor.value),
                          fontSize: 8,
                          font:
                              fontData != null ? pw.Font.ttf(fontData!) : null,
                        ),
                      ),
                    ),
                    pw.Text(
                      '${e['tPaid']?.toString() ?? ''} Ks',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(Constants.textColor.value),
                        fontSize: 8,
                        font: fontData != null ? pw.Font.ttf(fontData!) : null,
                      ),
                    )
                  ],
                )),
          )
          .toList(),
      pw.Divider(
        color: PdfColor.fromHex("#171717"),
        height: 2,
        thickness: 0.4,
      ),
      if (openingAmt != null)
        pw.Divider(
          color: PdfColor.fromHex("#171717"),
          height: 2,
          thickness: 0.4,
        ),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                '${openingAmt != null ? 'Net ' : ''}Total Sales',
                textAlign: pw.TextAlign.start,
                maxLines: 3,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Colors.black.value),
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  font: fontData != null ? pw.Font.ttf(fontData!) : null,
                ),
              ),
            ),
            pw.Text(
              '$totalAmt Ks',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColor.fromHex("#171717"),
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
                font: fontData != null ? pw.Font.ttf(fontData!) : null,
              ),
            )
          ],
        ),
      ),
    ];
  }

  List<pw.Widget> _transactionSummary(SummaryReportController controller) {
    return [
      pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Summary',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#171717"),
              fontSize: 10.2,
              fontWeight: pw.FontWeight.bold,
              font: fontData != null ? pw.Font.ttf(fontData!) : null,
            ),
          )),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                'Opening Cash Amount',
                textAlign: pw.TextAlign.start,
                maxLines: 3,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constants.textColor.value),
                  fontSize: 8,
                  font: fontData != null ? pw.Font.ttf(fontData!) : null,
                ),
              ),
            ),
            pw.Text(
              '${CommonUtils.priceFormat.format(context.read<LoginUserController>().posConfig?.startingAmt ?? 0)} Ks',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColor.fromHex("#171717"),
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
                font: fontData != null ? pw.Font.ttf(fontData!) : null,
              ),
            ),
          ],
        ),
      ),
      ..._paymentTransactionWidget(controller,
          openingAmt:
              context.read<LoginUserController>().posConfig?.startingAmt ?? 0),
    ];
  }

  List<pw.Widget> _endWidget() {
    var starDivider = pw.Row(children: [
      pw.Expanded(
          child: pw.Text(
        '*************************************************************************',
        textAlign: pw.TextAlign.center,
        maxLines: 1,
        style: pw.TextStyle(
          color: PdfColor.fromHex("#171717"),
          fontSize: 10.2,
          fontWeight: pw.FontWeight.bold,
          font: fontData != null ? pw.Font.ttf(fontData!) : null,
        ),
      ))
    ]);
    return [
      starDivider,
      pw.Text(
        'Generated By : ${context.read<LoginUserController>().loginEmployee?.name}',
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColor.fromInt(Constants.textColor.value),
          fontSize: 7,
          font: fontData != null ? pw.Font.ttf(fontData!) : null,
        ),
      ),
      pw.Text(
        CommonUtils.getLocaleDateTime(
            "dd-MM-yyyy hh:mm:ss", DateTime.now().toString()),
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColor.fromInt(Constants.textColor.value),
          fontSize: 8,
          font: fontData != null ? pw.Font.ttf(fontData!) : null,
        ),
      ),
      starDivider,
    ];
  }

  Widget _otherActionButtons(SummaryReportController controller) {
    return Column(
      children: [
        SizedBox(height: 20),
        BorderContainer(
          width: MediaQuery.of(context).size.width / 4.5,
          text: 'Print',
          textColor: Colors.white,
          containerColor: primaryColor,
          onTap: () async {
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
                onLayout: (PdfPageFormat format) async =>
                    _generatePdf(controller),
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
      ],
    );
  }
}
