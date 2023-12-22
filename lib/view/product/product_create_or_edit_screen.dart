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
  final TextEditingController _rebatePercentageTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    _rebatePercentageTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
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
                    Row(
                      children: [
                        CommonUtils.iconActionButton(
                          Icons.star_outline_outlined,
                          size: 28,
                        ),
                        Expanded(
                          child: TextFormField(
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
                          ),
                        ),
                        if (isMobileMode != true)
                          Expanded(flex: 2, child: SizedBox()),
                      ],
                    ),
                    SizedBox(height: 8),
                    CheckboxListTile(
                      value: context
                              .watch<ProductDetailController>()
                              .creatingProduct
                              .isBundled ??
                          false,
                      onChanged: (bool? value) {
                        context
                            .read<ProductDetailController>()
                            .creatingProduct
                            .isBundled = !(context
                                .read<ProductDetailController>()
                                .creatingProduct
                                .isBundled ??
                            false);
                        context.read<ProductDetailController>().notify();
                      },
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
                                  value: context
                                          .watch<ProductDetailController>()
                                          .creatingProduct
                                          .canBeSold ??
                                      false,
                                  onChanged: (bool? value) {
                                    context
                                        .read<ProductDetailController>()
                                        .creatingProduct
                                        .canBeSold = !(context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .canBeSold ??
                                        false);
                                    context
                                        .read<ProductDetailController>()
                                        .notify();
                                  },
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
                                  value: context
                                          .watch<ProductDetailController>()
                                          .creatingProduct
                                          .canBePurchased ??
                                      false,
                                  onChanged: (bool? value) {
                                    context
                                        .read<ProductDetailController>()
                                        .creatingProduct
                                        .canBePurchased = !(context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .canBePurchased ??
                                        false);
                                    context
                                        .read<ProductDetailController>()
                                        .notify();
                                  },
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
                                    context
                                        .read<ProductDetailController>()
                                        .notify();
                                  },
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

  Widget _itemInfoWidget(BuildContext context) {
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
                          child: _dropDownWidget(
                            context
                                    .read<ProductDetailController>()
                                    .creatingProduct
                                    .productType
                                    ?.name ??
                                ProductType.consumable.name,
                            ProductType.values
                                .map((e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(e.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Invoicing Policy")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            context
                                    .read<ProductDetailController>()
                                    .creatingProduct
                                    .invoicingPolicy
                                    ?.name ??
                                InvoicingPolicy.orderedQuantities.name,
                            InvoicingPolicy.values
                                .map((e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(e.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ))
                                .toList(),
                          ),
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
                          child: Column(
                            children: ReInvoiceExpenses.values.map((e) {
                              return _eachRadioWidget(
                                text: e.text,
                                value: e.index,
                                groupValue: (context
                                                .watch<
                                                    ProductDetailController>()
                                                .creatingProduct
                                                .reInvoiceExpenses ??
                                            '') ==
                                        e
                                    ? e.index
                                    : 0,
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .reInvoiceExpenses =
                                        ReInvoiceExpenses.values
                                            .elementAt(value);
                                    context
                                        .read<ProductDetailController>()
                                        .notify();
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Unit of Measure")),
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            CommonUtils.unitList.indexWhere((element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .unitOfMeasure) !=
                                    -1
                                ? CommonUtils.unitList.indexWhere((element) =>
                                    element ==
                                    context
                                        .read<ProductDetailController>()
                                        .creatingProduct
                                        .unitOfMeasure)
                                : 0,
                            CommonUtils.unitList
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    )))
                                .values
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(child: _textForDetailInfo("Base Unit Count")),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _baseUnitCountTextController,
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
                        Expanded(
                            child: _textForDetailInfo("Is secondary Unit?")),
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
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
                        Expanded(
                          flex: 2,
                          child: _dropDownWidget(
                            CommonUtils.unitList.indexWhere((element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .purchaseUOM) !=
                                    -1
                                ? CommonUtils.unitList.indexWhere((element) =>
                                    element ==
                                    context
                                        .read<ProductDetailController>()
                                        .creatingProduct
                                        .purchaseUOM)
                                : 0,
                            CommonUtils.unitList
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    )))
                                .values
                                .toList(),
                          ),
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
                          child: CheckboxListTile(
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
                            value: context
                                    .watch<ProductDetailController>()
                                    .creatingProduct
                                    .isThirdUnit ??
                                false,
                            onChanged: (bool? value) {
                              context
                                  .read<ProductDetailController>()
                                  .creatingProduct
                                  .isThirdUnit = !(context
                                      .read<ProductDetailController>()
                                      .creatingProduct
                                      .isThirdUnit ??
                                  false);
                              context.read<ProductDetailController>().notify();
                            },
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
                          child: TextFormField(
                            controller: _rebatePercentageTextController,
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
                          child: TextFormField(
                            controller: _salePriceTextController,
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
                            CommonUtils.categoryList.indexWhere((element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .productCategory) !=
                                    -1
                                ? CommonUtils.categoryList.indexWhere(
                                    (element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .productCategory)
                                : 0,
                            CommonUtils.categoryList
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    )))
                                .values
                                .toList(),
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
                            CommonUtils.brandList.indexWhere((element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .productBrand) !=
                                    -1
                                ? CommonUtils.brandList.indexWhere((element) =>
                                    element ==
                                    context
                                        .read<ProductDetailController>()
                                        .creatingProduct
                                        .productBrand)
                                : 0,
                            CommonUtils.brandList
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    )))
                                .values
                                .toList(),
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
                          child: TextFormField(
                            controller: _qtyInBagsTextController,
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
                          child: TextFormField(
                            controller: _multipleOfQtyTextController,
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
                          child: TextFormField(
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
                          child: TextFormField(
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
                          child: TextFormField(
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
                            value: context
                                    .watch<ProductDetailController>()
                                    .creatingProduct
                                    .isClearance ??
                                false,
                            onChanged: (bool? value) {
                              context
                                  .read<ProductDetailController>()
                                  .creatingProduct
                                  .isClearance = !(context
                                      .read<ProductDetailController>()
                                      .creatingProduct
                                      .isClearance ??
                                  false);
                              context.read<ProductDetailController>().notify();
                            },
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
                            ItemType.values.indexWhere((element) =>
                                        element.text ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .unitOfMeasure) !=
                                    -1
                                ? ItemType.values.indexWhere((element) =>
                                    element.text ==
                                    context
                                        .read<ProductDetailController>()
                                        .creatingProduct
                                        .unitOfMeasure)
                                : 0,
                            ItemType.values
                                .map((e) => DropdownMenuItem(
                                      value: e.index,
                                      child: Text(e.text,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ))
                                .toList(),
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
                          child: TextFormField(
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
                            CommonUtils.companyList.indexWhere((element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .company) !=
                                    -1
                                ? CommonUtils.companyList.indexWhere(
                                    (element) =>
                                        element ==
                                        context
                                            .read<ProductDetailController>()
                                            .creatingProduct
                                            .productBrand)
                                : 0,
                            CommonUtils.companyList
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    )))
                                .values
                                .toList(),
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
          TextFormField(
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
    dynamic selectedValue,
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
