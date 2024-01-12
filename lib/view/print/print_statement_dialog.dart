import 'package:offline_pos/components/export_files.dart';

class PrintStatementDialog {
  static Future<dynamic> printStatementDialogWidget(
    BuildContext mainContext,
  ) {
    Widget spacer = Divider(
      thickness: 1.2,
      color: Constants.disableColor.withOpacity(0.96),
    );
    bool isTabletMode = CommonUtils.isTabletMode(mainContext);
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
          title: const Text(
            'Print Statement',
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
            child: SizedBox(
              width: MediaQuery.of(mainContext).size.width /
                  (isTabletMode ? 2 : 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      spacer,
                      Row(
                        children: [
                          Expanded(
                            child: _radioButtonWidget(
                              value: 1,
                              label: 'Current Sessions',
                              selectedOption: 1,
                              onChanged: (value) {},
                            ),
                          ),
                          Expanded(
                            child: _radioButtonWidget(
                              value: 2,
                              label: 'Between 2 Date',
                              selectedOption: 1,
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(
                            child: _radioButtonWidget(
                              value: 2,
                              label: 'Generate PDF',
                              selectedOption: 1,
                              onChanged: (value) {},
                            ),
                          ),
                          Expanded(
                            child: _radioButtonWidget(
                              value: 2,
                              label: 'Generate Receipt',
                              selectedOption: 1,
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  spacer,
                  CommonUtils.okCancelWidget(
                    switchBtns: true,
                    okCallback: () {
                      Navigator.pop(mainContext);
                    },
                    okLabel: "Print",
                    cancelCallback: () {
                      Navigator.pop(mainContext);
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static ListTile _radioButtonWidget({
    required int value,
    required String label,
    required int selectedOption,
    Function(int? value)? onChanged,
  }) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      leading: Radio<int>(
        value: value,
        groupValue: selectedOption,
        activeColor: primaryColor,
        fillColor: MaterialStateProperty.all(primaryColor),
        splashRadius: 20,
        onChanged: onChanged,
      ),
    );
  }
}
