import 'dart:math';

import 'package:intl/intl.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:table_calendar/table_calendar.dart';

class OrderHistoryListScreen extends StatefulWidget {
  const OrderHistoryListScreen({super.key});
  static const String routeName = "/order_history_list_screen";

  @override
  State<OrderHistoryListScreen> createState() => _OrderHistoryListScreenState();
}

class _OrderHistoryListScreenState extends State<OrderHistoryListScreen> {
  int _limit = 20;
  int _offset = 0;
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;
  String headerString = "";
  DateTime selectedDate = DateTime.now();
  final ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier(DateTime.now());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      headerString = DateFormat('MMMM yyyy').format(DateTime.now()).toString();
      isTabletMode = CommonUtils.isTabletMode(context);
      CommonUtils.orderHistoryList;
      for (var i = 0; i < 20; i++) {
        context
            .read<OrderHistoryListController>()
            .orderHistoryList
            .add(CommonUtils.orderHistoryList.first);
      }
      context.read<OrderHistoryListController>().orderHistoryInfoDataSource =
          DataSourceForOrderHistoryListScreen(
              context,
              context.read<OrderHistoryListController>().orderHistoryList,
              _offset,
              () {});
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
            child: context
                        .watch<OrderHistoryListController>()
                        .orderHistoryInfoDataSource !=
                    null
                ? _orderHistoryListWidget()
                : SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget _headerActionWidget() {
    var child = SizedBox(
      width: MediaQuery.of(context).size.width -
          (isTabletMode == true ? 15 : MediaQuery.of(context).size.width / 9),
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width -
                ((isTabletMode == true
                        ? 15
                        : MediaQuery.of(context).size.width / 9) *
                    2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: BorderContainer(
                text: 'Discard',
                containerColor: Colors.white,
                // width: 140,
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
              child: InkWell(
                onTap: () {},
                child: Container(
                  // width: 80,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white,
                    border: Border.all(
                      color: Constants.primaryColor,
                    ),
                  ),
                  child: CommonUtils.svgIconActionButton(
                    'assets/svg/keyboard_return.svg',
                    iconColor: Constants.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: BorderContainer(
                text: 'Paid',
                // width: 140,
                containerColor: Constants.primaryColor,
                textColor: Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: BorderContainer(
                text: 'Posted',
                containerColor: Colors.white,
                // width: 140,
                borderWithPrimaryColor: true,
                textColor: Constants.primaryColor,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: BorderContainer(
                text: 'Invoive',
                containerColor: Colors.white,
                // width: 140,
                borderWithPrimaryColor: true,
                textColor: Constants.primaryColor,
              ),
            ),
            SizedBox(width: 5),
            Expanded(flex: 6, child: _searchCustomerWidget()),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: BorderContainer(
                text: 'dd--yyyy',
                suffixSvg: 'assets/svg/calendar_month.svg',
                svgColor: Constants.primaryColor,
                // width: 140,
                onTap: () {
                  _showDateTimePicker();
                },
              ),
            ),
          ],
        ),
      ),
    );

    return isTabletMode == true
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            child: child,
          )
        : child;
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
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _dateTimeNotifier.value = DateTime.now();
                            },
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: Constants.primaryColor,
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
      color: Constants.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return ValueListenableBuilder<DateTime>(
        valueListenable: _dateTimeNotifier,
        builder: (_, dateTime, __) {
          return TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime(DateTime.now().year + 100, 1),
            focusedDay: dateTime,
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
              weekendTextStyle:
                  textStyle.copyWith(color: Constants.accentColor),
              outsideDaysVisible: false,
              todayTextStyle: textStyle.copyWith(
                color: Constants.primaryColor,
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
              _dateTimeNotifier.value = date;
              Navigator.pop(context);
            },
            selectedDayPredicate: (day) => isSameDay(day, dateTime),
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
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              selectedDate: _dateTimeNotifier.value,
              onChanged: (DateTime dateTime) {
                _dateTimeNotifier.value = DateTime(dateTime.year);
                Navigator.pop(bContext);
                _showDateTimePicker();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _searchCustomerWidget() {
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

  Widget _orderHistoryListWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        context.read<OrderHistoryListController>().orderHistoryInfoDataSource ==
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
                          .read<OrderHistoryListController>()
                          .orderHistoryList
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
                      text: 'Name',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      fixedWidth: isTabletMode == true ? 300 : 300,
                      text: 'Order Ref:',
                      // onSort: (columnIndex, ascending) =>
                      //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 180,
                      text: 'Customer',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: isTabletMode ? 180 : null,
                      text: 'Date',
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
                      text: 'Return Status',
                    ),
                    CommonUtils.dataColumn(
                      // fixedWidth: 188,
                      text: '',
                    ),
                    // CommonUtils.dataColumn(
                    //   fixedWidth: 100,
                    //   text: 'action'.tr(),
                    // ),
                  ],
                  source: context
                      .read<OrderHistoryListController>()
                      .orderHistoryInfoDataSource!,
                ),
              ),
        // _paginationWidget(),
      ],
    );
  }
}

class DataSourceForOrderHistoryListScreen extends DataTableSource {
  BuildContext context;
  late List<OrderHistoryDataModel> orderHistoryList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForOrderHistoryListScreen(
    this.context,
    this.orderHistoryList,
    this.offset,
    this.reloadDataCallback,
  );

  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(Comparable<T> Function(OrderHistoryDataModel d) getField,
      bool ascending) {
    orderHistoryList.sort((a, b) {
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
  int get rowCount => orderHistoryList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    OrderHistoryDataModel orderHistory = orderHistoryList[index];
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
          Text(orderHistory.name ?? ''),
        ),
        DataCell(
          Text(
            orderHistory.orderRef ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          Text(orderHistory.customer ?? ''),
        ),
        DataCell(
          Text(orderHistory.date ?? ''),
        ),
        DataCell(
          Text('${orderHistory.total?.toStringAsFixed(2) ?? '0.00'} Ks'),
        ),
        DataCell(
          Text(orderHistory.state ?? ''),
        ),
        DataCell(
          Text(
            orderHistory.returnState ?? '-',
            textAlign: TextAlign.center,
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonUtils.svgIconActionButton('assets/svg/keyboard_return.svg'),
              SizedBox(width: 8),
              CommonUtils.svgIconActionButton(
                  'assets/svg/currency_exchange.svg'),
              SizedBox(width: 8),
              CommonUtils.svgIconActionButton('assets/svg/delete.svg'),
              SizedBox(width: 8),
              CommonUtils.svgIconActionButton('assets/svg/print.svg'),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderHistoryDataModel {
  String? name;
  String? orderRef;
  String? customer;
  String? date;
  double? total;
  String? state;
  String? returnState;

  OrderHistoryDataModel(
      {this.name,
      this.orderRef,
      this.customer,
      this.date,
      this.total,
      this.state,
      this.returnState});

  OrderHistoryDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    orderRef = json['order_ref'];
    customer = json['customer'];
    date = json['date'];
    total = json['total'];
    state = json['state'];
    returnState = json['return_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['order_ref'] = orderRef;
    data['customer'] = customer;
    data['date'] = date;
    data['total'] = total;
    data['state'] = state;
    data['return_state'] = returnState;
    return data;
  }
}
