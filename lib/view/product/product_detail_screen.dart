import 'package:offline_pos/components/export_files.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  static const String routeName = "/product_detail_screen";

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  bool? isTabletMode;
  bool? isMobileMode;

  @override
  void dispose() {
    _searchProductTextController.dispose();
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
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: InventoryAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    var spacer = SizedBox(height: 15);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 16),
              Text(
                'Product/ [${CommonUtils.demoProduct.package ?? ''}]'
                '${CommonUtils.demoProduct.productName ?? ''}',
                style: TextStyle(
                  color: Constants.textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(flex: isTabletMode == true ? 1 : 2, child: SizedBox()),
              Expanded(child: _searchProductWidget()),
              SizedBox(width: 16),
            ],
          ),
          _filtersWidget(),
          spacer,
          _commonActionTitle(),
          spacer,
          _permissionActionWidget(),
          spacer,
          _itemInfoWidget(),
        ],
      ),
    );
  }

  Widget _searchProductWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: TextField(
          controller: _searchProductTextController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14),
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
            suffixIcon: InkWell(
              onTap: () {
                _searchProductTextController.clear();
              },
              child: UnconstrainedBox(
                child: SvgPicture.asset(
                  'assets/svg/close.svg',
                  width: 25,
                  height: 25,
                  colorFilter: ColorFilter.mode(
                    Constants.alertColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filtersWidget() {
    return Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              BorderContainer(
                text: 'Edit',
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                containerColor: Constants.primaryColor,
                textColor: Colors.white,
                width: 150,
                textSize: 20,
                radius: 16,
                onTap: () {},
              ),
              SizedBox(width: 4),
              BorderContainer(
                text: 'Create',
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                width: 150,
                textSize: 20,
                radius: 16,
                onTap: () {},
              ),
              SizedBox(width: 4),
              CommonUtils.appBarActionButtonWithText(
                'assets/svg/print.svg',
                'Print',
                // width: 25,
              ),
              SizedBox(width: 4),
              CommonUtils.iconActionButtonWithText(
                Icons.tune_rounded,
                'Action',
                // width: 25,
              ),
              (isTabletMode != true && isMobileMode != true)
                  ? Expanded(child: SizedBox())
                  : SizedBox(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (isTabletMode != true && isMobileMode != true)
                Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CommonUtils.appBarActionButtonWithText(
                      'assets/svg/filter_alt.svg', 'Filters',
                      width: 35, height: 35),
                  SizedBox(width: 4),
                  CommonUtils.appBarActionButtonWithText(
                    'assets/svg/ad_group.svg',
                    'Group By',
                    // width: 25,
                  ),
                  SizedBox(width: 4),
                  CommonUtils.appBarActionButtonWithText(
                    'assets/svg/favorite.svg',
                    'Favorites',
                  ),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/view_list.svg'),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/grid_view.svg'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
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

  Widget _commonActionTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: Constants.greyColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _textForDetailInfo(
            'Print Tables',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Generate IR Code',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Generate BarCode',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Update Quantity',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Replenish',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          if (isMobileMode != true && isTabletMode != true)
            Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _permissionActionWidget() {
    var spacer = SizedBox(height: 15);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Scrollbar(
            thickness: MediaQuery.of(context).size.width > 1080 ? 0 : 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Constants.greyColor2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: MediaQuery.of(context).size.width > 1080
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ..._permissionTitleList.map((e) {
                      if (e is SizedBox) {
                        return e;
                      }
                      return SizedBox(
                        width: MediaQuery.of(context).size.width > 1080
                            ? MediaQuery.of(context).size.width /
                                ((_permissionTitleList.length / 2) + 0.5)
                            : 250,
                        child: e,
                      );
                    }).toList()
                  ],
                ),
              ),
            ),
          ),
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

  final List<Widget> _permissionTitleList = [
    CommonUtils.iconActionButtonWithText(
      Icons.list_rounded,
      'Extra Price',
      size: 28,
    ),
    SizedBox(width: 4),
    CommonUtils.appBarActionButtonWithText(
      'assets/svg/globe.svg',
      'Go to website',
      width: 23,
      height: 23,
    ),
    SizedBox(width: 4),
    CommonUtils.appBarActionButtonWithText(
      'assets/svg/globe.svg',
      'Published an app',
      width: 23,
      height: 23,
    ),
    SizedBox(width: 4),
    CommonUtils.appBarActionButtonWithText(
      'assets/svg/data_thresholding.svg',
      '0.00 Unit sold',
      width: 22,
      height: 22,
    ),
    SizedBox(width: 4),
    CommonUtils.appBarActionButtonWithText(
      'assets/svg/package_2.svg',
      '0.00 Bags Forecasted',
      width: 24,
      height: 24,
    ),
    SizedBox(width: 4),
    CommonUtils.appBarActionButtonWithText(
      'assets/svg/package_2.svg',
      '0.00 On Hand',
      width: 24,
      height: 24,
    ),
    SizedBox(width: 4),
    PopupMenuButton<int>(
      color: Constants.backgroundColor,
      shadowColor: Colors.transparent,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tooltip: "",
      itemBuilder: (bContext) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: CommonUtils.iconActionButtonWithText(
              Icons.swap_horiz_rounded,
              'In : 35  Out : 35',
              size: 30,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 1,
            child: CommonUtils.appBarActionButtonWithText(
              'assets/svg/sell.svg',
              '66.00 Unit Sold',
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 0,
            child: CommonUtils.iconActionButtonWithText(
              Icons.autorenew_rounded,
              '0 Reordering',
              size: 30,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 0,
            child: CommonUtils.iconActionButtonWithText(
              Icons.monetization_on_rounded,
              '1 Bill of Material',
              size: 28,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 1,
            child: CommonUtils.appBarActionButtonWithText(
              'assets/svg/arrows_more_up.svg',
              '1 Used In',
              width: 20,
              height: 20,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 1,
            child: CommonUtils.appBarActionButtonWithText(
              'assets/svg/developer_guide.svg',
              'Putaway Rules',
              width: 20,
              height: 20,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 0,
            child: CommonUtils.iconActionButtonWithText(
              Icons.loyalty_rounded,
              'Quality Control Points',
              size: 26,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 0,
            child: CommonUtils.iconActionButtonWithText(
              Icons.storage,
              'Storage Capacities',
              size: 24,
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 0,
            child: CommonUtils.iconActionButtonWithText(
              Icons.credit_card,
              '5.00 Unit Purchased',
              size: 24,
            ),
          ),
        ];
      },
      child: CommonUtils.iconActionButtonWithText(
        Icons.keyboard_arrow_down_rounded,
        'More',
        size: 28,
        switchChild: true,
      ),
    ),
  ];

  List<Widget> _itemInfoTitleList() {
    return [
      _textForDetailInfo(
        'General Information',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'POS UOM',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Attributes and Variants',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Sales',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Suggestion',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Purchase',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Inventory',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Accounting',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'UOM',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Additional Information',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
    ];
  }

  Widget _itemInfoWidget() {
    var spacer = SizedBox(height: 6);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Scrollbar(
            thickness: MediaQuery.of(context).size.width > 1080 ? 0 : 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Constants.greyColor2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: MediaQuery.of(context).size.width > 1080
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ..._itemInfoTitleList().map((e) {
                      if (e is SizedBox) {
                        return e;
                      }
                      return SizedBox(
                        width: MediaQuery.of(context).size.width > 1080
                            ? MediaQuery.of(context).size.width /
                                ((_itemInfoTitleList().length / 2) + 0.5)
                            : 250,
                        child: e,
                      );
                    }).toList()
                  ],
                ),
              ),
            ),
          ),
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
          SizedBox(
            width: isMobileMode == true
                ? MediaQuery.of(context).size.width
                : isTabletMode == true
                    ? MediaQuery.of(context).size.width / 2.5
                    : MediaQuery.of(context).size.width / 5,
            child: CommonUtils.okCancelWidget(
              okLabel: 'Save',
              cancelLabel: 'Discard',
            ),
          ),
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
}
