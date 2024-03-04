import 'dart:convert';
import 'dart:math' as math;

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/order/order_detail_screen.dart';
import 'package:sqflite/sqflite.dart';

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
    await context
        .read<OrderListController>()
        .getAllOrderHistory()
        .then((value) {
      updateOrderHistoryListToTable();
      context.read<OrderListController>().loading = false;
    });
  }

  Future<void> updateOrderHistoryListToTable() async {
    List<OrderHistory> list = context.read<OrderListController>().orderList;
    context.read<OrderListController>().orderInfoDataSource =
        DataSourceForOrderListScreen(
      context,
      list,
      context.read<OrderListController>().offset,
      () {},
      () {
        getAllOrderHistory();
      },
    );
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
          child: Consumer<OrderListController>(builder: (_, controller, __) {
            return Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height - 100,
              ),
              child: controller.orderInfoDataSource != null
                  ? _orderHistoryListWidget(controller)
                  : SizedBox(),
            );
          }),
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
          CommonUtils.iconActionButton(Icons.refresh_rounded, onPressed: () {
            context.read<OrderListController>().offset = 0;
            context.read<OrderListController>().currentIndex = 1;
            getAllOrderHistory();
          }),
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

  Widget _orderHistoryListWidget(OrderListController controller) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        controller.orderInfoDataSource == null
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
                  key: UniqueKey(),
                  dataRowHeight: 70,
                  headingRowHeight: 70,
                  dividerThickness: 0.0,
                  rowsPerPage: math.min(controller.limit,
                      math.max(controller.orderList.length, 1)),
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
                  source: controller.orderInfoDataSource!,
                ),
              ),
        _paginationWidget(controller),
      ],
    );
  }

  Widget _paginationWidget(OrderListController controller) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        FlutterCustomPagination(
          currentPage: controller.currentIndex,
          limitPerPage: controller.limit,
          totalDataCount: controller.total,
          onPreviousPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllOrderHistory();
          },
          onBackToFirstPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllOrderHistory();
          },
          onNextPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllOrderHistory();
          },
          onGoToLastPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
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
  }
}

class DataSourceForOrderListScreen extends DataTableSource {
  BuildContext context;
  late List<OrderHistory> orderList;
  int offset;
  Function() reloadDataCallback;
  Function() deletedCallback;

  DataSourceForOrderListScreen(
    this.context,
    this.orderList,
    this.offset,
    this.reloadDataCallback,
    this.deletedCallback,
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
      if (order.state == OrderState.draft.text) {
        OrderHistoryTable.getOrderById(order.id).then(
          (value) {
            if (value != null) {
              CurrentOrderController currentOrderController =
                  context.read<CurrentOrderController>();
              currentOrderController.orderHistory = value;
              currentOrderController.selectedCustomer = (value.partnerId != 0
                  ? Customer(
                      id: value.partnerId,
                      name: value.partnerName,
                    )
                  : null);
              List<int> productIds = [];
              for (OrderLineID data in value.lineIds ?? []) {
                productIds.add(data.productId ?? 0);
              }
              ProductTable.getProductListByIds(productIds).then((products) {
                for (OrderLineID data in value.lineIds ?? []) {
                  for (Product product in products) {
                    if (product.productVariantIds?.contains(data.productId) ??
                        false) {
                      product.onhandQuantity = data.qty?.toInt();
                      product.priceListItem?.fixedPrice =
                          data.priceUnit?.toInt() ?? 0;
                    }
                  }
                }
                currentOrderController.currentOrderList = products;
                PendingOrderTable.insertOrUpdatePendingOrderWithDB(
                    value: jsonEncode(currentOrderController.orderHistory));

                PendingOrderTable.insertOrUpdatePendingOrderWithDB(
                    value: jsonEncode(products));

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            resetController: false,
                          )),
                  ModalRoute.withName("/Home"),
                );
              });
            }
          },
        );
      } else {
        Navigator.pushNamed(context, OrderDetailScreen.routeName,
            arguments: OrderDetailScreen(orderId: order.id ?? 0));
      }
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
          Text(order.state?.toUpperCase() ?? ''),
          // onTap: onTap,
        ),
        DataCell(
          order.state == OrderState.draft.text
              ? CommonUtils.svgIconActionButton(
                  'assets/svg/delete.svg',
                  onPressed: () async {
                    if (order.state != OrderState.draft.text) {
                      CommonUtils.showSnackBar(
                        context: context,
                        message: 'This order is not allowed to delete!',
                      );
                      return;
                    }
                    OrderHistoryTable.getOrderHistoryList(
                      isCloseSession: false,
                      orderHistoryId: order.id ?? 0,
                    ).then((value) async {
                      for (var mapArg in value) {
                        String orderStr = jsonEncode(mapArg);
                        CommonUtils.saveOrderDeleteLogs(orderStr);
                      }
                      final Database db = await DatabaseHelper().db;
                      db.transaction((txn) async {
                        await PaymentTransactionTable.deleteByOrderId(
                            txn: txn, orderID: order.id ?? 0);
                        await OrderLineIdTable.deleteByOrderId(
                            txn: txn, orderID: order.id ?? 0);
                        await OrderHistoryTable.deleteByOrderId(
                            txn: txn, orderHistoryId: order.id ?? 0);
                        deletedCallback();
                      });
                    });
                  },
                )
              : Text(""),
        ),
      ],
    );
  }
}
