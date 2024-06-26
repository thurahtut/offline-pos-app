import 'package:offline_pos/components/export_files.dart';

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
          // ProductDetailPermissionTitle(),
          // spacer,
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
                    _productNameWidget(context),
                    SizedBox(height: 8),
                    _isBundledWidget(context),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Expanded(
                    //             child: _canBeSoldWidget(context),
                    //           ),
                    //           Expanded(
                    //             child: _canBePurchasedWidget(context),
                    //           ),
                    //           Expanded(
                    //             child: _canBeManufacturedWidget(context),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Expanded(
                    //       // flex: 2,
                    //       child: SizedBox(),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
              // CommonUtils.svgIconActionButton(
              //   'assets/svg/broken_image.svg',
              //   width: 32,
              //   height: 32,
              //   withContianer: true,
              //   containerColor: Constants.calculatorBgColor,
              //   padding: 30,
              //   radius: 12,
              // )
            ],
          ),
        ],
      ),
    );
  }

  Widget _productNameWidget(BuildContext context) {
    return CommonUtils.iconActionButtonWithText(
      Icons.star_outline_outlined,
      context.watch<ProductDetailController>().creatingProduct.productName !=
              null
          ? context.read<ProductDetailController>().creatingProduct.productName!
          : '',
      size: 28,
      textColor: Constants.textColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  CheckboxListTile _isBundledWidget(BuildContext context) {
    return CheckboxListTile(
      value:
          // context.watch<ProductDetailController>().creatingProduct.shIsBundle ??
          false,
      onChanged: (bool? value) {},
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      side: MaterialStateBorderSide.resolveWith(
          (_) => BorderSide(width: 2, color: primaryColor)),
      checkColor: primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      title: Text(
        'Is bundled?',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  // CheckboxListTile _canBeSoldWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value:
  //         context.watch<ProductDetailController>().creatingProduct.canBeSold ??
  //             false,
  //     onChanged: (bool? value) {},
  //     contentPadding: EdgeInsets.zero,
  //     controlAffinity: ListTileControlAffinity.leading,
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     title: Text(
  //       'Can be sold',
  //       style: TextStyle(fontSize: 13),
  //     ),
  //   );
  // }

  // CheckboxListTile _canBePurchasedWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .canBePurchased ??
  //         false,
  //     onChanged: (bool? value) {},
  //     contentPadding: EdgeInsets.zero,
  //     controlAffinity: ListTileControlAffinity.leading,
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     title: Text(
  //       'Can be purchased',
  //       style: TextStyle(fontSize: 13),
  //     ),
  //   );
  // }

  // CheckboxListTile _canBeManufacturedWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .canBeManufactured ??
  //         false,
  //     onChanged: (bool? value) {},
  //     contentPadding: EdgeInsets.zero,
  //     controlAffinity: ListTileControlAffinity.leading,
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     title: Text(
  //       'Can be manufactured',
  //       style: TextStyle(fontSize: 13),
  //     ),
  //   );
  // }

  Widget _itemInfoWidget(BuildContext context) {
    // bool isTabletMode = CommonUtils.isTabletMode(context);
    // bool isMobileMode = CommonUtils.isMobileMode(context);
    var spacer = SizedBox(height: 6);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductGeneralInfoTitle(),
          spacer,
          context.watch<ProductDetailController>().isBarcodeView
              ? Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("BarCode")),
                          Expanded(
                            flex: 2,
                            child: _barcodeWidget(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Product Type")),
                          //     Expanded(flex: 2, child: _productTypeWidget(context)),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Invoicing Policy")),
                          //     Expanded(
                          //         flex: 2, child: _invoicingPolicyWidget(context)),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Expanded(
                          //         child: _textForDetailInfo("Re-Invoice Expenses")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _reInvoiceExpensesWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Unit of Measure")),
                          //     Expanded(flex: 2, child: _unitOfMeasureWidget(context)),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Base Unit Count")),
                          //     Expanded(flex: 2, child: _baseUnitCountWidget(context)),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(
                          //         child: _textForDetailInfo("Is secondary Unit?")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _isSecondaryUnit(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Purchase UOM")),
                          //     Expanded(flex: 2, child: _purchaseUOMWidget(context)),
                          //   ],
                          // ),
                          // spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //               child: _textForDetailInfo(
                          //                   "is Commission Based Services ?")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _isCommissionBasedServicesWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       _textForDetailInfo(
                          //         "Commission Earning",
                          //         textColor: Constants.disableColor,
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Is third Unit?")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _isThirdUnitWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //               child: _textForDetailInfo("Rebate Percentage")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _rebatePercentageWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Sale Price")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _salePriceWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Latest Price")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _latestPriceWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Cost")),
                          //           Expanded(flex: 2, child: _costWidget(context)),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Product Category")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _productCategoryWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Product Brands")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _productBrandsWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Qty in Bags")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _qtyInBagsWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          //       Row(
                          //         children: [
                          //           Expanded(child: _textForDetailInfo("Multiple of Qty")),
                          //           Expanded(
                          //             flex: 2,
                          //             child: _multipleOfQtyWidget(context),
                          //           ),
                          //         ],
                          //       ),
                          //       spacer,
                          // Row(
                          //   children: [
                          //     Expanded(
                          //         child:
                          //             _textForDetailInfo("Old Internal Ref:")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _oldInternalRefWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          Row(
                            children: [
                              Expanded(
                                  child:
                                      _textForDetailInfo("Internal Reference")),
                              Expanded(
                                flex: 2,
                                child: _internalReferenceWidget(context),
                              ),
                            ],
                          ),
                          spacer,
                          Row(
                            children: [
                              Expanded(
                                  child: _textForDetailInfo("Odoo Product Id")),
                              Expanded(
                                flex: 2,
                                child: _productIdWidget(context),
                              ),
                            ],
                          ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("BarCode")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _barcodeWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Is Clearance?")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _isClearanceWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Item Type")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _itemTypeWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Country Code")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _countryCodeWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(
                          //         child: _textForDetailInfo("Allow Negative Stock")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _allowNegativeStockWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Company")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _companyWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // Row(
                          //   children: [
                          //     Expanded(child: _textForDetailInfo("Tags")),
                          //     Expanded(
                          //       flex: 2,
                          //       child: _tagsWidget(context),
                          //     ),
                          //   ],
                          // ),
                          // spacer,
                          // _textForDetailInfo(
                          //   "Sale Person",
                          //   textColor: Constants.disableColor,
                          //   fontSize: 13,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
          spacer,
          if (!context.read<ProductDetailController>().isBarcodeView)
            _textForDetailInfo(
              "Internal Notes",
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          if (!context.read<ProductDetailController>().isBarcodeView)
            _internalNotesWidget(context),
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

  // Widget _productTypeWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context.watch<ProductDetailController>().creatingProduct.productType !=
  //             null
  //         ? context
  //                 .read<ProductDetailController>()
  //                 .creatingProduct
  //                 .productType
  //                 ?.name ??
  //             ProductType.consumable.name
  //         : ProductType.consumable.name,
  //     ProductType.values
  //         .map((e) => DropdownMenuItem(
  //               value: e.name,
  //               child: Text(e.name,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             ))
  //         .toList(),
  //   );
  // }

  // Widget _invoicingPolicyWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context
  //                 .watch<ProductDetailController>()
  //                 .creatingProduct
  //                 .invoicingPolicy !=
  //             null
  //         ? context
  //                 .read<ProductDetailController>()
  //                 .creatingProduct
  //                 .invoicingPolicy
  //                 ?.name ??
  //             InvoicingPolicy.orderedQuantities.name
  //         : InvoicingPolicy.orderedQuantities.name,
  //     InvoicingPolicy.values
  //         .map((e) => DropdownMenuItem(
  //               value: e.name,
  //               child: Text(e.name,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             ))
  //         .toList(),
  //   );
  // }

  // Column _reInvoiceExpensesWidget(BuildContext context) {
  //   return Column(
  //     children: ReInvoiceExpenses.values.map((e) {
  //       return _eachRadioWidget(
  //         text: e.text,
  //         value: e.index,
  //         groupValue: (context
  //                         .watch<ProductDetailController>()
  //                         .creatingProduct
  //                         .reInvoiceExpenses ??
  //                     '') ==
  //                 e
  //             ? e.index
  //             : -1,
  //       );
  //     }).toList(),
  //   );
  // }

  // Widget _unitOfMeasureWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context.watch<ProductDetailController>().creatingProduct.unitOfMeasure !=
  //                 null &&
  //             CommonUtils.unitList.indexWhere((element) =>
  //                     element ==
  //                     context
  //                         .read<ProductDetailController>()
  //                         .creatingProduct
  //                         .unitOfMeasure) !=
  //                 -1
  //         ? CommonUtils.unitList
  //             .indexWhere((element) =>
  //                 element ==
  //                 context
  //                     .read<ProductDetailController>()
  //                     .creatingProduct
  //                     .unitOfMeasure)
  //             .toString()
  //         : '0',
  //     CommonUtils.unitList
  //         .asMap()
  //         .map((i, e) => MapEntry(
  //             i,
  //             DropdownMenuItem(
  //               value: i.toString(),
  //               child: Text(e,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             )))
  //         .values
  //         .toList(),
  //   );
  // }

  // Widget _baseUnitCountWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .baseUnitCount
  //             ?.toString() ??
  //         '',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       hintText: "0.00",
  //       hintStyle: TextStyle(
  //         color: Constants.disableColor.withOpacity(0.9),
  //         fontSize: 15,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // CheckboxListTile _isSecondaryUnit(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .isSecondaryUnit ??
  //         false,
  //     onChanged: null,
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     controlAffinity: ListTileControlAffinity.leading,
  //     contentPadding: EdgeInsets.zero,
  //   );
  // }

  // Widget _purchaseUOMWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context.watch<ProductDetailController>().creatingProduct.purchaseUOM !=
  //                 null &&
  //             CommonUtils.unitList.indexWhere((element) =>
  //                     element ==
  //                     context
  //                         .read<ProductDetailController>()
  //                         .creatingProduct
  //                         .purchaseUOM) !=
  //                 -1
  //         ? CommonUtils.unitList
  //             .indexWhere((element) =>
  //                 element ==
  //                 context
  //                     .read<ProductDetailController>()
  //                     .creatingProduct
  //                     .purchaseUOM)
  //             .toString()
  //         : '0',
  //     CommonUtils.unitList
  //         .asMap()
  //         .map((i, e) => MapEntry(
  //             i,
  //             DropdownMenuItem(
  //               value: i.toString(),
  //               child: Text(e,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             )))
  //         .values
  //         .toList(),
  //   );
  // }

  // CheckboxListTile _isCommissionBasedServicesWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .isCommissionBasedServices ??
  //         false,
  //     onChanged: null,
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     controlAffinity: ListTileControlAffinity.leading,
  //     contentPadding: EdgeInsets.zero,
  //   );
  // }

  // CheckboxListTile _isThirdUnitWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .isThirdUnit ??
  //         false,
  //     onChanged: null,
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     controlAffinity: ListTileControlAffinity.leading,
  //     contentPadding: EdgeInsets.zero,
  //   );
  // }

  // Widget _rebatePercentageWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .rebatePercentage
  //             ?.toString() ??
  //         '',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // Widget _salePriceWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .salePrice
  //             ?.toString() ??
  //         '0.00',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       suffixIcon: Text('Ks'),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // Widget _latestPriceWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .latestPrice
  //             ?.toString() ??
  //         '0.00',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //       suffixIcon: Text('Ks'),
  //     ),
  //   );
  // }

  // Widget _costWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .price
  //             ?.toString() ??
  //         '0.00',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //       suffixIcon: Text('Ks'),
  //     ),
  //   );
  // }

  // Widget _productCategoryWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context
  //                     .watch<ProductDetailController>()
  //                     .creatingProduct
  //                     .productCategory !=
  //                 null &&
  //             CommonUtils.categoryList.indexWhere((element) =>
  //                     element ==
  //                     context
  //                         .read<ProductDetailController>()
  //                         .creatingProduct
  //                         .productCategory) !=
  //                 -1
  //         ? CommonUtils.categoryList
  //             .indexWhere((element) =>
  //                 element ==
  //                 context
  //                     .read<ProductDetailController>()
  //                     .creatingProduct
  //                     .productCategory)
  //             .toString()
  //         : '0',
  //     CommonUtils.categoryList
  //         .asMap()
  //         .map((i, e) => MapEntry(
  //             i,
  //             DropdownMenuItem(
  //               value: i.toString(),
  //               child: Text(e,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             )))
  //         .values
  //         .toList(),
  //   );
  // }

  // Widget _productBrandsWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context.watch<ProductDetailController>().creatingProduct.productBrand !=
  //                 null &&
  //             CommonUtils.brandList.indexWhere((element) =>
  //                     element ==
  //                     context
  //                         .read<ProductDetailController>()
  //                         .creatingProduct
  //                         .productBrand) !=
  //                 -1
  //         ? CommonUtils.brandList
  //             .indexWhere((element) =>
  //                 element ==
  //                 context
  //                     .read<ProductDetailController>()
  //                     .creatingProduct
  //                     .productBrand)
  //             .toString()
  //         : '0',
  //     CommonUtils.brandList
  //         .asMap()
  //         .map((i, e) => MapEntry(
  //             i,
  //             DropdownMenuItem(
  //               value: i.toString(),
  //               child: Text(e,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             )))
  //         .values
  //         .toList(),
  //   );
  // }

  // Widget _qtyInBagsWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .qtyInBags
  //             ?.toString() ??
  //         '0.00',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // Widget _multipleOfQtyWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .multipleOfQty
  //             ?.toString() ??
  //         '0.00',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // Widget _oldInternalRefWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .oldInternalRef
  //             ?.toString() ??
  //         '',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  Widget _productIdWidget(BuildContext context) {
    return TextFormField(
      initialValue: context
              .read<ProductDetailController>()
              .creatingProduct
              .productId
              ?.toString() ??
          '',
      enabled: false,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Constants.textColor),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  Widget _internalReferenceWidget(BuildContext context) {
    return TextFormField(
      initialValue:
          // context
          //         .read<ProductDetailController>()
          //         .creatingProduct
          //         .internalRef
          //         ?.toString() ??
          '',
      enabled: false,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Constants.textColor),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  Widget _barcodeWidget(BuildContext context) {
    return TextFormField(
      initialValue: context
              .read<ProductDetailController>()
              .creatingProduct
              .barcode
              ?.toString() ??
          '',
      enabled: false,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Constants.textColor),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  // CheckboxListTile _isClearanceWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .isClearance ??
  //         false,
  //     onChanged: (bool? value) {},
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     controlAffinity: ListTileControlAffinity.leading,
  //     contentPadding: EdgeInsets.zero,
  //   );
  // }

  // Widget _itemTypeWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context.watch<ProductDetailController>().creatingProduct.itemType !=
  //                 null &&
  //             ItemType.values.indexWhere((element) =>
  //                     element.text ==
  //                     context
  //                         .read<ProductDetailController>()
  //                         .creatingProduct
  //                         .itemType!
  //                         .text) !=
  //                 -1
  //         ? ItemType.values
  //             .indexWhere((element) =>
  //                 element.text ==
  //                 context
  //                     .read<ProductDetailController>()
  //                     .creatingProduct
  //                     .itemType!
  //                     .text)
  //             .toString()
  //         : '0',
  //     ItemType.values
  //         .map((e) => DropdownMenuItem(
  //               value: e.index.toString(),
  //               child: Text(e.text,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             ))
  //         .toList(),
  //   );
  // }

  // Widget _countryCodeWidget(BuildContext context) {
  //   return TextFormField(
  //     initialValue: context
  //             .read<ProductDetailController>()
  //             .creatingProduct
  //             .countryCode
  //             ?.toString() ??
  //         '',
  //     enabled: false,
  //     textAlignVertical: TextAlignVertical.center,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelStyle: TextStyle(
  //         color: primaryColor,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w800,
  //       ),
  //       border: UnderlineInputBorder(),
  //       contentPadding: EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // CheckboxListTile _allowNegativeStockWidget(BuildContext context) {
  //   return CheckboxListTile(
  //     value: context
  //             .watch<ProductDetailController>()
  //             .creatingProduct
  //             .allowNegativeStock ??
  //         false,
  //     onChanged: (bool? value) {},
  //     side: MaterialStateBorderSide.resolveWith(
  //         (_) => const BorderSide(width: 2, color: primaryColor)),
  //     checkColor: primaryColor,
  //     fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  //     controlAffinity: ListTileControlAffinity.leading,
  //     contentPadding: EdgeInsets.zero,
  //   );
  // }

  // Widget _companyWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     context.watch<ProductDetailController>().creatingProduct.company !=
  //                 null &&
  //             CommonUtils.companyList.indexWhere((element) =>
  //                     element ==
  //                     context
  //                         .read<ProductDetailController>()
  //                         .creatingProduct
  //                         .company) !=
  //                 -1
  //         ? CommonUtils.companyList
  //             .indexWhere((element) =>
  //                 element ==
  //                 context
  //                     .read<ProductDetailController>()
  //                     .creatingProduct
  //                     .company)
  //             .toString()
  //         : '0',
  //     CommonUtils.companyList
  //         .asMap()
  //         .map((i, e) => MapEntry(
  //             i,
  //             DropdownMenuItem(
  //               value: i.toString(),
  //               child: Text(e,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //             )))
  //         .values
  //         .toList(),
  //   );
  // }

  // Widget _tagsWidget(BuildContext context) {
  //   return _dropDownWidget(
  //     '0',
  //     [
  //       DropdownMenuItem(
  //         value: 0.toString(),
  //         child: Text('3000.00 Ks per Unit',
  //             style: TextStyle(
  //               color: Colors.black,
  //             )),
  //       ),
  //       DropdownMenuItem(
  //         value: 1.toString(),
  //         child: Text('3200.00 Ks per Unit',
  //             style: TextStyle(
  //               color: Colors.black,
  //             )),
  //       ),
  //     ],
  //   );
  // }

  Widget _internalNotesWidget(BuildContext context) {
    return TextFormField(
      initialValue:
          // context
          //         .read<ProductDetailController>()
          //         .creatingProduct
          //         .internalNotes
          //         ?.toString() ??
          '',
      enabled: false,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Constants.textColor),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  RadioListTile<int> _eachRadioWidget({
    required int value,
    required int groupValue,
    required String text,
  }) {
    return RadioListTile(
      value: value,
      activeColor: primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => primaryColor),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      groupValue: groupValue,
      onChanged: null,
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
    String selectedValue,
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
              onChanged: null,
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
