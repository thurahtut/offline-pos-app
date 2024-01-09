import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class QuotationOrderListScreen extends StatefulWidget {
  const QuotationOrderListScreen({super.key});
  static const String routeName = "/quotation_order_list_screen";

  @override
  State<QuotationOrderListScreen> createState() =>
      _QuotationOrderListScreenState();
}

class _QuotationOrderListScreenState extends State<QuotationOrderListScreen> {
  int _limit = 20;
  int _offset = 0;
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      CommonUtils.orderHistoryList;
      for (var i = 0; i < 20; i++) {
        context
            .read<QuotationOrderListController>()
            .quotationList
            .add(CommonUtils.demoQuotationData);
      }
      context.read<QuotationOrderListController>().quotationInfoDataSource =
          DataSourceForQuotationListScreen(
              context,
              context.read<QuotationOrderListController>().quotationList,
              _offset,
              () {});
      setState(() {});
    });
    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.currentOrderDividerColor,
      appBar: SaleAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isTabletMode == true
                ? 15
                : MediaQuery.of(context).size.width / 9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _headerActionWidget(),
            _tableWidget(),
          ],
        ),
      ),
    );
  }

  Widget _tableWidget() {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height - 200,
            ),
            child: context
                        .watch<QuotationOrderListController>()
                        .quotationInfoDataSource !=
                    null
                ? _quotationListWidget()
                : SizedBox(),
          ),
        ),
      ),
    );
  }

  SizedBox _headerActionWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: BorderContainer(
              text: 'Back',
              // containerColor: Colors.white,
              width: 140,
              borderWithPrimaryColor: true,
              textColor: Constants.primaryColor,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    ModalRoute.withName("/Home"));
              },
            ),
          ),
          Expanded(flex: 5, child: SizedBox()),
          Expanded(flex: 3, child: _searchCustomerWidget()),
        ],
      ),
    );
  }

  static Widget _searchCustomerWidget() {
    TextEditingController searchCustomerTextController =
        TextEditingController();
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Constants.greyColor2.withOpacity(0.6),
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: searchCustomerTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: 'Search Customers',
              hintStyle: TextStyle(fontSize: 14, color: Constants.disableColor),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _quotationListWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        context.read<QuotationOrderListController>().quotationInfoDataSource ==
                null
            ? SizedBox()
            : Theme(
                data: Theme.of(context).copyWith(
                  cardTheme: CardTheme(
                    elevation: 0,
                    color: Constants.greyColor.withOpacity(0.85),
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                child: PaginatedDataTable2(
                  dataRowHeight: 70,
                  headingRowHeight: 70,
                  dividerThickness: 0.0,
                  rowsPerPage: min(
                      _limit,
                      context
                          .read<QuotationOrderListController>()
                          .quotationList
                          .length),
                  minWidth: MediaQuery.of(context).size.width - 100,
                  showCheckboxColumn: false,
                  fit: FlexFit.tight,
                  hidePaginator: true,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending ?? false,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Constants.primaryColor),
                  columns: [
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode ? 150 : 120,
                      text: 'Order',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      fixedWidth: isTabletMode == true ? 300 : 300,
                      text: 'Date',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 180,
                      text: 'Customer',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode ? 180 : null,
                      text: 'Sale Person',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 188,
                      text: 'Total',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 188,
                      text: 'State',
                    ),
                  ],
                  source: context
                      .read<QuotationOrderListController>()
                      .quotationInfoDataSource!,
                ),
              ),
        // _paginationWidget(),
      ],
    );
  }
}

class DataSourceForQuotationListScreen extends DataTableSource {
  BuildContext context;
  late List<QuotationDataModel> quotationList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForQuotationListScreen(
    this.context,
    this.quotationList,
    this.offset,
    this.reloadDataCallback,
  );

  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(
      Comparable<T> Function(QuotationDataModel d) getField, bool ascending) {
    quotationList.sort((a, b) {
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
  int get rowCount => quotationList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    QuotationDataModel quotation = quotationList[index];
    return DataRow(
      onSelectChanged: (value) {
        // (NavigationService.navigatorKey.currentContext ?? context).goNamed(
        //   EditUserScreen.routeName,
        //   pathParameters: {
        //     "id": userInfo.id.toString(),
        //   },
        // );
      },
      cells: [
        DataCell(
          Text(quotation.order ?? ''),
        ),
        DataCell(
          Text(quotation.date ?? ''),
        ),
        DataCell(
          Text(quotation.customer ?? ''),
        ),
        DataCell(
          Text(quotation.salePerson ?? ''),
        ),
        DataCell(
          Text('${quotation.total?.toStringAsFixed(2) ?? '0.00'} Ks'),
        ),
        DataCell(
          Text(quotation.state ?? ''),
        ),
      ],
    );
  }
}

class QuotationDataModel {
  String? order;
  String? date;
  String? customer;
  String? salePerson;
  double? total;
  String? state;

  QuotationDataModel(
      {this.order,
      this.date,
      this.customer,
      this.salePerson,
      this.total,
      this.state});

  QuotationDataModel.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    date = json['date'];
    customer = json['customer'];
    salePerson = json['sale_person'];
    total = json['total'];
    state = json['state'];
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = order;
    data['date'] = date;
    data['customer'] = customer;
    data['sale_person'] = salePerson;
    data['total'] = total;
    data['state'] = state;
    return data;
  }
}
