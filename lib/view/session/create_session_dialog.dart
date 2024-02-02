import '../../components/export_files.dart';

class CreateSessionDialog {
  static Future<dynamic> createSessionDialogWidget(
    BuildContext mainContext,
  ) {
    bool isMobileMode = CommonUtils.isMobileMode(mainContext);
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(16),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            insetPadding: EdgeInsets.zero,
            title: Text(
              'Opening Cash Control'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SizedBox(
              width: MediaQuery.of(mainContext).size.width /
                  (isMobileMode ? 1 : 2),
              child: CreateSessionScreen(
                mainContext: mainContext,
                bContext: bContext,
              ),
            ));
      },
    );
  }
}
