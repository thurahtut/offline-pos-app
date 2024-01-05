import 'package:offline_pos/components/export_files.dart';

class ProductCreateOrEditScreen extends StatefulWidget {
  const ProductCreateOrEditScreen({super.key});
  static const String routeName = "/product_create_or_edit_screen";

  @override
  State<ProductCreateOrEditScreen> createState() =>
      _ProductCreateOrEditScreenState();
}

class _ProductCreateOrEditScreenState extends State<ProductCreateOrEditScreen> {
  final TextEditingController _productNameTextController =
      TextEditingController();
  final TextEditingController _baseUnitCountTextController =
      TextEditingController();
  final TextEditingController _internalNoteTextController =
      TextEditingController();
  final TextEditingController _countryCodeTextController =
      TextEditingController();
  final TextEditingController _barcodeTextController = TextEditingController();
  final TextEditingController _oldInternalReferenceTextController =
      TextEditingController();
  final TextEditingController _internalReferenceTextController =
      TextEditingController();
  final TextEditingController _multipleOfQtyTextController =
      TextEditingController();
  final TextEditingController _qtyInBagsTextController =
      TextEditingController();
  final TextEditingController _salePriceTextController =
      TextEditingController();
  final TextEditingController _latestPriceTextController =
      TextEditingController();
  final TextEditingController _costTextController = TextEditingController();
  final TextEditingController _rebatePercentageTextController =
      TextEditingController();
  bool? isTabletMode;
  bool? isMobileMode;

  @override
  void dispose() {
    _productNameTextController.dispose();
    _baseUnitCountTextController.dispose();
    _internalNoteTextController.dispose();
    _countryCodeTextController.dispose();
    _barcodeTextController.dispose();
    _oldInternalReferenceTextController.dispose();
    _internalReferenceTextController.dispose();
    _multipleOfQtyTextController.dispose();
    _qtyInBagsTextController.dispose();
    _salePriceTextController.dispose();
    _latestPriceTextController.dispose();
    _costTextController.dispose();
    _rebatePercentageTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      _productNameTextController.text =
          context.read<ProductDetailController>().creatingProduct.productName ??
              '';
      _baseUnitCountTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .baseUnitCount
              ?.toString() ??
          '';
      _internalNoteTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .internalNotes ??
          '';
      _countryCodeTextController.text =
          context.read<ProductDetailController>().creatingProduct.countryCode ??
              '';
      _barcodeTextController.text =
          context.read<ProductDetailController>().creatingProduct.barcode ?? '';
      _oldInternalReferenceTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .oldInternalRef ??
          '';
      _internalReferenceTextController.text =
          context.read<ProductDetailController>().creatingProduct.internalRef ??
              '';
      _multipleOfQtyTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .multipleOfQty
              ?.toString() ??
          '';
      _qtyInBagsTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .qtyInBags
              ?.toString() ??
          '';
      _salePriceTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .salePrice
              ?.toString() ??
          '';
      _latestPriceTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .latestPrice
              ?.toString() ??
          '';
      _costTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .price
              ?.toString() ??
          '';
      _rebatePercentageTextController.text = context
              .read<ProductDetailController>()
              .creatingProduct
              .rebatePercentage
              ?.toString() ??
          '';
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: context.read<ProductDetailController>().formKey,
        child: Column(
          children: [
            _permissionActionWidget(context),
            SizedBox(height: 15),
            _itemInfoWidget(context),
          ],
        ));
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
                    Row(
                      children: [
                        CommonUtils.iconActionButton(
                          Icons.star_outline_outlined,
                          size: 28,
                        ),
                        Expanded(
                          child: _productNameWidget(),
                        ),
                        if (isMobileMode != true)
                          Expanded(flex: 2, child: SizedBox()),
                      ],
                    ),
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
              CommonUtils.svgIconActionButton(
                'assets/svg/add_a_photo.svg',
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

  Widget _productNameWidget() {
    return TextFormField(
      controller: _productNameTextController,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: "e.g. Cheese Burger",
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the product name!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.productName =
            newValue;
      },
    );
  }

