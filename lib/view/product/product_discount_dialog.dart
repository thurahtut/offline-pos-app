import 'package:offline_pos/components/export_files.dart';

class ProductDiscountDialog {
  static List demoList = [
    {
      "percentage_name": "5% Discount",
      "code": 11,
      "value": 49,
    },
    {
      "percentage_name": "10% Discount",
      "code": 12,
      "value": 39,
    },
    {
      "percentage_name": "%15 Discount",
      "code": 13,
      "value": 27,
    },
    {
      "percentage_name": "20% Discount",
      "code": 14,
      "value": 54,
    },
    {
      "percentage_name": "25% Discount",
      "code": 15,
      "value": 45,
    },
    {
      "percentage_name": "30% Discount",
      "code": 16,
      "value": 67,
    },
    {
      "percentage_name": "35% Discount",
      "code": 16,
      "value": 67,
    },
    {
      "percentage_name": "49% Discount",
      "code": 16,
      "value": 67,
    },
    {
      "percentage_name": "55% Discount",
      "code": 16,
      "value": 67,
    },
    {
      "percentage_name": "60% Discount",
      "code": 16,
      "value": 67,
    },
  ];

  static Future<dynamic> productDiscountDialogWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    final TextEditingController reasonTextController = TextEditingController();
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: const Text(
            'Discounts',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width /
                    (isTabletMode ? 1.3 : 2.5),
                maxHeight: MediaQuery.of(context).size.height - 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  height: 70,
                  decoration: BoxDecoration(color: primaryColor),
                  child: _eachDiscountRowWidget(
                    cell1: 'Name',
                    cell2: 'Code',
                    cell3: 'Value(%)',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width /
                            (isTabletMode ? 1.3 : 2.5),
                        child: Column(
                          children: [
                            ...demoList
                                .map(
                                  (e) => Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(12),
                                        // color: Constants.calculatorBgColor.withOpacity(0.92),
                                        ),
                                    child: _eachDiscountRowWidget(
                                      cell1: e["percentage_name"],
                                      cell2: e["code"].toString(),
                                      cell3: e["value"].toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontColor:
                                          Constants.textColor.withOpacity(0.92),
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                  child: Divider(
                    thickness: 1.3,
                    color: Constants.disableColor.withOpacity(0.96),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Reason',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Constants.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: reasonTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CommonUtils.okCancelWidget(
                  okLabel: 'Confirm',
                  width: 140,
                  okCallback: () {
                    Navigator.pop(bContext);
                  },
                  cancelCallback: () {
                    Navigator.pop(bContext);
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _eachDiscountRowWidget({
    required String cell1,
    required String cell2,
    required String cell3,
    double? fontSize,
    FontWeight? fontWeight,
    Color? fontColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
}
