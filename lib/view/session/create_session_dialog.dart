import 'package:offline_pos/view/session/close_session_screen.dart';

import '../../components/export_files.dart';

class CreateSessionDialog {
  static Future<dynamic> createSessionDialogWidget(
    BuildContext mainContext,
    bool isOpeningControl,
  ) {
    bool isMobileMode = CommonUtils.isMobileMode(mainContext);
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(16),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            insetPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.all(0),
            title: Container(
              color: Constants.disableColor.withOpacity(0.5),
              height: 70,
              child: Center(
                child: Text(
                  (isOpeningControl
                          ? 'Opening Cash Control'
                          : 'Closing Control')
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SizedBox(
              width: MediaQuery.of(mainContext).size.width /
                  (isMobileMode
                      ? 1
                      : isOpeningControl
                          ? 2
                          : 1.4),
              child: isOpeningControl
                  ? CreateSessionScreen(
                      mainContext: mainContext,
                      bContext: bContext,
                    )
                  : CloseSessionScreen(
                      mainContext: mainContext,
                      bContext: bContext,
                    ),
            ));
      },
    );
  }
}
