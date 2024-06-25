import 'dart:convert';
import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

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
  // String headerString = "";
  DateTime selectedDate = CommonUtils.getDateTimeNow();
  // final ValueNotifier<DateTime?> _dateTimeNotifier = ValueNotifier(null);

  static List<String> stateFilterlist = [
    "All Active Orders",
    OrderState.draft.text,
    OrderState.paid.text,
  ];

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
      body: _bodyWidget(),
    );
  }

  Future<void> updateOrderHistoryListToTable() async {
    List<OrderHistory> list = context.read<OrderListController>().orderList;
    context.read<OrderListController>().orderInfoDataSource =
        DataSourceForOrderListScreen(
      context,
      orderList: list,
      offset: context.read<OrderListController>().offset,
      reloadDataCallback: () {},
      deletedCallback: () {
        getAllOrderHistory();
      },
      goToPOSScreen: (order) {
        if (context.read<OrderListController>().isRefund == true) {
          if (order.state == OrderState.draft.text) {
            CommonUtils.showSnackBar(
                message: 'Draft Order can\'t refund!', context: context);
            return;
          }
          _refundOrder(order);
        } else if (order.state == OrderState.draft.text) {
          _reBuildingOrder(order, true);
        } else if (order.state == OrderState.paid.text) {
          Navigator.pushNamed(context, OrderDetailScreen.routeName,
              arguments: OrderDetailScreen(orderId: order.id ?? 0));
        }
      },
      printOrder: (order) {
        _reBuildingOrder(order, false);
      },
    );
  }

  void _reBuildingOrder(OrderHistory order, bool isDraft) {
    OrderHistoryTable.getOrderById(order.id).then(
      (value) {
        if (value != null) {
          CurrentOrderController currentOrderController =
              context.read<CurrentOrderController>();
          currentOrderController.resetCurrentOrderController();
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
          currentOrderController.currentOrderList = [];
          ProductTable.getProductListByIds(productIds).then((products) async {
            for (OrderLineID data in value.lineIds ?? []) {
              for (Product product in products) {
                Product prod = Product.fromJson(
                  jsonDecode(jsonEncode(product)),
                  includedOtherField: true,
                );
                if (prod.productVariantIds == data.productId) {
                  prod.onhandQuantity = data.qty?.toInt();
                  prod.priceListItem?.fixedPrice = data.priceUnit?.toInt() ?? 0;
                  prod.isPromoItem = data.isPromoItem;
                  prod.parentPromotionId = data.parentPromotionId;
                  prod.onOrderPromo = data.onOrderPromo;
                  if (prod.isPromoItem != true) {
                    List<Promotion> promotionList =
                        await PromotionTable.getPromotionByProductId(
                            prod.productId ?? 0, value.sessionId ?? 0);
                    prod.promotionList = promotionList;
                  }
                  prod.discount = data.discount;
                  prod.shDiscountCode = data.shDiscountCode;
                  prod.shDiscountReason = data.shDiscountReason;
                  currentOrderController.currentOrderList.add(prod);
                  break;
                }
              }
            }
            if (isDraft) {
              PendingOrderTable.insertOrUpdatePendingOrderWithDB(
                  value: jsonEncode(currentOrderController.orderHistory));

              PendingOrderTable.insertOrUpdateCurrentOrderListWithDB(
                  productList: jsonEncode(products));

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            resetController: false,
                          )),
                  ModalRoute.withName("/Home"),
                );
              }
            } else {
              PaymentTransactionTable.getPaymentTransactionListByOrderId(
                      order.id ?? 0)
                  .then((tranList) {
                currentOrderController.paymentTransactionList = tranList;
                if (context.read<OrderListController>().isRefund == true) {
                  Navigator.pushNamed(
                    context,
                    RefundOrderScreen.routeName,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    OrderPaymentReceiptScreen.routeName,
                    arguments: OrderPaymentReceiptScreen(isNewOrder: false),
                  );
                }
              });
            }
          });
        }
      },
    );
  }

  void _refundOrder(OrderHistory order) {
    OrderHistoryTable.getOrderById(order.id).then(
      (value) {
        if (value != null) {
          RefundOrderController refundOrderController =
              context.read<RefundOrderController>();
          refundOrderController.resetRefundOrderController();
          refundOrderController.orderHistory = value;
          refundOrderController.selectedCustomer = (value.partnerId != 0
              ? Customer(
                  id: value.partnerId,
                  name: value.partnerName,
                )
              : null);
          List<int> productIds = [];
          for (OrderLineID data in value.lineIds ?? []) {
            productIds.add(data.productId ?? 0);
          }
          refundOrderController.currentOrderList = [];
          ProductTable.getProductListByIds(productIds).then((products) async {
            for (OrderLineID data in value.lineIds ?? []) {
              for (Product product in products) {
                Product prod = Product.fromJson(
                  product.toJson(removed: false),
                  includedOtherField: true,
                );
                if (prod.productVariantIds == data.productId) {
                  prod.onhandQuantity = data.qty?.toInt();
                  prod.priceListItem?.fixedPrice = data.priceUnit?.toInt() ?? 0;
                  prod.isPromoItem = data.isPromoItem;
                  prod.parentPromotionId = data.parentPromotionId;
                  prod.onOrderPromo = data.onOrderPromo;
                  if (prod.isPromoItem != true) {
                    List<Promotion> promotionList =
                        await PromotionTable.getPromotionByProductId(
                            prod.productId ?? 0, value.sessionId ?? 0);
                    prod.promotionList = promotionList;
                  }
                  prod.discount = data.discount;
                  prod.shDiscountCode = data.shDiscountCode;
                  prod.shDiscountReason = data.shDiscountReason;
                  prod.lineId = data.id;
                  prod.refundedOrderLineId = data.refundedOrderLineId;
                  prod.odooOrderLineId = data.odooOrderLineId;
                  prod.packageId = data.packageId;
                  prod.packageQty = data.packageQty;
                  prod.packaging = data.packaging;
                  refundOrderController.currentOrderList.add(prod);
                  break;
                }
              }
            }

            await Navigator.pushNamed(
              context,
              RefundOrderScreen.routeName,
            );
            OrderHistory? refundOrderHistory =
                await OrderHistoryTable.getOrderById(
                    refundOrderController.orderId);
            if (refundOrderHistory?.state != OrderState.paid.text) {
              OrderHistoryTable.deleteByOrderId(
                  orderHistoryId: refundOrderController.orderId ?? 0);
            }
            refundOrderController.resetRefundOrderController();
          });
        }
      },
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
                context.read<OrderListController>().isRefund = false;
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
                context.read<OrderListController>().isRefund = false;
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
          SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Consumer<OrderListController>(builder: (_, controller, __) {
              return BorderContainer(
                text: controller.dateFilter != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.dateFilter!)
                        .toString()
                    : 'dd--yyyy',
                suffixSvg: 'assets/svg/calendar_month.svg',
                svgColor: primaryColor,
                // width: 140,
                onTap: () {
                  _showDateTimePicker();
                },
              );
            }),
          ),
          SizedBox(width: 5),
          Expanded(flex: 4, child: _searchCustomerWidget()),
        ],
      ),
    );
  }

  Widget _searchCustomerWidget() {
    TextEditingController searchOrderTextController = TextEditingController();
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Consumer<OrderListController>(builder: (_, controller, __) {
          return Container(
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
            child: TextFormField(
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
                hintStyle:
                    TextStyle(fontSize: 14, color: Constants.disableColor),
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
                    DropdownButton<String>(
                      value: stateFilterlist
                              .contains(controller.typefilterValue ?? '')
                          ? controller.typefilterValue
                          : stateFilterlist.first,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor,
                      ),
                      underline: Container(),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      items: stateFilterlist.map(
                        (String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items.toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (String? newValue) {
                        if (newValue == OrderState.draft.text ||
                            newValue == OrderState.paid.text) {
                          controller.typefilterValue = newValue;
                        } else {
                          controller.typefilterValue = null;
                        }
                        controller.offset = 0;
                        getAllOrderHistory();
                      },
                    )
                  ],
                ),
              ),
              onFieldSubmitted: (value) {
                controller.filterValue = value.isNotEmpty ? value : null;
                controller.offset = 0;
                getAllOrderHistory();
              },
            ),
          );
        }),
      ),
    );
  }

  Future<void> _showDateTimePicker() {
    return CommonUtils.showGeneralDialogWidget(
        context,
        (context, animation, secondaryAnimation) => Dialog(
              insetPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.white,
                        child: _buildTableCalendarWithBuilders(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<OrderListController>().dateFilter =
                                  null;
                              context.read<OrderListController>().offset = 0;
                              getAllOrderHistory();
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<OrderListController>().dateFilter =
                                  CommonUtils.getDateTimeNow();
                              context.read<OrderListController>().offset = 0;
                              getAllOrderHistory();
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget _buildTableCalendarWithBuilders() {
    var textStyle = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return Consumer<OrderListController>(builder: (_, controller, __) {
      return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime(CommonUtils.getDateTimeNow().year + 100, 1),
        focusedDay: controller.dateFilter ?? CommonUtils.getDateTimeNow(),
        pageJumpingEnabled: true,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Constants.accentColor,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Constants.accentColor,
            size: 28,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            final text = DateFormat.E().format(day);
            Color color = Colors.black;
            if (day.weekday == DateTime.sunday ||
                day.weekday == DateTime.saturday) {
              color = Constants.accentColor;
            }
            return Center(
              child: Text(
                text,
                style: textStyle.copyWith(color: color),
              ),
            );
          },
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: textStyle.copyWith(
            color: Constants.disableColor,
          ),
          weekendTextStyle: textStyle.copyWith(color: Constants.accentColor),
          outsideDaysVisible: false,
          todayTextStyle: textStyle.copyWith(
            color: primaryColor,
          ),
          selectedTextStyle: textStyle.copyWith(
            color: Colors.white,
          ),
          todayDecoration: BoxDecoration(),
        ),
        onHeaderTapped: (focusedDay) {
          Navigator.pop(context);
          _yearPicker();
        },
        onDaySelected: (date, events) {
          context.read<OrderListController>().dateFilter = date;
          controller.offset = 0;
          getAllOrderHistory();
          Navigator.pop(context);
        },
        selectedDayPredicate: (day) => isSameDay(day, controller.dateFilter),
      );
    });
  }

  void _yearPicker() {
    showDialog(
      context: context,
      builder: (BuildContext bContext) {
        return AlertDialog(
          title: Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(CommonUtils.getDateTimeNow().year - 100, 1),
              lastDate: DateTime(CommonUtils.getDateTimeNow().year + 100, 1),
              selectedDate: context.read<OrderListController>().dateFilter ??
                  CommonUtils.getDateTimeNow(),
              onChanged: (DateTime dateTime) {
                context.read<OrderListController>().dateFilter =
                    DateTime(dateTime.year);
                Navigator.pop(bContext);
                _showDateTimePicker();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _orderHistoryListWidget(OrderListController controller) {
    return Stack(
      alignment: Alignment.bottomLeft,
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
                  minWidth: MediaQuery.of(context).size.width,
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
                      text: 'Session',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode ? 150 : 120,
                      text: 'Sequence Number',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
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
  Function(OrderHistory order) goToPOSScreen;
  Function(OrderHistory order) printOrder;

  DataSourceForOrderListScreen(
    this.context, {
    required this.orderList,
    required this.offset,
    required this.reloadDataCallback,
    required this.deletedCallback,
    required this.goToPOSScreen,
    required this.printOrder,
  });

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
      goToPOSScreen(order);
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
          Text(order.sessionName ?? ''),
          // onTap: onTap,
        ),
        DataCell(
          Text(order.sequenceNumber ?? ''),
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
          Row(
            children: [
              if (order.state == OrderState.draft.text)
                CommonUtils.svgIconActionButton(
                  'assets/svg/delete.svg',
                  onPressed: () async {
                    showDialog(
                      context: NavigationService.navigatorKey.currentContext!,
                      builder: (BuildContext bContext) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade200,
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Are you sure !',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          insetPadding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          content: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 32),
                            color: Colors.white,
                            child: Text(
                              'Do you want to delete this order?',
                              style: TextStyle(
                                color: Colors.red.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          actions: [
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(top: 16),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text("Cancel")),
                              onTap: () {
                                Navigator.of(bContext).pop();
                              },
                            ),
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(top: 16),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text("Ok")),
                              onTap: () {
                                Navigator.of(bContext).pop();
                                if (order.state != OrderState.draft.text) {
                                  CommonUtils.showSnackBar(
                                    context: context,
                                    message:
                                        'This order is not allowed to delete!',
                                  );
                                  return;
                                }
                                OrderHistoryTable.getOrderHistoryList(
                                  isCloseSession: false,
                                  orderHistoryId: order.id ?? 0,
                                ).then((value) async {
                                  for (var mapArg in value) {
                                    String orderStr = jsonEncode(mapArg);
                                    int employeeId = context
                                            .read<LoginUserController>()
                                            .loginEmployee
                                            ?.id ??
                                        0;
                                    String employeeName = context
                                            .read<LoginUserController>()
                                            .loginEmployee
                                            ?.name ??
                                        '';
                                    CommonUtils.saveOrderDeleteLogs(
                                      orderStr,
                                      employeeName,
                                      employeeId,
                                      false,
                                    );
                                  }
                                  final Database db = await DatabaseHelper().db;
                                  db.transaction((txn) async {
                                    await PaymentTransactionTable
                                        .deleteByOrderId(
                                            txn: txn, orderID: order.id ?? 0);
                                    await OrderLineIdTable.deleteByOrderId(
                                        txn: txn, orderID: order.id ?? 0);
                                    await OrderHistoryTable.deleteByOrderId(
                                        txn: txn,
                                        orderHistoryId: order.id ?? 0);
                                    deletedCallback();
                                  });
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              if (order.state == OrderState.paid.text)
                CommonUtils.svgIconActionButton(
                  'assets/svg/print.svg',
                  onPressed: () async {
                    if (order.state != OrderState.paid.text) {
                      CommonUtils.showSnackBar(
                        context: context,
                        message: 'This order is not allowed to print!',
                      );
                      return;
                    }
                    printOrder(order);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
