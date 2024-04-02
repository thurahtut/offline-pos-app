import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class PromotionListScreen extends StatefulWidget {
  const PromotionListScreen({super.key});
  static const String routeName = "/promotion_list_screen";

  @override
  State<PromotionListScreen> createState() => _PromotionListScreenState();
}

class _PromotionListScreenState extends State<PromotionListScreen> {
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
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      context.read<ProductDetailController>().resetProductDetailController();
      context.read<PromotionListController>().resetPromotionListController();
      getAllPromotion();
    });
    super.initState();
  }

  void getAllPromotion() {
    context.read<PromotionListController>().loading = true;
    context.read<PromotionListController>().getAllPromotion(
          sessionId: context.read<LoginUserController>().posSession?.id ?? 0,
          callback: () {
            updatePromotionListToTable();
            context.read<PromotionListController>().loading = false;
          },
        );
  }

  Future<void> updatePromotionListToTable() async {
    context.read<PromotionListController>().promotionInfoDataSource =
        DataSourceForPromotionListScreen(context,
            context.read<PromotionListController>().promotionList, () {});
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
              'Promotion',
              style: TextStyle(
                color: Constants.textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(flex: isTabletMode == true ? 1 : 2, child: SizedBox()),
            Expanded(child: _searchPromotionWidget()),
            SizedBox(width: 16),
          ],
        ),
        _filtersWidget(),
        context.watch<PromotionListController>().loading
            ? SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Expanded(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: _tableWidget(),
                    ),
                    _paginationWidget(),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _searchPromotionWidget() {
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
                context.read<PromotionListController>().filterValue = null;
                context.read<PromotionListController>().offset = 0;
                context.read<PromotionListController>().currentIndex = 1;
                getAllPromotion();
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
          onChanged: (value) {
            context.read<PromotionListController>().filterValue = value;
            context.read<PromotionListController>().offset = 0;
            context.read<PromotionListController>().currentIndex = 1;
            getAllPromotion();
          },
        ),
      ),
    );
  }

  Widget _filtersWidget() {
    return Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: SizedBox(),
          //     Row(
          //   children: [
          //     BorderContainer(
          //       text: 'Create',
          //       containerColor: primaryColor,
          //       textColor: Colors.white,
          //       width: 150,
          //       onTap: () {
          //         context.read<ProductDetailController>().creatingProduct =
          //             Product();
          //         Navigator.pushNamed(context, ProductDetailScreen.routeName);
          //         context.read<ProductDetailController>().mode =
          //             ViewMode.create;
          //       },
          //     ),
          //     SizedBox(width: 4),
          //     CommonUtils.svgIconActionButton('assets/svg/export_notes.svg'),
          //     (isTabletMode != true && isMobileMode != true)
          //         ? Expanded(child: SizedBox())
          //         : SizedBox(),
          //   ],
          // ),
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
                  SizedBox(width: 16),
                  CommonUtils.appBarActionButtonWithText(
                    'assets/svg/ad_group.svg',
                    'Group By',
                    // width: 25,
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
      primary: true,
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: _paginationTable(),
      ),
    );
    return context.watch<PromotionListController>().promotionInfoDataSource !=
            null
        ? Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: isTabletMode == true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: SingleChildScrollView(
                      primary: true,
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width),
                        child: _paginationTable(),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    primary: true,
                    scrollDirection: Axis.horizontal,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: _paginationTable(),
                    ),
                  ),
          )
        : SizedBox();
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
      rowsPerPage: min(context.read<PromotionListController>().limit,
          max(context.read<PromotionListController>().promotionList.length, 1)),
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
        // CommonUtils.dataColumn(
        //   // fixedWidth: isTabletMode ? 150 : 120,
        //   text: 'Product Name',
        //   // onSort: (columnIndex, ascending) =>
        //   //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
        // ),
        // CommonUtils.dataColumn(
        //   fixedWidth: isTabletMode == true ? 300 : 300,
        //   text: 'Product',
        //   // onSort: (columnIndex, ascending) =>
        //   //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
        // ),
        // CommonUtils.dataColumn(
        //   fixedWidth: isTabletMode == true ? 300 : 300,
        //   text: 'Price',
        // ),
        // CommonUtils.dataColumn(
        //   // fixedWidth: 180,
        //   text: 'Barcode',
        // ),
        // CommonUtils.dataColumn(
        //   // fixedWidth: 180,
        //   text: 'Sale Price',
        // ),
        // CommonUtils.dataColumn(
        //   // fixedWidth: 180,
        //   text: 'Latest Price',
        // ),
        // CommonUtils.dataColumn(
        //   // fixedWidth: 180,
        //   text: 'Product Category',
        // ),
        // CommonUtils.dataColumn(
        //   // fixedWidth: 180,
        //   text: 'Product Type',
        // ),
        // DataColumn2(
        //   fixedWidth: 20,
        //   label: _moreInfoWidget(),
        //   // onSort: onSort,
        // ),
      ],
      source: context.read<PromotionListController>().promotionInfoDataSource!,
    );
  }

  Widget _paginationWidget() {
    return Consumer<PromotionListController>(builder: (_, controller, __) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          FlutterCustomPagination(
            currentPage: controller.currentIndex,
            limitPerPage: controller.limit,
            totalDataCount: controller.total,
            onPreviousPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllPromotion();
            },
            onBackToFirstPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllPromotion();
            },
            onNextPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllPromotion();
            },
            onGoToLastPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllPromotion();
            },
            backgroundColor: Theme.of(context).colorScheme.background,
            previousPageIcon: Icons.keyboard_arrow_left,
            backToFirstPageIcon: Icons.first_page,
            nextPageIcon: Icons.keyboard_arrow_right,
            goToLastPageIcon: Icons.last_page,
          ),
        ],
      );
    });
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
                  title: Text('Responsible'),
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
                  title: Text('Favorite'),
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
                  title: Text('Website'),
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
                  title: Text('Company'),
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
                  title: Text('Sales Price'),
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
                  title: Text('Latest Price'),
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
                  title: Text('Cost'),
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
                  title: Text('POS Product Category'),
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
                  title: Text('Product Type'),
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
                  title: Text('Forecasted Quantity'),
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
                  title: Text('Unit of Measure'),
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
}

