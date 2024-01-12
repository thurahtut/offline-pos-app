import '../../components/export_files.dart';

class ChooseInventoryDialog {
  static Future<dynamic> chooseInventoryDialogWidget(
    BuildContext mainContext,
  ) {
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(16),
            insetPadding: EdgeInsets.zero,
            title: const Text(
              'Choose Inventory',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SelectInventoryScreen(
              mainContext: mainContext,
              bContext: bContext,
            ));
      },
    );
  }
}