  CheckboxListTile _isBundledWidget(BuildContext context) {
    return CheckboxListTile(
      value:
          context.watch<ProductDetailController>().creatingProduct.isBundled ??
              false,
      onChanged: (bool? value) {
        context.read<ProductDetailController>().creatingProduct.isBundled =
            !(context
                    .read<ProductDetailController>()
                    .creatingProduct
                    .isBundled ??
                false);
        context.read<ProductDetailController>().notify();
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      title: Text(
        'Is bundled?',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  CheckboxListTile _canBeSoldWidget(BuildContext context) {
    return CheckboxListTile(
      value:
          context.watch<ProductDetailController>().creatingProduct.canBeSold ??
              false,
      onChanged: (bool? value) {
        context.read<ProductDetailController>().creatingProduct.canBeSold =
            !(context
                    .read<ProductDetailController>()
                    .creatingProduct
                    .canBeSold ??
                false);
        context.read<ProductDetailController>().notify();
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      title: Text(
        'Can be sold',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  CheckboxListTile _canBePurchasedWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .canBePurchased ??
          false,
      onChanged: (bool? value) {
        context.read<ProductDetailController>().creatingProduct.canBePurchased =
            !(context
                    .read<ProductDetailController>()
                    .creatingProduct
                    .canBePurchased ??
                false);
        context.read<ProductDetailController>().notify();
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      title: Text(
        'Can be purchased',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  CheckboxListTile _canBeManufacturedWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .canBeManufactured ??
          false,
      onChanged: (bool? value) {
        context
            .read<ProductDetailController>()
            .creatingProduct
            .canBeManufactured = !(context
                .read<ProductDetailController>()
                .creatingProduct
                .canBeManufactured ??
            false);
        context.read<ProductDetailController>().notify();
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      title: Text(
        'Can be manufactured',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _itemInfoWidget(BuildContext context) {
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
                  child: Container(
                    child: BarcodeWidget(
                      data: context
                              .read<ProductDetailController>()
                              .creatingProduct
                              .barcode ??
                          'Offline_POS',
                      drawText: false,
                      barcode: Barcode.code128(),
                      width: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.width < 700 ? 4 : 8),
                      height: MediaQuery.of(context).size.height / 10,
                    ),
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
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Product Type")),
                        Expanded(
                          flex: 2,
                          child: _productTypeWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Invoicing Policy")),
                        Expanded(
                          flex: 2,
                          child: _invoicePolicyWidget(context),
                        ),
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
                          child: _reInvoiceExpensesWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Unit of Measure")),
                        Expanded(
                          flex: 2,
                          child: _unitOfMeasureWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Base Unit Count")),
                        Expanded(
                          flex: 2,
                          child: _baseUnitCountWidget(),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                            child: _textForDetailInfo("Is secondary Unit?")),
                        Expanded(
                          flex: 2,
                          child: _isSecondaryUnitWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Purchase UOM")),
                        Expanded(
                          flex: 2,
                          child: _purchaseUOMWidget(context),
                        ),
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
                          child: _isCommissionBasedServicesWidget(context),
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
                          child: _isThirdUnitWidget(context),
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
                          child: _rebatePercentageWidget(),
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
                          child: _salePriceWidget(),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Latest Price")),
                        Expanded(
                          flex: 2,
                          child: _latestPriceWidget(),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Cost")),
                        Expanded(flex: 2, child: _costWidget()),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Product Category")),
                        Expanded(
                          flex: 2,
                          child: _productCategoryWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Product Brands")),
                        Expanded(
                          flex: 2,
                          child: _productBrandsWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Qty in Bags")),
                        Expanded(
                          flex: 2,
                          child: _qtyInBagsWidget(),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Multiple of Qty")),
                        Expanded(
                          flex: 2,
                          child: _multipleOfQtyWidget(),
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
                          child: _oldInternalRef(),
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
                          child: _internalReferenceWidget(),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("BarCode")),
                        Expanded(
                          flex: 2,
                          child: _barcodeWidget(),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Is Clearance?")),
                        Expanded(
                          flex: 2,
                          child: _isClearanceWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Item Type")),
                        Expanded(
                          flex: 2,
                          child: _itemTypeWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Country Code")),
                        Expanded(
                          flex: 2,
                          child: _countryCodeWidget(),
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
                          child: _allowNegativeStockWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Company")),
                        Expanded(
                          flex: 2,
                          child: _companyWidget(context),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Tags")),
                        Expanded(
                          flex: 2,
                          child: _tagsWidget(),
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
          if (!context.read<ProductDetailController>().isBarcodeView)
            _textForDetailInfo(
            "Internal Notes",
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          if (!context.read<ProductDetailController>().isBarcodeView)
            _internalNoteWidget(),
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

  Widget _productTypeWidget(BuildContext context) {
    return _dropDownWidget(
      context.watch<ProductDetailController>().creatingProduct.productType !=
              null
          ? context
                  .read<ProductDetailController>()
                  .creatingProduct
                  .productType
                  ?.name ??
              ProductType.consumable.name
          : ProductType.consumable.name,
      ProductType.values
          .map((e) => DropdownMenuItem(
                value: e.name,
                child: Text(e.name,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ))
          .toList(),
      onChanged: (p0) {
        int index =
            ProductType.values.indexWhere((element) => element.name == p0);
        if (index != -1) {
          context.read<ProductDetailController>().creatingProduct.productType =
              ProductType.values.elementAt(index);
          context.read<ProductDetailController>().notify();
        }
      },
    );
  }

  Widget _invoicePolicyWidget(BuildContext context) {
    return _dropDownWidget(
      context
                  .watch<ProductDetailController>()
                  .creatingProduct
                  .invoicingPolicy !=
              null
          ? context
                  .read<ProductDetailController>()
                  .creatingProduct
                  .invoicingPolicy
                  ?.name ??
              InvoicingPolicy.orderedQuantities.name
          : InvoicingPolicy.orderedQuantities.name,
      InvoicingPolicy.values
          .map((e) => DropdownMenuItem(
                value: e.name,
                child: Text(e.name,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ))
          .toList(),
      onChanged: (p0) {
        int index =
            InvoicingPolicy.values.indexWhere((element) => element.name == p0);
        if (index != -1) {
          context
              .read<ProductDetailController>()
              .creatingProduct
              .invoicingPolicy = InvoicingPolicy.values.elementAt(index);
          context.read<ProductDetailController>().notify();
        }
      },
    );
  }

  Column _reInvoiceExpensesWidget(BuildContext context) {
    return Column(
      children: ReInvoiceExpenses.values.map((e) {
        return _eachRadioWidget(
          text: e.text,
          value: e.index,
          groupValue: (context
                          .watch<ProductDetailController>()
                          .creatingProduct
                          .reInvoiceExpenses ??
                      '') ==
                  e
              ? e.index
              : -1,
          onChanged: (value) {
            if (value != null) {
              context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .reInvoiceExpenses =
                  ReInvoiceExpenses.values.elementAt(value);
              context.read<ProductDetailController>().notify();
            }
          },
        );
      }).toList(),
    );
  }

  Widget _unitOfMeasureWidget(BuildContext context) {
    return _dropDownWidget(
      context.watch<ProductDetailController>().creatingProduct.unitOfMeasure !=
                  null &&
              CommonUtils.unitList.indexWhere((element) =>
                      element ==
                      context
                          .read<ProductDetailController>()
                          .creatingProduct
                          .unitOfMeasure) !=
                  -1
          ? CommonUtils.unitList
              .indexWhere((element) =>
                  element ==
                  context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .unitOfMeasure)
              .toString()
          : '0',
      CommonUtils.unitList
          .asMap()
          .map((i, e) => MapEntry(
              i,
              DropdownMenuItem(
                value: i.toString(),
                child: Text(e,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )))
          .values
          .toList(),
      onChanged: (p0) {
        context.read<ProductDetailController>().creatingProduct.unitOfMeasure =
            CommonUtils.unitList.elementAt(int.tryParse(p0) ?? 0);
        context.read<ProductDetailController>().notify();
      },
    );
  }

  Widget _baseUnitCountWidget() {
    return TextFormField(
      controller: _baseUnitCountTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
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
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return "Please enter the valid base unit count!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.baseUnitCount =
            double.tryParse(newValue!);
      },
    );
  }

  CheckboxListTile _isSecondaryUnitWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .isSecondaryUnit ??
          false,
      onChanged: (bool? value) {
        context
            .read<ProductDetailController>()
            .creatingProduct
            .isSecondaryUnit = !(context
                .read<ProductDetailController>()
                .creatingProduct
                .isSecondaryUnit ??
            false);
        context.read<ProductDetailController>().notify();
      },
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _purchaseUOMWidget(BuildContext context) {
    return _dropDownWidget(
      context.watch<ProductDetailController>().creatingProduct.purchaseUOM !=
                  null &&
              CommonUtils.unitList.indexWhere((element) =>
                      element ==
                      context
                          .read<ProductDetailController>()
                          .creatingProduct
                          .purchaseUOM) !=
                  -1
          ? CommonUtils.unitList
              .indexWhere((element) =>
                  element ==
                  context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .purchaseUOM)
              .toString()
          : '0',
      CommonUtils.unitList
          .asMap()
          .map((i, e) => MapEntry(
              i,
              DropdownMenuItem(
                value: i.toString(),
                child: Text(e,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )))
          .values
          .toList(),
      onChanged: (p0) {
        context.read<ProductDetailController>().creatingProduct.purchaseUOM =
            CommonUtils.unitList.elementAt(int.tryParse(p0) ?? 0);
        context.read<ProductDetailController>().notify();
      },
    );
  }

  CheckboxListTile _isCommissionBasedServicesWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .isCommissionBasedServices ??
          false,
      onChanged: (bool? value) {
        context
            .read<ProductDetailController>()
            .creatingProduct
            .isCommissionBasedServices = !(context
                .read<ProductDetailController>()
                .creatingProduct
                .isCommissionBasedServices ??
            false);
        context.read<ProductDetailController>().notify();
      },
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  CheckboxListTile _isThirdUnitWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .isThirdUnit ??
          false,
      onChanged: (bool? value) {
        context.read<ProductDetailController>().creatingProduct.isThirdUnit =
            !(context
                    .read<ProductDetailController>()
                    .creatingProduct
                    .isThirdUnit ??
                false);
        context.read<ProductDetailController>().notify();
      },
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _rebatePercentageWidget() {
    return TextFormField(
      controller: _rebatePercentageTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
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
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return "Please enter the valid rebate percentage!";
        }
        return null;
      },
      onSaved: (newValue) {
        context
            .read<ProductDetailController>()
            .creatingProduct
            .rebatePercentage = double.tryParse(newValue!);
      },
    );
  }

  Widget _salePriceWidget() {
    return TextFormField(
      controller: _salePriceTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "4100.00",
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
        suffixIcon: Text('Ks'),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            (double.tryParse(value) ?? 0) <= 0) {
          return "Please enter the valid sale price!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.salePrice =
            double.tryParse(newValue!);
      },
    );
  }

  Widget _latestPriceWidget() {
    return TextFormField(
      controller: _latestPriceTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "4100.00",
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
        suffixIcon: Text('Ks'),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            (double.tryParse(value) ?? 0) <= 0) {
          return "Please enter the valid latest price!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.latestPrice =
            double.tryParse(newValue!);
      },
    );
  }

  Widget _costWidget() {
    return TextFormField(
      controller: _costTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "4100.00",
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
        suffixIcon: Text('Ks'),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            (double.tryParse(value) ?? 0) <= 0) {
          return "Please enter the valid cost!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.price =
            double.tryParse(newValue!);
      },
    );
  }

  Widget _productCategoryWidget(BuildContext context) {
    return _dropDownWidget(
      context
                      .watch<ProductDetailController>()
                      .creatingProduct
                      .productCategory !=
                  null &&
              CommonUtils.categoryList.indexWhere((element) =>
                      element ==
                      context
                          .read<ProductDetailController>()
                          .creatingProduct
                          .productCategory) !=
                  -1
          ? CommonUtils.categoryList
              .indexWhere((element) =>
                  element ==
                  context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .productCategory)
              .toString()
          : '0',
      CommonUtils.categoryList
          .asMap()
          .map((i, e) => MapEntry(
              i,
              DropdownMenuItem(
                value: i.toString(),
                child: Text(e,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )))
          .values
          .toList(),
      onChanged: (p0) {
        context
                .read<ProductDetailController>()
                .creatingProduct
                .productCategory =
            CommonUtils.categoryList.elementAt(int.tryParse(p0) ?? 0);
        context.read<ProductDetailController>().notify();
      },
    );
  }

  Widget _productBrandsWidget(BuildContext context) {
    return _dropDownWidget(
      context.watch<ProductDetailController>().creatingProduct.productBrand !=
                  null &&
              CommonUtils.brandList.indexWhere((element) =>
                      element ==
                      context
                          .read<ProductDetailController>()
                          .creatingProduct
                          .productBrand) !=
                  -1
          ? CommonUtils.brandList
              .indexWhere((element) =>
                  element ==
                  context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .productBrand)
              .toString()
          : '0',
      CommonUtils.brandList
          .asMap()
          .map((i, e) => MapEntry(
              i,
              DropdownMenuItem(
                value: i.toString(),
                child: Text(e,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )))
          .values
          .toList(),
      onChanged: (p0) {
        context.read<ProductDetailController>().creatingProduct.productBrand =
            CommonUtils.brandList.elementAt(int.tryParse(p0) ?? 0);
        context.read<ProductDetailController>().notify();
      },
    );
  }

  Widget _qtyInBagsWidget() {
    return TextFormField(
      controller: _qtyInBagsTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
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
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return "Please enter the valid qty in bags!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.qtyInBags =
            double.tryParse(newValue!);
      },
    );
  }

  Widget _multipleOfQtyWidget() {
    return TextFormField(
      controller: _multipleOfQtyTextController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Constants.primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return "Please enter the valid multiple of qty!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.multipleOfQty =
            double.tryParse(newValue!);
      },
    );
  }

  Widget _oldInternalRef() {
    return TextFormField(
      controller: _oldInternalReferenceTextController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the old internal reference!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.oldInternalRef =
            newValue;
      },
    );
  }

  Widget _internalReferenceWidget() {
    return TextFormField(
      controller: _internalReferenceTextController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the internal reference!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.internalRef =
            newValue;
      },
    );
  }

  Widget _barcodeWidget() {
    return TextFormField(
      controller: _barcodeTextController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the barcode!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.barcode =
            newValue;
      },
    );
  }

  CheckboxListTile _isClearanceWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .isClearance ??
          false,
      onChanged: (bool? value) {
        context.read<ProductDetailController>().creatingProduct.isClearance =
            !(context
                    .read<ProductDetailController>()
                    .creatingProduct
                    .isClearance ??
                false);
        context.read<ProductDetailController>().notify();
      },
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _itemTypeWidget(BuildContext context) {
    return _dropDownWidget(
      context.watch<ProductDetailController>().creatingProduct.itemType !=
                  null &&
              ItemType.values.indexWhere((element) =>
                      element.text ==
                      context
                          .read<ProductDetailController>()
                          .creatingProduct
                          .itemType!
                          .text) !=
                  -1
          ? ItemType.values
              .indexWhere((element) =>
                  element.text ==
                  context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .itemType!
                      .text)
              .toString()
          : '0',
      ItemType.values
          .map((e) => DropdownMenuItem(
                value: e.index.toString(),
                child: Text(e.text,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ))
          .toList(),
      onChanged: (p0) {
        context.read<ProductDetailController>().creatingProduct.itemType =
            ItemType.values.elementAt(int.tryParse(p0) ?? 0);
        context.read<ProductDetailController>().notify();
      },
    );
  }

  Widget _countryCodeWidget() {
    return TextFormField(
      controller: _countryCodeTextController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the country code!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.countryCode =
            newValue;
      },
    );
  }

  CheckboxListTile _allowNegativeStockWidget(BuildContext context) {
    return CheckboxListTile(
      value: context
              .watch<ProductDetailController>()
              .creatingProduct
              .allowNegativeStock ??
          false,
      onChanged: (bool? value) {
        context
            .read<ProductDetailController>()
            .creatingProduct
            .allowNegativeStock = !(context
                .read<ProductDetailController>()
                .creatingProduct
                .allowNegativeStock ??
            false);
        context.read<ProductDetailController>().notify();
      },
      side: MaterialStateBorderSide.resolveWith(
          (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
      checkColor: Constants.primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _companyWidget(BuildContext context) {
    return _dropDownWidget(
      context.watch<ProductDetailController>().creatingProduct.company !=
                  null &&
              CommonUtils.companyList.indexWhere((element) =>
                      element ==
                      context
                          .read<ProductDetailController>()
                          .creatingProduct
                          .company) !=
                  -1
          ? CommonUtils.companyList
              .indexWhere((element) =>
                  element ==
                  context
                      .read<ProductDetailController>()
                      .creatingProduct
                      .company)
              .toString()
          : '0',
      CommonUtils.companyList
          .asMap()
          .map((i, e) => MapEntry(
              i,
              DropdownMenuItem(
                value: i.toString(),
                child: Text(e,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )))
          .values
          .toList(),
      onChanged: (p0) {
        context.read<ProductDetailController>().creatingProduct.company =
            CommonUtils.companyList.elementAt(int.tryParse(p0) ?? 0);
        context.read<ProductDetailController>().notify();
      },
    );
  }

  Widget _tagsWidget() {
    return _dropDownWidget(
      '0',
      [
        DropdownMenuItem(
          value: 0.toString(),
          child: Text('3000.00 Ks per Unit',
              style: TextStyle(
                color: Colors.black,
              )),
        ),
        DropdownMenuItem(
          value: 1.toString(),
          child: Text('3200.00 Ks per Unit',
              style: TextStyle(
                color: Colors.black,
              )),
        ),
      ],
    );
  }

  Widget _internalNoteWidget() {
    return TextFormField(
      controller: _internalNoteTextController,
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
      onSaved: (newValue) {
        context.read<ProductDetailController>().creatingProduct.internalNotes =
            newValue;
      },
    );
  }

  RadioListTile<int> _eachRadioWidget({
    required int value,
    required int groupValue,
    required String text,
    Function(int? value)? onChanged,
  }) {
    return RadioListTile(
      value: value,
      activeColor: Constants.primaryColor,
      fillColor:
          MaterialStateColor.resolveWith((states) => Constants.primaryColor),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      groupValue: groupValue,
      onChanged: onChanged,
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
    List<DropdownMenuItem> list, {
    Function(dynamic)? onChanged,
  }) {
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
              focusColor: Colors.transparent,
              onChanged: (v) {
                onChanged?.call(v);
              },
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
