import 'package:offline_pos/view/user/session_login_form.dart';

import '../../components/export_files.dart';

class SessionLoginDialog {
  static Future<dynamic> sessionLoginDialogWidget(
    BuildContext mainContext,
  ) {
    final formKey = GlobalKey<FormState>();
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.zero,
          title: Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SessionLoginForm(
            mainContext: mainContext,
            bContext: bContext,
            formKey: formKey,
          ),
        );
      },
    );
  }
}
