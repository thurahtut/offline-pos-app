import 'package:offline_pos/components/export_files.dart';

class CustomerListDialog {
  static Future<Object?> customerListDialogWidget(BuildContext mainContext,
      {bool? rechoose}) {
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: CustomerPaginationTable(
              mainContext: mainContext,
              bContext: bContext,
              rechoose: rechoose,
            ));
      },
    );
  }
}
