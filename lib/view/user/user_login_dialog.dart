import 'package:offline_pos/view/user/user_login_form.dart';

import '../../components/export_files.dart';

class UserLoginDialog {
  static Future<dynamic> loginUserDialogWidget(
    BuildContext mainContext,
  ) {
    final formKey = GlobalKey<FormState>();
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.zero,
          title: const Text(
            'Login User',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: UserLoginForm(
            mainContext: mainContext,
            bContext: bContext,
            formKey: formKey,
          ),
        );
      },
    );
  }
}
