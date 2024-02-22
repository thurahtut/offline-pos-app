import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class CustomerPaginationTable extends StatefulWidget {
  const CustomerPaginationTable(
      {super.key, required this.mainContext, required this.bContext});
  final BuildContext mainContext;
  final BuildContext bContext;

  @override
  State<CustomerPaginationTable> createState() =>
      _CustomerPaginationTableState();
}

class _CustomerPaginationTableState extends State<CustomerPaginationTable> {
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;
  TextEditingController passwordTextController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    passwordTextController.dispose();
    scrollController.dispose();
    context.read<CurrentOrderController>().selectingCustomer = null;
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(widget.mainContext);
      widget.mainContext
          .read<CustomerListController>()
          .resetCustomerListController();
      getAllCustomer();
    });
    super.initState();
  }

  void getAllCustomer() async {
    context.read<CustomerListController>().loading = true;
    widget.mainContext
        .read<CustomerListController>()
        .getAllCustomer()
        .then((value) {
      updateCustomerListToTable();
      context.read<CustomerListController>().loading = false;
    });
  }

  Future<void> updateCustomerListToTable() async {
    widget.mainContext.read<CustomerListController>().customerInfoDataSource =
        CustomerInfoDataSourceForCustomerListScreen(
            widget.mainContext,
            widget.mainContext.read<CustomerListController>().customerList,
            passwordTextController,
            () {}, (customer, isSelectedCus) {
      if (!isSelectedCus &&
          widget.mainContext
              .read<CurrentOrderController>()
              .currentOrderList
              .isEmpty) {
        CommonUtils.showSnackBar(
            context: widget.mainContext, message: 'There is no order items.');
        return;
      }
      CustomerPasswordDialog.enterCustomerPasswordWidget(widget.mainContext,
              customer, isSelectedCus, passwordTextController)
          .then((value) {
        if (!isSelectedCus) {
          passwordTextController.clear();
          if (value is Customer) {
            widget.mainContext
                .read<CurrentOrderController>()
                .selectingCustomer = value;
            widget.mainContext.read<CurrentOrderController>().selectedCustomer =
                value;
          }
          Navigator.pop(widget.bContext, value);
        }
      });
    }, (customer) {
      context.read<CurrentOrderController>().selectingCustomer = customer;
      context.read<CurrentOrderController>().selectedCustomer = null;
      updateCustomerListToTable();
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool isTabletMode = CommonUtils.isTabletMode(widget.mainContext);
    return _bodyWidget(widget.mainContext);
  }

  Widget _bodyWidget(BuildContext mainContext) {
    bool isTabletMode = CommonUtils.isTabletMode(mainContext);
    bool isMobileMode = CommonUtils.isMobileMode(mainContext);
    double width = MediaQuery.of(mainContext).size.width;
    double height = MediaQuery.of(mainContext).size.height;
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: height - 100, maxWidth: width - 100),
        child: Column(
          mainAxisSize: mainContext.watch<CustomerListController>().loading
              ? MainAxisSize.min
              : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width - 100,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        BorderContainer(
                          text: 'Load Customers',
                          prefixSvg: 'assets/svg/account_circle.svg',
                          svgSize: 30,
                          svgColor: Colors.white,
                          width: (width - 100) /
                              (isMobileMode
                                  ? 3
                                  : isTabletMode
                                      ? 4
                                      : 6),
                          containerColor: primaryColor,
                          textColor: Colors.white,
                          textSize: (isMobileMode
                              ? 13
                              : isTabletMode
                                  ? 14
                                  : 16),
                          radius: 16,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _searchCustomerWidget(mainContext)),
                        Expanded(
                          child: Consumer<CurrentOrderController>(
                              builder: (_, controller, __) {
                            return CommonUtils.okCancelWidget(
                              okLabel: controller.selectedCustomer != null
                                  ? 'Discard Customer'
                                  : controller.selectingCustomer != null
                                      ? 'Set Customer'
                                      : 'Create',
                              switchBtns: true,
                              cancelContainerColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              textSize: 16,
                              okCallback: () {
                                if (controller.selectedCustomer != null) {
                                  controller.selectedCustomer = null;
                                  controller.selectingCustomer = null;
                                  Navigator.pop(widget.bContext, true);
                                } else if (controller.selectingCustomer !=
                                    null) {
                                  CustomerPasswordDialog
                                          .enterCustomerPasswordWidget(
                                              widget.mainContext,
                                              controller.selectingCustomer!,
                                              true,
                                              passwordTextController)
                                      .then((value) {
                                    if (value is Customer) {
                                      controller.selectedCustomer = value;
                                      Navigator.pop(widget.bContext, true);
                                    } else {
                                      passwordTextController.clear();
                                      controller.selectingCustomer = null;
                                      controller.selectedCustomer = null;
                                      updateCustomerListToTable();
                                    }
                                  });
                                } else {
                                  Navigator.pop(widget.bContext, true);
                                  CreateCustomerDialog
                                      .createCustomerDialogWidget(mainContext);
                                }
                              },
                              cancelLabel: 'Discard',
                              cancelCallback: () {
                                Navigator.pop(widget.bContext, false);
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(8),
                height: height - 200,
                width: width - 100,
                child: Consumer<CustomerListController>(
                    builder: (_, controller, __) {
                  return controller.loading
                      ? Container(
                          constraints: BoxConstraints(
                              maxHeight: 60,
                              maxWidth: 60,
                              minHeight: 60,
                              minWidth: 60),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : controller.customerInfoDataSource == null
                          ? SizedBox()
                          : Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(widget.mainContext)
                                              .size
                                              .width,
                                      maxHeight:
                                          MediaQuery.of(widget.mainContext)
                                              .size
                                              .height,
                                    ),
                                    child: _customerInfoWidget(controller),
                                  ),
                                ),
                              ),
                            );
                })),
          ],
        ),
      ),
    );
  }

  Stack _customerInfoWidget(CustomerListController controller) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: Theme(
            data: Theme.of(widget.mainContext).copyWith(
              cardTheme: CardTheme(
                elevation: 0,
                color: Colors.white,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            child: PaginatedDataTable2(
              dataRowHeight: 65,
              headingRowHeight: 70,
              dividerThickness: 0.0,
              border: TableBorder(
                  horizontalInside: BorderSide(
                      color: Constants.disableColor.withOpacity(0.81))),
              rowsPerPage:
                  min(controller.limit, max(controller.customerList.length, 1)),
              minWidth: MediaQuery.of(widget.mainContext).size.width - 100,
              showCheckboxColumn: false,
              fit: FlexFit.tight,
              hidePaginator: true,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending ?? false,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => primaryColor),
              columns: [
                CommonUtils.dataColumn(
                  // fixedWidth: isTabletMode ? 150 : 120,
                  text: 'Name',
                  // onSort: (columnIndex, ascending) =>
                  //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
                ),
                CommonUtils.dataColumn(
                  fixedWidth: isTabletMode == true ? 300 : 300,
                  text: 'Address',
                  // onSort: (columnIndex, ascending) =>
                  //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
                ),
                CommonUtils.dataColumn(
                  // fixedWidth: 180,
                  text: 'Phone',
                ),
                CommonUtils.dataColumn(
                  // fixedWidth: isTabletMode ? 180 : null,
                  text: 'Email',
                ),
                CommonUtils.dataColumn(
                  // fixedWidth: 188,
                  text: 'Discount',
                ),
                CommonUtils.dataColumn(
                  fixedWidth: 250,
                  text: 'Credit',
                ),
                CommonUtils.dataColumn(
                  // fixedWidth: 188,
                  text: 'Credit Limit',
                ),
                CommonUtils.dataColumn(
                  // fixedWidth: 188,
                  text: 'Amount Due',
                ),
                // CommonUtils.dataColumn(
                //   fixedWidth: 100,
                //   text: 'action'.tr(),
                // ),
              ],
              source: controller.customerInfoDataSource!,
            ),
          ),
        ),
        _paginationWidget(controller),
      ],
    );
  }

  Widget _paginationWidget(CustomerListController controller) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: [
        FlutterCustomPagination(
          currentPage: controller.currentIndex,
          limitPerPage: controller.limit,
          totalDataCount: controller.total,
          onPreviousPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllCustomer();
          },
          onBackToFirstPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllCustomer();
          },
          onNextPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllCustomer();
          },
          onGoToLastPage: (pageNo) {
            controller.offset = (controller.limit * pageNo) - controller.limit;
            controller.currentIndex = pageNo;
            getAllCustomer();
          },
          backgroundColor: Theme.of(context).colorScheme.background,
          previousPageIcon: Icons.keyboard_arrow_left,
          backToFirstPageIcon: Icons.first_page,
          nextPageIcon: Icons.keyboard_arrow_right,
          goToLastPageIcon: Icons.last_page,
          textStyle: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget _searchCustomerWidget(BuildContext mainContext) {
    TextEditingController searchCustomerTextController =
        TextEditingController();
    return Center(
      child: TextField(
        controller: searchCustomerTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        onChanged: (value) {
          mainContext.read<CustomerListController>().filterValue = value;
          mainContext.read<CustomerListController>().offset = 0;
          mainContext.read<CustomerListController>().currentIndex = 1;
          getAllCustomer();
        },
      ),
    );
  }
}

