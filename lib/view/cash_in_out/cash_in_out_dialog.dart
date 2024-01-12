import 'package:offline_pos/components/export_files.dart';

class CashInOutDialog {
  static Future<dynamic> cashInOutDialogWidget(
    BuildContext context,
  ) {
    TextEditingController amountTextController = TextEditingController();
    TextEditingController reasonTextController = TextEditingController();
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Container(
              width:
                  MediaQuery.of(context).size.width / (isTabletMode ? 2 : 4.5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width /
                        (isTabletMode ? 2 : 4.5),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: UnconstrainedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BorderContainer(
                            text: 'Cash In',
                            containerColor: Colors.white,
                            textColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 14),
                            textSize: 18,
                            width: 135,
                            onTap: () {},
                          ),
                          SizedBox(width: 10),
                          BorderContainer(
                            text: 'Cash Out',
                            containerColor: Colors.white,
                            textColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 14),
                            textSize: 18,
                            width: 135,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Constants.greyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: amountTextController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: "Ks",
                        hintStyle: TextStyle(
                          color: Constants.disableColor.withOpacity(0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
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
                        hintText: "Enter Reason",
                        hintStyle: TextStyle(
                          color: Constants.disableColor.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
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
                  SizedBox(height: 8),
                  CommonUtils.okCancelWidget(
                    okCallback: () {
                      Navigator.pop(context);
                    },
                    cancelCallback: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      amountTextController.dispose();
      reasonTextController.dispose();
    });
  }
}
