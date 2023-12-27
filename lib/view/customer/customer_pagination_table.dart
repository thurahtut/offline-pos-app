import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class CustomerPaginationTable extends StatefulWidget {
  const CustomerPaginationTable({super.key});

  @override
  State<CustomerPaginationTable> createState() =>
      _CustomerPaginationTableState();
}

class _CustomerPaginationTableState extends State<CustomerPaginationTable> {
  int _limit = 20;
  int _offset = 0;
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;
  TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      context.read<CustomerListController>().customerList =
          CommonUtils.customerList;
      context.read<CustomerListController>().customerInfoDataSource =
          CustomerInfoDataSourceForCustomerListScreen(
        context,
        context.read<CustomerListController>().customerList,
        _offset,
        passwordTextController,
        () {},
        () {
          context.read<CurrentOrderController>().isContainCustomer = true;
          PasswordDialog.enterPasswordWidget(context, passwordTextController)
              .then((value) {
            if (value == true) {
              Navigator.pushNamed(
                context,
                OrderPaymentScreen.routeName,
              );
              passwordTextController.clear();
            }
          });
        },
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isTabletMode = CommonUtils.isTabletMode(context);
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
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: context
                        .watch<CustomerListController>()
                        .customerInfoDataSource !=
                    null
                ? _customerInfoWidget()
                : SizedBox(),
          ),
        ),
      ),
    );
  }

  Stack _customerInfoWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        context.read<CustomerListController>().customerInfoDataSource == null
            ? SizedBox()
            : Theme(
                data: Theme.of(context).copyWith(
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
                  rowsPerPage: min(
                      _limit,
                      context
                          .read<CustomerListController>()
                          .customerList
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
                  source: context
                      .read<CustomerListController>()
                      .customerInfoDataSource!,
                ),
              ),
        // _paginationWidget(),
      ],
    );
  }
}

class CustomerInfoDataSourceForCustomerListScreen extends DataTableSource {
  BuildContext context;
  late List<CustomerDataModel> customerInfoList;
  int offset;
  TextEditingController passwordTextController;
  Function() reloadDataCallback;
  Function() cartCallback;

  CustomerInfoDataSourceForCustomerListScreen(
    this.context,
    this.customerInfoList,
    this.offset,
    this.passwordTextController,
    this.reloadDataCallback,
    this.cartCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(
      Comparable<T> Function(CustomerDataModel d) getField, bool ascending) {
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
    CustomerDataModel customerInfo = customerInfoList[index];
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
          Text(customerInfo.name ?? ''),
        ),
        DataCell(
          Text(
            customerInfo.address ?? '',
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
          Text(customerInfo.discount.toString()),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${customerInfo.credit?.toStringAsFixed(2) ?? '0.00'} Ks'),
              SizedBox(width: 4),
              CommonUtils.svgIconActionButton('assets/svg/shopping_cart.svg',
                  onPressed: cartCallback),
              SizedBox(width: 4),
              CommonUtils.svgIconActionButton('assets/svg/share_windows.svg'),
            ],
          ),
        ),
        DataCell(
          Text(customerInfo.creditLimit ?? ''),
        ),
        DataCell(
          Text(customerInfo.amountDue ?? ''),
        ),
      ],
    );
  }
}

class CustomerDataModel {
  String? name;
  String? address;
  String? phone;
  String? email;
  int? discount;
  int? credit;
  String? creditLimit;
  String? amountDue;

  CustomerDataModel(
      {this.name,
      this.address,
      this.phone,
      this.email,
      this.discount,
      this.credit,
      this.creditLimit,
      this.amountDue});

  CustomerDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    discount = json['discount'];
    credit = json['credit'];
    creditLimit = json['credit_limit'];
    amountDue = json['amount_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['discount'] = discount;
    data['credit'] = credit;
    data['credit_limit'] = creditLimit;
    data['amount_due'] = amountDue;
    return data;
  }
}
