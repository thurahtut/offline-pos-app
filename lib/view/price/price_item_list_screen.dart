import 'dart:math';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/price/price_list_item_detail_create.dart';
import 'package:offline_pos/view/price/price_list_item_detail_view.dart';

class PriceItemListScreen extends StatefulWidget {
  const PriceItemListScreen({super.key});
  static const String routeName = "/price_rules_list_screen";

  @override
  State<PriceItemListScreen> createState() => _PriceItemListScreenState();
}

class _PriceItemListScreenState extends State<PriceItemListScreen> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;
  bool? isMobileMode;
  final scrollController = ScrollController();

  @override
  void dispose() {
    _searchProductTextController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PriceListItemController>().resetPriceItemListController();
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      getAllProduct();
    });
    super.initState();
  }

  void getAllProduct() {
    context.read<PriceListItemController>().loading = true;
    List<int>? ids =
        context.read<LoginUserController>().posConfig?.posCategoryIds;
    context
        .read<PriceListItemController>()
        .getAllPriceItemList(categoryListFilter: ids?.join(","))
        .then((value) {
      updatePriceItemListToTable();
      context.read<PriceListItemController>().loading = false;
    });
  }

  Future<void> updatePriceItemListToTable() async {
    context.read<PriceListItemController>().priceItemDataSource =
        DataSourceForPriceItemListScreen(
            context,
            context.read<PriceListItemController>().priceItemList,
            context.read<PriceListItemController>().offset,
            () {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !context.read<PriceListItemController>().isDetail,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<PriceListItemController>().isDetail = false;
        }
      },
      child: Scaffold(
        appBar: InventoryAppBar(),
        body: _bodyWidget(),
      ),
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
              'Price Rules'
              '${context.read<PriceListItemController>().isDetail ? "/ Detail" : ""}'
              '${context.read<PriceListItemController>().isNew ? "/ New" : ""}',
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
            child: context.read<PriceListItemController>().isDetail
                ? SingleChildScrollView(child: PriceListItemDetailView())
                : context.read<PriceListItemController>().isNew
                    ? SingleChildScrollView(child: PriceListItemDetailNew())
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
                  primaryColor,
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
    return context.watch<PriceListItemController>().isDetail
        ? Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: _textForDetailInfo(
                    'Product : [${context.read<PriceListItemController>().editingPriceItem?.priceListItem?.appliedOn ?? ''}]'
                    '${context.read<PriceListItemController>().editingPriceItem?.productName ?? ''}'),
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
                    // BorderContainer(
                    //   text: 'Create',
                    //   containerColor: primaryColor,
                    //   textColor: Colors.white,
                    //   width: 150,
                    //   onTap: () {
                    //     context.read<PriceListItemController>().isDetail =
                    //         false;
                    //     context.read<PriceListItemController>().isNew = true;
                    //   },
                    // ),
                    // SizedBox(width: 4),
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
                        // SizedBox(width: 4),
                        // CommonUtils.appBarActionButtonWithText(
                        //   'assets/svg/ad_group.svg',
                        //   'Group By',
                        //   // width: 25,
                        // ),
                        // SizedBox(width: 4),
                        // CommonUtils.appBarActionButtonWithText(
                        //   'assets/svg/favorite.svg',
                        //   'Favorites',
                        // ),
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
        child:
            context.watch<PriceListItemController>().priceItemDataSource != null
                ? _paginationTable()
                : SizedBox(),
      ),
    );
    return Scrollbar(
      controller: scrollController,
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
            (_) => BorderSide(width: 2, color: primaryColor)),
        checkColor: MaterialStateProperty.all(primaryColor),
      ),
      border: TableBorder(
          horizontalInside:
              BorderSide(color: Constants.disableColor.withOpacity(0.81))),
      rowsPerPage: min(context.read<PriceListItemController>().limit,
          max(context.read<PriceListItemController>().priceItemList.length, 1)),
      minWidth: MediaQuery.of(context).size.width,
      showCheckboxColumn: true,
      fit: FlexFit.tight,
      hidePaginator: true,
      columnSpacing: 0.0,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending ?? false,
      headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor),
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
        // CommonUtils.dataColumn(
        //   fixedWidth: isTabletMode == true ? 300 : 300,
        //   text: 'Apply On',
        // ),
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
      source: context.read<PriceListItemController>().priceItemDataSource!,
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
                  side: MaterialStateBorderSide.resolveWith(
                      (_) => BorderSide(width: 2, color: primaryColor)),
                  checkColor: primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Pack Size'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith(
                      (_) => BorderSide(width: 2, color: primaryColor)),
                  checkColor: primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Pack Size UOM'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith(
                      (_) => BorderSide(width: 2, color: primaryColor)),
                  checkColor: primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('Start Date'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith(
                      (_) => BorderSide(width: 2, color: primaryColor)),
                  checkColor: primaryColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  title: Text('End Date'),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: (bool? value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  side: MaterialStateBorderSide.resolveWith(
                      (_) => BorderSide(width: 2, color: primaryColor)),
                  checkColor: primaryColor,
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

class DataSourceForPriceItemListScreen extends DataTableSource {
  BuildContext context;
  late List<Product> priceItemList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForPriceItemListScreen(
    this.context,
    this.priceItemList,
    this.offset,
    this.reloadDataCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(Comparable<T> Function(Product d) getField, bool ascending) {
    priceItemList.sort((a, b) {
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
  int get rowCount => priceItemList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    Product priceListItem = priceItemList[index];
    onTap() {
      context.read<PriceListItemController>().isDetail = true;
      context.read<PriceListItemController>().editingPriceItem = priceListItem;
    }

    return DataRow(
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text('${index + 1}'),
        ),
        DataCell(
          onTap: onTap,
          Text(priceListItem.priceListItem?.id?.toString() ?? ''),
        ),
        DataCell(
          onTap: onTap,
          Text(
            priceListItem.priceListItem?.appliedOn ?? '',
          ),
        ),
        // DataCell(
        //   onTap: onTap,
        //   Text(
        //     priceListItem.applyOn?.text ?? '',
        //   ),
        // ),
        DataCell(
          onTap: onTap,
          Text(
            priceListItem.productName ?? '',
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${priceListItem.priceListItem?.fixedPrice ?? 0} Ks',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${priceListItem.priceListItem?.minQuantity ?? 0}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            CommonUtils.getLocaleDateTime(
              "hh:mm:ss dd-MM-yyyy",
              priceListItem.priceListItem?.dateStart,
            ),
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            CommonUtils.getLocaleDateTime(
              "hh:mm:ss dd-MM-yyyy",
              priceListItem.priceListItem?.dateEnd,
            ),
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(''),
        ),
      ],
    );
  }
}
