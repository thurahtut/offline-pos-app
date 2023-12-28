import 'package:offline_pos/components/export_files.dart';

class CustomerListDialog {
  static Future<Object?> customerListDialogWidget(
    BuildContext mainContext,
  ) {
    bool isTabletMode = CommonUtils.isTabletMode(mainContext);
    bool isMobileMode = CommonUtils.isMobileMode(mainContext);
    double width = MediaQuery.of(mainContext).size.width;
    double height = MediaQuery.of(mainContext).size.height;
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
                  maxHeight: height - 100, maxWidth: width - 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width - 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              BorderContainer(
                                text: 'Load Customers',
                                prefixSvg: 'assets/svg/account_circle.svg',
                                svgSize: 30,
                                svgColor: Colors.white,
                                width: (width -
                                        100) /
                                    (isMobileMode
                                        ? 3
                                        : isTabletMode
                                            ? 4
                                            : 6),
                                containerColor: Constants.primaryColor,
                                textColor: Colors.white,
                                textSize: (isMobileMode
                                    ? 13
                                    : isTabletMode
                                        ? 14
                                        : 16),
                                radius: 16,
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  textSize: 16,
                                  okCallback: () {
                                    Navigator.pop(bContext, true);
                                    CreateCustomerDialog
                                        .createCustomerDialogWidget(
                                            mainContext);
                                  },
                                  cancelLabel: 'Discard',
                                  cancelCallback: () {
                                    Navigator.pop(bContext, false);
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
                      height: height - 200,
                      width: width - 100,
                      child: CustomerPaginationTable()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _searchCustomerWidget() {
    TextEditingController searchCustomerTextController =
        TextEditingController();
    return Center(
      child: TextField(
        controller: searchCustomerTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    );
  }
}