class DataSourceForPromotionListScreen extends DataTableSource {
  BuildContext context;
  late List<Promotion> promotionList;
  Function() reloadDataCallback;

  DataSourceForPromotionListScreen(
    this.context,
    this.promotionList,
    this.reloadDataCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(Comparable<T> Function(Promotion d) getField, bool ascending) {
    promotionList.sort((a, b) {
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
  int get rowCount => promotionList.length;

  @override
  int get selectedRowCount => 0;

  onTap(Promotion promotion) {
    context.read<ProductDetailController>().mode == ViewMode.view;
    // context.read<ProductDetailController>().creatingProduct = promotion;
    Navigator.pushNamed(context, ProductDetailScreen.routeName);
  }

  DataRow _createRow(int index) {
    Promotion promotion = promotionList[index];
    return DataRow(
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text('${context.read<PromotionListController>().offset + index + 1}'),
        ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(promotion.productName ?? ''),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(
        //     '', //product.package ??
        //     style: TextStyle(
        //       color: Constants.successColor,
        //     ),
        //   ),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(
        //     '${0} Ks', //product.price ??
        //     overflow: TextOverflow.ellipsis,
        //     maxLines: 2,
        //   ),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(promotion.barcode ?? ''),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(
        //     '${promotion.priceListItem?.fixedPrice ?? 0} Ks', //
        //     overflow: TextOverflow.ellipsis,
        //     maxLines: 2,
        //   ),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(
        //     '${promotion.priceListItem?.fixedPrice ?? 0} Ks',
        //     overflow: TextOverflow.ellipsis,
        //     maxLines: 2,
        //   ),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(promotion.categoryId?.toString() ?? ''),
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(('').toUpperCase()), //product.productType?.name ??
        // ),
        // DataCell(
        //   onTap: () {
        //     onTap(promotion);
        //   },
        //   Text(''),
        // ),
      ],
    );
  }
}
