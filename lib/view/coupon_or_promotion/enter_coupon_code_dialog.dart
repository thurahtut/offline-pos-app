import 'package:offline_pos/components/export_files.dart';

class EnterCouponCodeDialog {
  static Future<dynamic> enterCouponCodeDialogWidget(
    BuildContext mainContext,
  ) {
    Widget spacer = Divider(
      color: Constants.disableColor.withOpacity(0.96),
    );

    final TextEditingController couponTextController = TextEditingController();
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
          title: const Text(
            'Enter Promotion Or Coupon Code',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer,
                SizedBox(height: 10),
                Container(
                  height: 60,
                  width: MediaQuery.of(mainContext).size.width / 4.8,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Constants.greyColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: primaryColor, width: 1.7)),
                  child: Center(
                    child: TextField(
                      controller: couponTextController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Enter Code",
                        hintStyle: TextStyle(
                          color: Constants.disableColor.withOpacity(0.9),
                          // fontSize: 1,
                          fontWeight: FontWeight.w800,
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
                          // fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                CommonUtils.okCancelWidget(
                  switchBtns: true,
                  okCallback: () {
                    Navigator.pop(mainContext);
                  },
                  cancelCallback: () {
                    Navigator.pop(mainContext);
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
