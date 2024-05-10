import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:table_calendar/table_calendar.dart';

class RefundedOrderListScreen extends StatefulWidget {
  const RefundedOrderListScreen({super.key, this.orderId});
  static const String routeName = "/refunded_order_list_screen";
  final int? orderId;

  @override
  State<RefundedOrderListScreen> createState() =>
      _RefundedOrderListScreenState();
}

class _RefundedOrderListScreenState extends State<RefundedOrderListScreen> {
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
    context.read<RefundedOrderListController>().loading = true;
    await context
        .read<RefundedOrderListController>()
        .getAllOrderHistory(parentOrderIdForRefundedOrder: widget.orderId)
        .then((value) {
      updateOrderHistoryListToTable();
      context.read<RefundedOrderListController>().loading = false;
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
    List<OrderHistory> list =
        context.read<RefundedOrderListController>().orderList;
    context.read<RefundedOrderListController>().orderInfoDataSource =
        DataSourceForRefundedOrderListScreen(
      context,
      orderList: list,
      offset: context.read<RefundedOrderListController>().offset,
      reloadDataCallback: () {},
      goToPOSScreen: (order) {
        Navigator.pushNamed(context, RefundedOrderDetailScreen.routeName,
            arguments: RefundedOrderDetailScreen(orderId: order.id ?? 0));
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
          child: Consumer<RefundedOrderListController>(
              builder: (_, controller, __) {
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
                context.read<RefundedOrderListController>().isRefund = false;
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
                context.read<RefundedOrderListController>().isRefund = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    ModalRoute.withName("/Home"));
              },
            ),
          ),
          Expanded(flex: 4, child: SizedBox()),
          CommonUtils.iconActionButton(Icons.refresh_rounded, onPressed: () {
            context.read<RefundedOrderListController>().offset = 0;
            context.read<RefundedOrderListController>().currentIndex = 1;
            getAllOrderHistory();
          }),
          SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Consumer<RefundedOrderListController>(
                builder: (_, controller, __) {
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
        child:
            Consumer<RefundedOrderListController>(builder: (_, controller, __) {
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
                              context
                                  .read<RefundedOrderListController>()
                                  .dateFilter = null;
                              context
                                  .read<RefundedOrderListController>()
                                  .offset = 0;
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
                              context
                                  .read<RefundedOrderListController>()
                                  .dateFilter = CommonUtils.getDateTimeNow();
                              context
                                  .read<RefundedOrderListController>()
                                  .offset = 0;
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
    return Consumer<RefundedOrderListController>(builder: (_, controller, __) {
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
          context.read<RefundedOrderListController>().dateFilter = date;
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
              selectedDate:
                  context.read<RefundedOrderListController>().dateFilter ??
                      CommonUtils.getDateTimeNow(),
              onChanged: (DateTime dateTime) {
                context.read<RefundedOrderListController>().dateFilter =
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

  Widget _orderHistoryListWidget(RefundedOrderListController controller) {
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
                  ],
                  source: controller.orderInfoDataSource!,
                ),
              ),
        _paginationWidget(controller),
      ],
    );
  }

  Widget _paginationWidget(RefundedOrderListController controller) {
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

class DataSourceForRefundedOrderListScreen extends DataTableSource {
  BuildContext context;
  late List<OrderHistory> orderList;
  int offset;
  Function() reloadDataCallback;
  Function(OrderHistory order) goToPOSScreen;

  DataSourceForRefundedOrderListScreen(
    this.context, {
    required this.orderList,
    required this.offset,
    required this.reloadDataCallback,
    required this.goToPOSScreen,
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
      ],
    );
  }
}
