import 'package:offline_pos/components/export_files.dart';

class CustomerListDialog {
  static Future<dynamic> customerListDialogWidget(
    BuildContext mainContext,
  ) {
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
          content: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(mainContext).size.height - 100,
                  maxWidth: MediaQuery.of(mainContext).size.width - 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(mainContext).size.width - 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              BorderContainer(
                                text: 'Load Customers',
                                prefixSvg: 'assets/svg/account_circle.svg',
                                svgColor: Colors.white,
                                width: (MediaQuery.of(mainContext).size.width -
                                        100) /
                                    6,
                                containerColor: Constants.primaryColor,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _searchCustomerWidget()),
                              Expanded(
                                child: CommonUtils.okCancelWidget(
                                  okLabel: 'Create',
                                  switchBtns: true,
                                  cancelContainerColor: Colors.white,
                                  okCallback: () {
                                    Navigator.pop(bContext);
                                    CreateCustomerDialog
                                        .createCustomerDialogWidget(
                                            mainContext);
                                  },
                                  cancelLabel: 'Discard',
                                  cancelCallback: () {
                                    Navigator.pop(bContext);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.of(mainContext).size.height - 200,
                      width: MediaQuery.of(mainContext).size.width - 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)),
                      child: CustomerPaginationTable()),
                ],
              ),
            ),
          ),
        );
      },
    ).then(
        (value) => mainContext.read<ViewController>().isCustomerView = false);
  }

  static Widget _searchCustomerWidget() {
    TextEditingController searchCustomerTextController =
        TextEditingController();
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: searchCustomerTextController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: EdgeInsets.all(22),
            hintText: 'Search Customers',
            hintStyle: TextStyle(fontSize: 14, color: Constants.disableColor),
            filled: true,
            fillColor: Constants.greyColor,
            prefixIcon: UnconstrainedBox(
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(
                  Constants.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
