import 'package:offline_pos/components/export_files.dart';

class CreateCustomerDialog {
  static List<String> countryList = [
    'Moldova, Republic of',
    'Monaco',
    'Mongolia',
    'Montserrat',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
  ];

  static List<String> regionList = ["Region 1", "Region 2", "Region 3"];
  static List<String> cityList = [
    "Yangon",
    "Lashio",
    "Mandalay",
    "Nay Pyi Taw"
  ];

  static Future<dynamic> createCustomerDialogWidget(
    BuildContext mainContext,
  ) {
    final formKey = GlobalKey<FormState>();
    bool isTabletMode = CommonUtils.isTabletMode(mainContext);

    final TextEditingController nameTextController = TextEditingController();
    final TextEditingController zipTextController = TextEditingController();
    final TextEditingController streetTextController = TextEditingController();
    final TextEditingController mobileTextController = TextEditingController();
    final TextEditingController hotLineTextController = TextEditingController();
    final TextEditingController emailTextController = TextEditingController();
    final TextEditingController discountTextController =
        TextEditingController();
    final TextEditingController barcodeTextController = TextEditingController();
    final TextEditingController textIdTextController = TextEditingController();
    return CommonUtils.showGeneralDialogWidget(
      mainContext,
      (bContext, anim1, anim2) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(mainContext).size.height - 100,
                    maxWidth: (MediaQuery.of(mainContext).size.width / 4) * 3),
                decoration:
                    BoxDecoration(color: Constants.currentOrderDividerColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(
                          left: (MediaQuery.of(mainContext).size.width - 100) /
                              8.7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    fit: StackFit.loose,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Constants.greyColor2
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.account_circle_outlined,
                                          size: 60,
                                          color: Constants.disableColor,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -4,
                                        right: -4,
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Constants.unselectedColor
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(28),
                                          ),
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 22,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 13),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(mainContext).size.width /
                                            6,
                                    child: TextField(
                                      controller: nameTextController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: "Enter Customer Name",
                                        hintStyle: TextStyle(
                                          color: Constants.disableColor
                                              .withOpacity(0.9),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        labelStyle: TextStyle(
                                          color: primaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.all(16),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 1,
                            child: CommonUtils.okCancelWidget(
                              switchBtns: true,
                              okLabel: 'Save',
                              okCallback: () {
                                Navigator.pop(bContext);
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
                    SizedBox(height: 35),
                    Container(
                      width: (MediaQuery.of(mainContext).size.width / 4) * 3,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              (MediaQuery.of(mainContext).size.width - 100) /
                                  10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 31.0),
                              child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(text: "", children: const [
                                  TextSpan(
                                    text: "Limit  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "N/A",
                                    style: TextStyle(
                                      color: Constants.disableColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 31.0),
                              child: Text(
                                'Credit',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              (MediaQuery.of(mainContext).size.width - 100) /
                                  9),
                      child: Divider(
                        color: Constants.disableColor.withOpacity(0.96),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SizedBox(
                        width: (MediaQuery.of(mainContext).size.width / 4) * 3,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: isTabletMode ? 4 : 5.5,
                          padding: EdgeInsets.symmetric(
                              horizontal: isTabletMode
                                  ? 10
                                  : (MediaQuery.of(mainContext).size.width -
                                          100) /
                                      9),
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                          children: [
                            _dropDownWidget(
                              mainContext,
                              countryList,
                            ),
                            _textFieldWidget(
                              mainContext,
                              zipTextController,
                              hintText: "Zip (Optional)",
                            ),
                            _dropDownWidget(
                              mainContext,
                              regionList,
                            ),
                            _textFieldWidget(
                              mainContext,
                              mobileTextController,
                              hintText: "Mobile",
                            ),
                            _dropDownWidget(
                              mainContext,
                              cityList,
                            ),
                            _textFieldWidget(
                              mainContext,
                              streetTextController,
                              hintText: "Street",
                            ),
                            _textFieldWidget(
                              mainContext,
                              hotLineTextController,
                              hintText: "Hot Line",
                            ),
                            _textFieldWidget(
                              mainContext,
                              emailTextController,
                              hintText: "Email",
                            ),
                            _textFieldWidget(
                              mainContext,
                              discountTextController,
                              hintText: "Discount",
                            ),
                            _textFieldWidget(
                              mainContext,
                              barcodeTextController,
                              hintText: "Barcode",
                            ),
                            _textFieldWidget(
                              mainContext,
                              textIdTextController,
                              hintText: "Text ID",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Container _textFieldWidget(
    BuildContext mainContext,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Container(
      height: 60,
      width: MediaQuery.of(mainContext).size.width / 4.8,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Constants.greyColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor, width: 1.7)),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Constants.disableColor.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
            labelStyle: TextStyle(
              color: primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  static _dropDownWidget(
    BuildContext mainContext,
    List<String> list,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(mainContext).size.width / 4.8,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Constants.greyColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor, width: 1.7)),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
              value: list.first,
              icon: SizedBox(),
              underline: Container(),
              items: list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
