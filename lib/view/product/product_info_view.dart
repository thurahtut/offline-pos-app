import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/product/product_general_info_title.dart';

class ProductInfoView extends StatelessWidget {
  const ProductInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _permissionActionWidget(context),
        SizedBox(height: 15),
        _itemInfoWidget(context),
      ],
    );
  }

  Widget _permissionActionWidget(BuildContext context) {
    var spacer = SizedBox(height: 15);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProductDetailPermissionTitle(),
          spacer,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Product Name',
                      style: TextStyle(
                        color: Constants.textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    spacer,
                    CommonUtils.iconActionButtonWithText(
                      Icons.star_outline_outlined,
                      CommonUtils.demoProduct.productName ?? '',
                      size: 28,
                      textColor: Constants.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8),
                    CheckboxListTile(
                      value: true,
                      onChanged: (bool? value) {},
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      side: MaterialStateBorderSide.resolveWith((_) =>
                          const BorderSide(
                              width: 2, color: Constants.primaryColor)),
                      checkColor: Constants.primaryColor,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      title: Text(
                        'Is bundled?',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  value: true,
                                  onChanged: (bool? value) {},
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  side: MaterialStateBorderSide.resolveWith(
                                      (_) => const BorderSide(
                                          width: 2,
                                          color: Constants.primaryColor)),
                                  checkColor: Constants.primaryColor,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.white),
                                  title: Text(
                                    'Can be sold',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  value: true,
                                  onChanged: (bool? value) {},
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  side: MaterialStateBorderSide.resolveWith(
                                      (_) => const BorderSide(
                                          width: 2,
                                          color: Constants.primaryColor)),
                                  checkColor: Constants.primaryColor,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.white),
                                  title: Text(
                                    'Can be purchased',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  value: true,
                                  onChanged: (bool? value) {},
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  side: MaterialStateBorderSide.resolveWith(
                                      (_) => const BorderSide(
                                          width: 2,
                                          color: Constants.primaryColor)),
                                  checkColor: Constants.primaryColor,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.white),
                                  title: Text(
                                    'Can be manufactured',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          // flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              CommonUtils.svgIconActionButton(
                'assets/svg/broken_image.svg',
                width: 32,
                height: 32,
                withContianer: true,
                containerColor: Constants.calculatorBgColor,
                padding: 30,
                radius: 12,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemInfoWidget(BuildContext context) {
    // bool isTabletMode = CommonUtils.isTabletMode(context);
    // bool isMobileMode = CommonUtils.isMobileMode(context);
    var spacer = SizedBox(height: 6);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductGeneralInfoTitle(),
          spacer,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Product Type")),
                        Expanded(
                            flex: 2,
                            child: _textForDetailInfo('Storable Product')),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Invoicing Policy")),
                        Expanded(
                            flex: 2,
                            child: _textForDetailInfo('Delivered quantities')),
                      ],
                    ),
                    spacer,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Re-Invoice Expenses")),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _eachRadioWidget(
                                text: 'No',
                                value: 0,
                                selected: true,
                                groupValue: 0,
                              ),
                              _eachRadioWidget(
                                text: 'At cost',
                                value: 1,
                                selected: false,
                                groupValue: 0,
                              ),
                              _eachRadioWidget(
                                text: 'Sale Price',
                                value: 2,
                                selected: false,
                                groupValue: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Unit of Measure")),
                        Expanded(flex: 2, child: _textForDetailInfo('Unit')),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Base Unit Count")),
                        Expanded(
                            flex: 2,
                            child: _textForDetailInfo(
                                '1.00 (4,100.00 Ks / Unit)')),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Is secondary Unit?")),
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            value: false,
                            onChanged: (bool? value) {},
                            side: MaterialStateBorderSide.resolveWith((_) =>
                                const BorderSide(
                                    width: 2, color: Constants.primaryColor)),
                            checkColor: Constants.primaryColor,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Purchase UOM")),
                        Expanded(flex: 2, child: _textForDetailInfo('Unit')),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo(
                                "is Commission Based Services ?")),
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            value: false,
                            onChanged: (bool? value) {},
                            side: MaterialStateBorderSide.resolveWith((_) =>
                                const BorderSide(
                                    width: 2, color: Constants.primaryColor)),
                            checkColor: Constants.primaryColor,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    _textForDetailInfo(
                      "Commission Earning",
                      textColor: Constants.disableColor,
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Is third Unit?")),
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            value: false,
                            onChanged: (bool? value) {},
                            side: MaterialStateBorderSide.resolveWith((_) =>
                                const BorderSide(
                                    width: 2, color: Constants.primaryColor)),
                            checkColor: Constants.primaryColor,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Rebate Percentage")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(
                                color: Constants.disableColor.withOpacity(0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Sale Price")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "4100.00 Ks",
                              hintStyle: TextStyle(
                                color: Constants.disableColor.withOpacity(0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Latest Price")),
                        Expanded(
                            flex: 2, child: _textForDetailInfo('3950.00 Ks')),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Latest Price")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            0,
                            [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('AA',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('BB',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Cost")),
                        Expanded(
                            flex: 2,
                            child: _textForDetailInfo('3000.00 Ks per Unit')),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Product Category")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            0,
                            [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('All',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Some',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Product Brands")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            0,
                            [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('All',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Some',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Qty in Bags")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(
                                color: Constants.disableColor.withOpacity(0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Multiple of Qty")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Old Internal Ref:")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "10000002",
                              hintStyle: TextStyle(
                                color: Constants.disableColor.withOpacity(0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Internal Reference")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "10000002",
                              hintStyle: TextStyle(
                                color: Constants.disableColor.withOpacity(0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("BarCode")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "8836000017357",
                              hintStyle: TextStyle(
                                color: Constants.disableColor.withOpacity(0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Is Clearance?")),
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            value: false,
                            onChanged: (bool? value) {},
                            side: MaterialStateBorderSide.resolveWith((_) =>
                                const BorderSide(
                                    width: 2, color: Constants.primaryColor)),
                            checkColor: Constants.primaryColor,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Item Type")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            0,
                            [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Food',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Cosmetics',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Country Code")),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            // controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Allow Negative Stock")),
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            value: false,
                            onChanged: (bool? value) {},
                            side: MaterialStateBorderSide.resolveWith((_) =>
                                const BorderSide(
                                    width: 2, color: Constants.primaryColor)),
                            checkColor: Constants.primaryColor,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Company")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            0,
                            [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('SSS International Co.,Ltd',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Tags")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            0,
                            [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('3000.00 Ks per Unit',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('3200.00 Ks per Unit',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    _textForDetailInfo(
                      "Sale Person",
                      textColor: Constants.disableColor,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),
          spacer,
          _textForDetailInfo(
            "Internal Notes",
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          TextField(
            // controller: controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "This note is only for internal purposes.",
              hintStyle: TextStyle(
                color: Constants.disableColor.withOpacity(0.9),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
              labelStyle: TextStyle(
                color: Constants.primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          // SizedBox(
          //   width: isMobileMode == true
          //       ? MediaQuery.of(context).size.width
          //       : isTabletMode == true
          //           ? MediaQuery.of(context).size.width / 2.5
          //           : MediaQuery.of(context).size.width / 5,
          //   child: CommonUtils.okCancelWidget(
          //     okLabel: 'Save',
          //     cancelLabel: 'Discard',
          //   ),
          // ),
        ],
      ),
    );
  }

  RadioListTile<int> _eachRadioWidget({
    required int value,
    required bool selected,
    required int groupValue,
    required String text,
  }) {
    return RadioListTile(
      value: value,
      selected: selected,
      activeColor: Constants.primaryColor,
      fillColor:
          MaterialStateColor.resolveWith((states) => Constants.primaryColor),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      groupValue: groupValue,
      onChanged: (Object? value) {},
      title: Text(
        text,
        style: TextStyle(
          color: Constants.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _dropDownWidget(
    int selectedValue,
    List<DropdownMenuItem> list,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Constants.greyColor2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
              value: selectedValue,
              icon: SizedBox(),
              underline: Container(),
              items: list,
              onChanged: (v) {},
            ),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _textForDetailInfo(
    String text, {
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
  }) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? Constants.textColor,
        fontSize: fontSize ?? 17,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
