import 'package:offline_pos/components/export_files.dart';

class PaymentDialog {
  static Future<dynamic> paymentDialogWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: const Text(
            'Payments',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width /
                  (isTabletMode ? 1.3 : 2.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(12),
                    height: 70,
                    decoration: BoxDecoration(color: primaryColor),
                    child: _eachPaymentRowWidget(
                      cell1: 'Order',
                      cell2: 'Payment Method',
                      cell3: 'Amount',
                      cell4: 'Date',
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontColor: Colors.white,
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants.calculatorBgColor.withOpacity(0.92),
                    ),
                    child: _eachPaymentRowWidget(
                      cell1: 'Easy 3 - POS 2/12345',
                      cell2: 'Cash Easy 3',
                      cell3: '460,000.00 Ks',
                      cell4: '12-12-2023',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontColor: Constants.textColor.withOpacity(0.92),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants.calculatorBgColor.withOpacity(0.92),
                    ),
                    child: _eachPaymentRowWidget(
                      cell1: 'Easy 3 - POS 2/12345',
                      cell2: 'Cash Easy 3',
                      cell3: '470,000.00 Ks',
                      cell4: '1-1-2023',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontColor: Constants.textColor.withOpacity(0.92),
                    ),
                  ),
                  SizedBox(height: 12),
                  _summaryAmountWidget('Starting Cash : ', 2400000.00),
                  SizedBox(height: 12),
                  _summaryAmountWidget('Transactions : ', 500000.00),
                  SizedBox(height: 12),
                  _summaryAmountWidget('Expected in Cash : ', 2400000.00),
                  SizedBox(height: 12),
                  _summaryAmountWidget('Actual in Cash : ', 0.00),
                  SizedBox(height: 12),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                    child: Divider(
                      thickness: 1.3,
                      color: Constants.disableColor.withOpacity(0.96),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: UnconstrainedBox(
                      child: BorderContainer(
                        width: 100,
                        text: 'Close',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _eachPaymentRowWidget({
    required String cell1,
    required String cell2,
    required String cell3,
    required String cell4,
    double? fontSize,
    FontWeight? fontWeight,
    Color? fontColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _textForRow(
              text: cell1,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontColor: fontColor),
        ),
        Expanded(
          flex: 1,
          child: _textForRow(
              text: cell2,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontColor: fontColor),
        ),
        Expanded(
          flex: 1,
          child: _textForRow(
              text: cell3,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontColor: fontColor),
        ),
        Expanded(
          flex: 1,
          child: _textForRow(
              text: cell4,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontColor: fontColor),
        ),
      ],
    );
  }

  static Text _textForRow({
    required String text,
    double? fontSize,
    FontWeight? fontWeight,
    Color? fontColor,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: fontColor ?? Constants.textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  static Widget _summaryAmountWidget(String text, double? totalAmount) {
    return Row(
      children: [
        Expanded(
          child: _textForRow(
            text: text,
            fontSize: 18,
            fontColor: Constants.textColor,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _textForRow(
            text: '${totalAmount ?? 0} Ks',
            fontSize: 18,
            fontColor: Constants.textColor,
          ),
        ),
      ],
    );
  }
}
