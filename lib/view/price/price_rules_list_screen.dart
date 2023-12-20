import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class PriceRulesListScreen extends StatefulWidget {
  const PriceRulesListScreen({super.key});
  static const String routeName = "/price_rules_list_screen";

  @override
  State<PriceRulesListScreen> createState() => _PriceRulesListScreenState();
}

class _PriceRulesListScreenState extends State<PriceRulesListScreen> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  int _limit = 20;
  int _offset = 0;
  bool? _sortAscending = true;
  int? _sortColumnIndex;
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
      for (var i = 0; i < 20; i++) {
        context
            .read<PriceRulesListController>()
            .priceRulesList
            .add(CommonUtils.demoPriceRule);
      }
      context.read<PriceRulesListController>().priceRulesDataSource =
          DataSourceForPriceRulesListScreen(
              context,
              context.read<PriceRulesListController>().priceRulesList,
              _offset,
              () {});
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventoryAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 16),
            Text(
              'Price Rules',
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
        Expanded(
            child: context.read<PriceRulesListController>().isDetail
                ? _priceRuleDetailWidget()
                : _tableWidget()),
      ],
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
    return context.watch<PriceRulesListController>().isDetail
        ? Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: _textForDetailInfo(
                    'Product : [${context.read<PriceRulesListController>().editingPriceRule?.appliedOn ?? ''}]'
                    '${context.read<PriceRulesListController>().editingPriceRule?.product ?? ''}'),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (isTabletMode != true && isMobileMode != true)
                      Expanded(child: SizedBox()),
                    CommonUtils.appBarActionButtonWithText(
                        'assets/svg/filter_alt.svg', 'Print',
                        width: 35, height: 35),
                    SizedBox(width: 4),
                    CommonUtils.appBarActionButtonWithText(
                      'assets/svg/ad_group.svg',
                      'Action',
                      // width: 25,
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        : Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    BorderContainer(
                      text: 'Create',
                      containerColor: Constants.primaryColor,
                      textColor: Colors.white,
                      width: 150,
                      onTap: () {
                        // context.read<PriceRulesListController>().isDetail = false;
                        // context.read<PriceRulesListController>().isNew = true;
                      },
                    ),
                    SizedBox(width: 4),
                    CommonUtils.svgIconActionButton(
                        'assets/svg/export_notes.svg'),
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
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
            ],
          );
  }

  Widget _tableWidget() {
    var singleChildScrollView = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: context.watch<PriceRulesListController>().priceRulesDataSource !=
                null
            ? _paginationTable()
            : SizedBox(),
      ),
    );
    return Scrollbar(
      thumbVisibility: true,
      child: isTabletMode == true
          ? ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: singleChildScrollView,
            )
          : singleChildScrollView,
    );
  }

  Widget _paginationTable() {
    return PaginatedDataTable2(
      dataRowHeight: 65,
      headingRowHeight: 70,
      dividerThickness: 0.0,
      headingCheckboxTheme: CheckboxThemeData(
        side: MaterialStateBorderSide.resolveWith(
            (_) => const BorderSide(width: 2, color: Colors.white)),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      datarowCheckboxTheme: CheckboxThemeData(
        side: MaterialStateBorderSide.resolveWith(
            (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
        checkColor: MaterialStateProperty.all(Constants.primaryColor),
      ),
      border: TableBorder(
          horizontalInside:
              BorderSide(color: Constants.disableColor.withOpacity(0.81))),
      rowsPerPage: min(_limit,
          context.read<PriceRulesListController>().priceRulesList.length),
      minWidth: MediaQuery.of(context).size.width,
      showCheckboxColumn: true,
      fit: FlexFit.tight,
      hidePaginator: true,
      columnSpacing: 0.0,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending ?? false,
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Constants.primaryColor),
      columns: [
        CommonUtils.dataColumn(
          // fixedWidth: isTabletMode ? 150 : 120,
          text: '#',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          // fixedWidth: isTabletMode ? 150 : 120,
          text: 'Pricelist',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          fixedWidth: isTabletMode == true ? 300 : 300,
          text: 'Applied On',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          fixedWidth: isTabletMode == true ? 300 : 300,
          text: 'Apply On',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Product',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Price',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Quantity',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Start Date',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'End Date',
        ),
        DataColumn2(
          fixedWidth: 20,
          label: _moreInfoWidget(),

          // onSort: onSort,
        )
      ],
      source: context.read<PriceRulesListController>().priceRulesDataSource!,
    );
  }

  PopupMenuButton<int> _moreInfoWidget() {
    return PopupMenuButton(
      tooltip: "",
      itemBuilder: (bContext) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Column(
              children: [
                CheckboxListTile(
                  value: false,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith((_) =>
                      const BorderSide(
                          width: 2, color: Constants.primaryColor)),
                  checkColor: Constants.primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Pack Size'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith((_) =>
                      const BorderSide(
                          width: 2, color: Constants.primaryColor)),
                  checkColor: Constants.primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Pack Size UOM'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith((_) =>
                      const BorderSide(
                          width: 2, color: Constants.primaryColor)),
                  checkColor: Constants.primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Start Date'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith((_) =>
                      const BorderSide(
                          width: 2, color: Constants.primaryColor)),
                  checkColor: Constants.primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('End Date'),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith((_) =>
                      const BorderSide(
                          width: 2, color: Constants.primaryColor)),
                  checkColor: Constants.primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Company'),
                ),
                Divider(
                  thickness: 1.3,
                  color: Constants.disableColor.withOpacity(0.96),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonUtils.iconActionButton(
                        Icons.add_rounded,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add custom field',
                        style: TextStyle(
                          color: Constants.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ];
      },
      child: Icon(
        Icons.more_horiz_rounded,
        color: Colors.white,
      ),
    );
  }

  Container _priceRuleDetailWidget() {
    return Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 2,
          minWidth: (MediaQuery.of(context).size.width / 2) -
              MediaQuery.of(context).size.width / 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30, vertical: 10),
      padding: EdgeInsets.all(20),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              // width:( MediaQuery.of(context).size.width/2) -MediaQuery.of(context).size.width / 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Computation',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ..._infoWidget(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'The computed price is expressed in the default Unit of Measure of the product.',
                style: TextStyle(
                  color: Constants.textColor.withOpacity(0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ]),
    );
  }

  List<Widget> _infoWidget() {
    var spacer = SizedBox(height: 15);

    return [
      spacer,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _textForDetailInfo("Computation")),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _eachRadioWidget(
                  text: 'Fixed Price',
                  value: 0,
                  selected: true,
                  groupValue: 0,
                ),
                _eachRadioWidget(
                  text: 'Discount',
                  value: 1,
                  selected: false,
                  groupValue: 0,
                ),
                _eachRadioWidget(
                  text: 'Formula',
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
          Expanded(child: _textForDetailInfo("Fixed Price")),
          Expanded(
              flex: 2,
              child: _textForDetailInfo(
                  '${context.read<PriceRulesListController>().editingPriceRule?.price ?? 0} Ks')),
        ],
      ),
      spacer,
      _textForDetailInfo("Conditions"),
      spacer,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _textForDetailInfo("Apply On")),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _eachRadioWidget(
                        text: 'All Product',
                        value: 0,
                        selected: true,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product Category',
                        value: 1,
                        selected: false,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product',
                        value: 2,
                        selected: false,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product Varient',
                        value: 3,
                        selected: false,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product Package',
                        value: 4,
                        selected: false,
                        groupValue: 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Quantity")),
                          Expanded(
                              flex: 2,
                              child: _textForDetailInfo(
                                  '${context.read<PriceRulesListController>().editingPriceRule?.quantity ?? 0}')),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Validity")),
                          Expanded(
                              flex: 2,
                              child: _textForDetailInfo('12.07.2024 12:00:00')),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Currency")),
                          Expanded(flex: 2, child: _textForDetailInfo('MMK')),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Company")),
                          Expanded(
                              flex: 2,
                              child: _textForDetailInfo(
                                  'SSS International Co;Ltd')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Product")),
          Expanded(
            flex: 2,
            child: _textForDetailInfo(
                '[${context.read<PriceRulesListController>().editingPriceRule?.appliedOn ?? ''}]'
                '${context.read<PriceRulesListController>().editingPriceRule?.product ?? ''}'),
          ),
        ],
      ),
    ];
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

  Widget _textForDetailInfo(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Constants.textColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class DataSourceForPriceRulesListScreen extends DataTableSource {
  BuildContext context;
  late List<PriceRules> priceRulesList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForPriceRulesListScreen(
    this.context,
    this.priceRulesList,
    this.offset,
    this.reloadDataCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(Comparable<T> Function(PriceRules d) getField, bool ascending) {
    priceRulesList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => priceRulesList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    PriceRules priceRules = priceRulesList[index];
    onTap() {
      context.read<PriceRulesListController>().isDetail = true;
      context.read<PriceRulesListController>().editingPriceRule = priceRules;
    }

    return DataRow(
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text('${index + 1}'),
        ),
        DataCell(
          onTap: onTap,
          Text(priceRules.priceList ?? ''),
        ),
        DataCell(
          onTap: () {},
          Text(
            priceRules.appliedOn ?? '',
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            priceRules.applyOn ?? '',
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            priceRules.product ?? '',
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${priceRules.price ?? 0} Ks',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${priceRules.quantity ?? 0}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(priceRules.startDate ?? ''),
        ),
        DataCell(
          onTap: onTap,
          Text(priceRules.endDate ?? ''),
        ),
        DataCell(
          onTap: onTap,
          Text(''),
        ),
      ],
    );
  }
}

class PriceRules {
  String? priceList;
  String? appliedOn;
  String? applyOn;
  String? product;
  int? price;
  int? quantity;
  String? startDate;
  String? endDate;

  PriceRules(
      {this.priceList,
      this.appliedOn,
      this.applyOn,
      this.product,
      this.price,
      this.quantity,
      this.startDate,
      this.endDate});

  PriceRules.fromJson(Map<String, dynamic> json) {
    priceList = json['price_list'];
    appliedOn = json['applied_on'];
    applyOn = json['apply_on'];
    product = json['product'];
    price = json['price'];
    quantity = json['quantity'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price_list'] = priceList;
    data['applied_on'] = appliedOn;
    data['apply_on'] = applyOn;
    data['product'] = product;
    data['price'] = price;
    data['quantity'] = quantity;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}
