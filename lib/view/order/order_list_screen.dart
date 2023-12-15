import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});
  static const String routeName = "/order_list_screen";

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  int _limit = 20;
  int _offset = 0;
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;

  static List<String> list = ["All Active Orders", "Quotation", "On Going"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      CommonUtils.orderHistoryList;
      for (var i = 0; i < 20; i++) {
        context
            .read<OrderListController>()
            .orderList
            .add(CommonUtils.demoOrderData);
      }
      context.read<OrderListController>().orderInfoDataSource =
          DataSourceForOrderListScreen(context,
              context.read<OrderListController>().orderList, _offset, () {});
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.currentOrderDividerColor,
      appBar: MyAppBar(),
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
            child:
                context.watch<OrderListController>().orderInfoDataSource != null
                    ? _orderHistoryListWidget()
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
          SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: BorderContainer(
              text: 'New Order',
              width: 140,
              containerColor: Constants.primaryColor,
              textColor: Colors.white,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    ModalRoute.withName("/Home"));
              },
            ),
          ),
          Expanded(flex: 4, child: SizedBox()),
          Expanded(flex: 4, child: _searchCustomerWidget()),
        ],
      ),
    );
  }

  static Widget _searchCustomerWidget() {
    TextEditingController searchOrderTextController = TextEditingController();
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
            controller: searchOrderTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: 'Search Orders',
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
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("| "),
                  DropdownButton(
                    value: list.first,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Constants.primaryColor,
                    ),
                    underline: Container(),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    items: list.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items,
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderHistoryListWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        context.read<OrderListController>().orderInfoDataSource == null
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
                  rowsPerPage: min(_limit,
                      context.read<OrderListController>().orderList.length),
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
                      fixedWidth: isTabletMode == true ? 300 : 300,
                      text: 'Date',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode ? 150 : 120,
                      text: 'Receipt Number',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 180,
                      text: 'Customer',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode ? 180 : null,
                      text: 'Employee',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 188,
                      text: 'Total',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 188,
                      text: 'State',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 188,
                      text: '',
                    ),
                  ],
                  source:
                      context.read<OrderListController>().orderInfoDataSource!,
                ),
              ),
        // _paginationWidget(),
      ],
    );
  }
}

class DataSourceForOrderListScreen extends DataTableSource {
  BuildContext context;
  late List<OrderDataModel> orderList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForOrderListScreen(
    this.context,
    this.orderList,
    this.offset,
    this.reloadDataCallback,
  );

  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(
      Comparable<T> Function(OrderDataModel d) getField, bool ascending) {
    orderList.sort((a, b) {
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
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    OrderDataModel order = orderList[index];
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
          Text(order.date ?? ''),
        ),
        DataCell(
          Text(order.receiptNumber ?? ''),
        ),
        DataCell(
          Text(order.customer ?? ''),
        ),
        DataCell(
          Text(order.employee ?? ''),
        ),
        DataCell(
          Text('${order.total?.toStringAsFixed(2) ?? '0.00'} Ks'),
        ),
        DataCell(
          Text(order.state ?? ''),
        ),
        DataCell(
          CommonUtils.svgIconActionButton('assets/svg/delete.svg'),
        ),
      ],
    );
  }
}

class OrderDataModel {
  String? date;
  String? receiptNumber;
  String? customer;
  String? employee;
  double? total;
  String? state;

  OrderDataModel(
      {this.date,
      this.receiptNumber,
      this.customer,
      this.employee,
      this.total,
      this.state});

  OrderDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    receiptNumber = json['receipt_number'];
    customer = json['customer'];
    employee = json['employee'];
    total = json['total'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['receipt_number'] = receiptNumber;
    data['customer'] = customer;
    data['employee'] = employee;
    data['total'] = total;
    data['state'] = state;
    return data;
  }
}
