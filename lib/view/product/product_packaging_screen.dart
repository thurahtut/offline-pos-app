import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class ProductPackagingScreen extends StatefulWidget {
  const ProductPackagingScreen({super.key});
  static const String routeName = "/product_packaging_screen";

  @override
  State<ProductPackagingScreen> createState() => _ProductPackagingScreenState();
}

class _ProductPackagingScreenState extends State<ProductPackagingScreen> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  int _limit = 20;
  int _offset = 0;
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
      for (var i = 0; i < 20; i++) {
        context
            .read<ProductPackagingController>()
            .productPackagingList
            .add(CommonUtils.demoProductPackaging);
      }
      context
              .read<ProductPackagingController>()
              .productPackagingInfoDataSource =
          DataSourceForProductPackagingListScreen(
              context,
              context.read<ProductPackagingController>().productPackagingList,
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
              'Products Packaging',
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
        Expanded(child: _tableWidget()),
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
    return Row(
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
                  // context.read<ProductPackagingController>().isDetail = false;
                  // context.read<ProductPackagingController>().isNew = true;
                },
              ),
              SizedBox(width: 4),
              CommonUtils.svgIconActionButton('assets/svg/export_notes.svg'),
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
                    // width: 25,
                  ),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/view_list.svg'),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/grid_view.svg'),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton(
                      'assets/svg/calendar_month.svg'),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/alarm.svg'),
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
        child: context
                    .watch<ProductPackagingController>()
                    .productPackagingInfoDataSource !=
                null
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
            (_) => const BorderSide(width: 2, color: Constants.primaryColor)),
        checkColor: MaterialStateProperty.all(Constants.primaryColor),
      ),
      border: TableBorder(
          horizontalInside:
              BorderSide(color: Constants.disableColor.withOpacity(0.81))),
      rowsPerPage: min(
          _limit,
          context
              .read<ProductPackagingController>()
              .productPackagingList
              .length),
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
          text: 'Product',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          fixedWidth: isTabletMode == true ? 300 : 300,
          text: 'Contained Quantity',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Barcode',
        ),
        DataColumn2(
          fixedWidth: 20,
          label: PopupMenuButton(
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
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        title: Text('Routes'),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (bool? value) {},
                        controlAffinity: ListTileControlAffinity.leading,
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        title: Text('Purchase'),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (bool? value) {},
                        controlAffinity: ListTileControlAffinity.leading,
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        title: Text('Sale'),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (bool? value) {},
                        controlAffinity: ListTileControlAffinity.leading,
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
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
                              // width: width,
                              // height: height,
                              // iconColor: iconColor,
                              // onPressed: onPressed,
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
          ),

          // onSort: onSort,
        )
      ],
      source: context
          .read<ProductPackagingController>()
          .productPackagingInfoDataSource!,
    );
  }
}

class DataSourceForProductPackagingListScreen extends DataTableSource {
  BuildContext context;
  late List<ProductPackaging> productPackagingInfoList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForProductPackagingListScreen(
    this.context,
    this.productPackagingInfoList,
    this.offset,
    this.reloadDataCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(
      Comparable<T> Function(ProductPackaging d) getField, bool ascending) {
    productPackagingInfoList.sort((a, b) {
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
  int get rowCount => productPackagingInfoList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    ProductPackaging productPackaging = productPackagingInfoList[index];
    return DataRow(
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text('${index + 1}'),
        ),
        DataCell(
          onTap: () {
            // context.read<ProductPackagingController>().isDetail = true;
            // context.read<ProductPackagingController>().editingPaymentMethod =
            //     productPackaging;
          },
          Text(productPackaging.product ?? ''),
        ),
        DataCell(
          onTap: () {
            // context.read<ProductPackagingController>().isDetail = true;
            // context.read<ProductPackagingController>().editingPaymentMethod =
            //     productPackaging;
          },
          Text(
            '${productPackaging.containedQuantity ?? 0}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: () {
            // context.read<ProductPackagingController>().isDetail = true;
            // context.read<ProductPackagingController>().editingPaymentMethod =
            //     productPackaging;
          },
          Text(productPackaging.barcode ?? ''),
        ),
        DataCell(
          onTap: () {
            //   context.read<ProductPackagingController>().isDetail = true;
            //   context.read<ProductPackagingController>().editingPaymentMethod =
            //       productPackaging;
          },
          Text(''),
        ),
      ],
    );
  }
}

class ProductPackaging {
  String? product;
  int? containedQuantity;
  String? barcode;
  bool? routes;
  bool? purchase;
  bool? sale;
  bool? company;

  ProductPackaging(
      {this.product,
      this.containedQuantity,
      this.barcode,
      this.routes,
      this.purchase,
      this.sale,
      this.company});

  ProductPackaging.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    containedQuantity = json['contained_quantity'];
    barcode = json['barcode'];
    routes = json['routes'];
    purchase = json['purchase'];
    sale = json['sale'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product;
    data['contained_quantity'] = this.containedQuantity;
    data['barcode'] = this.barcode;
    data['routes'] = this.routes;
    data['purchase'] = this.purchase;
    data['sale'] = this.sale;
    data['company'] = this.company;
    return data;
  }
}
