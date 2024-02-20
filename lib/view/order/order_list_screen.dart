import 'dart:math';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/order/order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});
  static const String routeName = "/order_list_screen";

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;
  final scrollController = ScrollController();

  static List<String> list = ["All Active Orders", "Quotation", "On Going"];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getAllOrderHistory() async {
    context.read<OrderListController>().loading = true;
    context.read<OrderListController>().getAllOrderHistory().then((value) {
      updateOrderHistoryListToTable();
      context.read<OrderListController>().loading = false;
    });
  }

  Future<void> updateOrderHistoryListToTable() async {
    context.read<OrderListController>().orderInfoDataSource =
        DataSourceForOrderListScreen(
            context,
            context.read<OrderListController>().orderList,
            context.read<OrderListController>().offset,
            () {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      getAllOrderHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.currentOrderDividerColor,
      // appBar: SaleAppBar(),
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
              maxHeight: MediaQuery.of(context).size.height - 100,
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
              textColor: primaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: BorderContainer(
              text: 'New Order',
              width: 140,
              containerColor: primaryColor,
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
                    primaryColor,
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
                      color: primaryColor,
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
                  rowsPerPage: min(
                      context.read<OrderListController>().limit,
                      max(context.read<OrderListController>().orderList.length,
                          1)),
                  minWidth: MediaQuery.of(context).size.width + 400,
                  showCheckboxColumn: false,
                  fit: FlexFit.tight,
                  hidePaginator: true,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending ?? false,
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => primaryColor),
                  columns: [
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode == true ? 300 : 300,
                      text: 'Order Condition',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode == true ? 300 : 300,
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
        _paginationWidget(),
      ],
    );
  }

  Widget _paginationWidget() {
    return Consumer<OrderListController>(builder: (_, controller, __) {
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
              getAllOrderHistory();
            },
            onBackToFirstPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllOrderHistory();
            },
            onNextPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllOrderHistory();
            },
            onGoToLastPage: (pageNo) {
              controller.offset =
                  (controller.limit * pageNo) - controller.limit;
              controller.currentIndex = pageNo;
              getAllOrderHistory();
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
}

class DataSourceForOrderListScreen extends DataTableSource {
  BuildContext context;
  late List<OrderHistory> orderList;
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
      Comparable<T> Function(OrderHistory d) getField, bool ascending) {
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
    OrderHistory order = orderList[index];

    onTap() {
      Navigator.pushNamed(context, OrderDetailScreen.routeName,
          arguments: OrderDetailScreen(orderId: order.id ?? 0));
    }

    return DataRow(
      onSelectChanged: (value) {
        onTap();
      },
      cells: [
        DataCell(
          Stack(
            alignment: Alignment.center,
            children: order.orderCondition != OrderCondition.sync.text
                ? [
                    Text(
                      "_",
                      style: TextStyle(
                        color: Constants.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]
                : [
                    Icon(
                      Icons.label_rounded,
                      color: primaryColor,
                      size: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        OrderCondition.sync.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
          ),
          // onTap: onTap,
        ),
        DataCell(
          Text(
            CommonUtils.getLocaleDateTime(
              "hh:mm:ss dd-MM-yyyy",
              order.createDate,
            ),
          ),
          // onTap: onTap,
        ),
        DataCell(
          Text(order.receiptNumber ?? ''),
          // onTap: onTap,
        ),
        DataCell(
          Text(order.partnerName ?? ''),
          // onTap: onTap,
        ),
        DataCell(
          Text(order.employeeName ?? ''),
          // onTap: onTap,
        ),
        DataCell(
          Text('${order.amountTotal?.toStringAsFixed(2) ?? '0.00'} Ks'),
          // onTap: onTap,
        ),
        DataCell(
          Text(order.state ?? ''),
          // onTap: onTap,
        ),
        DataCell(
          CommonUtils.svgIconActionButton('assets/svg/delete.svg'),
        ),
      ],
    );
  }
}
