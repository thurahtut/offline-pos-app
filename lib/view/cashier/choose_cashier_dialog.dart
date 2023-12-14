import 'package:offline_pos/components/export_files.dart';

class ChooseCashierDialog {
  static Future<dynamic> chooseCashierDialogWidget(
    BuildContext mainContext,
    TextEditingController passwordTextController,
  ) {
    Widget spacer = Divider(
      thickness: 1.3,
      color: Constants.disableColor.withOpacity(0.96),
    );

    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
          title: const Text(
            'Change Cashier',
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
                _eachChooseCashierRowWidget(
                  bContext,
                  mainContext,
                  passwordTextController,
                  spacer,
                  'Easy 3 . Store Leader',
                ),
                _eachChooseCashierRowWidget(
                  bContext,
                  mainContext,
                  passwordTextController,
                  spacer,
                  'Easy 3 . Cashier 1',
                ),
                _eachChooseCashierRowWidget(
                  bContext,
                  mainContext,
                  passwordTextController,
                  spacer,
                  'Easy 3 . Cashier 2',
                ),
                spacer,
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(mainContext).size.width / 4,
                  child: UnconstrainedBox(
                    child: BorderContainer(
                      radius: 14,
                      text: 'Cancel',
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      onTap: () {
                        Navigator.of(mainContext).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _eachChooseCashierRowWidget(
      BuildContext dialogContext,
      BuildContext mainContext,
      TextEditingController passwordTextController,
      Widget spacer,
      String text) {
    return InkWell(
      onTap: () {
        Navigator.pop(dialogContext);
        PasswordDialog.enterPasswordWidget(mainContext, passwordTextController);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          spacer,
          SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Text(
              text,
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
