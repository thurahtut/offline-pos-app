import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  static const String routeName = "/product_list_screen";

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
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
            .read<ProductListController>()
            .productList
            .add(CommonUtils.demoProduct);
      }
      context.read<ProductListController>().productInfoDataSource =
          DataSourceForProductListScreen(
              context,
              context.read<ProductListController>().productList,
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
              'Products',
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
                  // context.read<ProductListController>().isDetail = false;
                  // context.read<ProductListController>().isNew = true;
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
            context.watch<ProductListController>().productInfoDataSource != null
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
      rowsPerPage:
          min(_limit, context.read<ProductListController>().productList.length),
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
          text: 'Product Name',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          fixedWidth: isTabletMode == true ? 300 : 300,
          text: 'Product',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          fixedWidth: isTabletMode == true ? 300 : 300,
          text: 'Price',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Barcode',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Sale Price',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Latest Price',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Product Category',
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Product Type',
        ),
        DataColumn2(
          fixedWidth: 20,
          label: _moreInfoWidget(),

          // onSort: onSort,
        )
      ],
      source: context.read<ProductListController>().productInfoDataSource!,
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
                  title: Text('Responsible'),
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
                  title: Text('Favorite'),
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
                  title: Text('Website'),
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
                  title: Text('Company'),
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
                  title: Text('Sales Price'),
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
                  title: Text('Latest Price'),
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
                  title: Text('Cost'),
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
                  title: Text('POS Product Category'),
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
                  title: Text('Product Type'),
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
                  title: Text('Forecasted Quantity'),
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

class DataSourceForProductListScreen extends DataTableSource {
  BuildContext context;
  late List<Product> productList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForProductListScreen(
    this.context,
    this.productList,
    this.offset,
    this.reloadDataCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(Comparable<T> Function(Product d) getField, bool ascending) {
    productList.sort((a, b) {
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
  int get rowCount => productList.length;

  @override
  int get selectedRowCount => 0;

  onTap() {
    Navigator.pushNamed(context, ProductDetailScreen.routeName);
  }

  DataRow _createRow(int index) {
    Product product = productList[index];
    return DataRow(
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text('${index + 1}'),
        ),
        DataCell(
          onTap: onTap,
          Text(product.productName ?? ''),
        ),
        DataCell(
          onTap: onTap,
          Text(
            product.package ?? '',
            style: TextStyle(
              color: Constants.successColor,
            ),
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${product.price ?? 0} Ks',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(product.barcode ?? ''),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${product.salePrice ?? 0} Ks',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(
            '${product.latestPrice ?? 0} Ks',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: onTap,
          Text(product.productCategory ?? ''),
        ),
        DataCell(
          onTap: onTap,
          Text(product.productType.toString()),
        ),
        DataCell(
          onTap: onTap,
          Text(''),
        ),
      ],
    );
  }
}