class CustomerInfoDataSourceForCustomerListScreen extends DataTableSource {
  BuildContext context;
  late List<Customer> customerInfoList;
  TextEditingController passwordTextController;
  Function() reloadDataCallback;
  Function(Customer, bool) cartCallback;
  Function(Customer) selectingCustomerCallback;

  CustomerInfoDataSourceForCustomerListScreen(
    this.context,
    this.customerInfoList,
    this.passwordTextController,
    this.reloadDataCallback,
    this.cartCallback,
    this.selectingCustomerCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(Comparable<T> Function(Customer d) getField, bool ascending) {
    customerInfoList.sort((a, b) {
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
  int get rowCount => customerInfoList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    Customer customerInfo = customerInfoList[index];
    Customer? selectedCustomer =
        context.read<CurrentOrderController>().selectedCustomer ??
            context.read<CurrentOrderController>().selectingCustomer;

    return DataRow(
      color: selectedCustomer != null && selectedCustomer.id == customerInfo.id
          ? MaterialStateColor.resolveWith(
              (states) => primaryColor.withOpacity(0.6))
          : null,
      onSelectChanged: (value) {
        selectingCustomerCallback(customerInfo);
      },
      cells: [
        DataCell(
          Text(customerInfo.name ?? ''),
        ),
        DataCell(
          Text(
            '${customerInfo.blockingStage ?? ''}/${customerInfo.street ?? ''}/${customerInfo.city ?? ''}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          Text(customerInfo.phone ?? ''),
        ),
        DataCell(
          Text(customerInfo.email ?? ''),
        ),
        DataCell(
          Text('0'),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '0 Ks'), //${customerInfo.credit?.toStringAsFixed(2) ?? '0.00'}
              SizedBox(width: 4),
              CommonUtils.svgIconActionButton('assets/svg/shopping_cart.svg',
                  onPressed: () {
                cartCallback(customerInfo, false);
              }),
              SizedBox(width: 4),
              CommonUtils.svgIconActionButton('assets/svg/share_windows.svg'),
            ],
          ),
        ),
        DataCell(
          Text(''), //customerInfo.creditLimit ??
        ),
        DataCell(
          Text(''), //customerInfo.dueAmount ??
        ),
      ],
    );
  }
}
