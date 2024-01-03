import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/user/select_user_screen.dart';

class ChooseCashierDialog {
  static Future<dynamic> chooseCashierDialogWidget(
    BuildContext mainContext,
  ) {
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
            content: SelectUserScreen(
              mainContext: mainContext,
              bContext: bContext,
            ));
      },
    );
  }
}
