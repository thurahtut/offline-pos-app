import 'dart:math';

import '../../components/export_files.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});
  static const String routeName = "/payment_method_screen";

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final TextEditingController _searchProductTextController =
      TextEditingController();

  final TextEditingController _paymentMethodNameTextController =
      TextEditingController();

  final TextEditingController _intermediaryAccountTextController =
      TextEditingController();

  final TextEditingController _shortCodeTextController =
      TextEditingController();
  int _limit = 20;
  int _offset = 0;
  bool? _sortAscending = true;
  int? _sortColumnIndex;
  bool? isTabletMode;

  @override
  void dispose() {
    _searchProductTextController.dispose();
    _paymentMethodNameTextController.dispose();
    _intermediaryAccountTextController.dispose();
    _shortCodeTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      for (var i = 0; i < 20; i++) {
        context
            .read<PaymentMethodListController>()
            .paymentMethodList
            .add(CommonUtils.demoPaymentMethod);
      }
      context.read<PaymentMethodListController>().paymentMethodInfoDataSource =
          DataSourceForPaymentMethodListScreen(
              context,
              context.read<PaymentMethodListController>().paymentMethodList,
              _offset,
              () {});
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor.withOpacity(0.74),
      appBar: InventoryAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        if (context.watch<PaymentMethodListController>().isDetail ||
            context.watch<PaymentMethodListController>().isNew)
          SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            context.watch<PaymentMethodListController>().isDetail ||
                    context.watch<PaymentMethodListController>().isNew
                ? Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 60,
                        vertical: 10))
                : SizedBox(width: 16),
            Text(
              context.watch<PaymentMethodListController>().isDetail
                  ? 'Payment Methods / ${context.read<PaymentMethodListController>().editingPaymentMethod?.method}'
                  : context.watch<PaymentMethodListController>().isNew
                      ? 'Payment Methods / New'
                      : 'Payment Methods',
              style: TextStyle(
                color: Constants.textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(flex: isTabletMode == true ? 1 : 2, child: SizedBox()),
            if (!context.watch<PaymentMethodListController>().isDetail &&
                !context.watch<PaymentMethodListController>().isNew)
              Expanded(child: _searchProductWidget()),
            if (!context.watch<PaymentMethodListController>().isDetail &&
                !context.watch<PaymentMethodListController>().isNew)
              SizedBox(width: 16),
          ],
        ),
        if (context.watch<PaymentMethodListController>().isDetail ||
            context.watch<PaymentMethodListController>().isNew)
          SizedBox(height: 20),
        _filtersWidget(),
        Expanded(
            child: context.watch<PaymentMethodListController>().isDetail
                ? _paymentDetailWidget()
                : context.watch<PaymentMethodListController>().isNew
                    ? _createNewPaymentMethodWidget()
                    : _tableWidget()),
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
    return context.watch<PaymentMethodListController>().isNew
        ? //
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 60,
                      vertical: 10)),
              Expanded(
                child: CommonUtils.okCancelWidget(
                  outsidePadding: EdgeInsets.zero,
                  width: 200,
                  textSize: 16,
                  okLabel: 'Save',
                  cancelLabel: 'Discard',
                  cancelCallback: () {
                    context.read<PaymentMethodListController>().isNew = false;
                  },
                ),
              ),
              Expanded(flex: isTabletMode == true ? 2 : 3, child: SizedBox()),
            ],
          )
        : Row(
            children: [
              context.watch<PaymentMethodListController>().isDetail ||
                      context.watch<PaymentMethodListController>().isNew
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 60,
                          vertical: 10))
                  : SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    BorderContainer(
                      text: 'Create',
                      containerColor: Constants.primaryColor,
                      textColor: Colors.white,
                      width: 150,
                      onTap: () {
                        context.read<PaymentMethodListController>().isDetail =
                            false;
                        context.read<PaymentMethodListController>().isNew =
                            true;
                      },
                    ),
                    SizedBox(width: 4),
                    CommonUtils.svgIconActionButton(
                        'assets/svg/export_notes.svg'),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              context.watch<PaymentMethodListController>().isDetail
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CommonUtils.appBarActionButtonWithText(
                            'assets/svg/ad_group.svg', 'Action',
                            width: 35, height: 35),
                        SizedBox(width: 16),
                      ],
                    )
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (isTabletMode != true) Expanded(child: SizedBox()),
                          Expanded(
                            child: Row(
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
                                CommonUtils.svgIconActionButton(
                                    'assets/svg/view_list.svg'),
                                SizedBox(width: 4),
                                CommonUtils.svgIconActionButton(
                                    'assets/svg/grid_view.svg'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              context.watch<PaymentMethodListController>().isDetail ||
                      context.watch<PaymentMethodListController>().isNew
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 60,
                          vertical: 10))
                  : SizedBox(width: 16),
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
        child: context
                    .watch<PaymentMethodListController>()
                    .paymentMethodInfoDataSource !=
                null
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
      rowsPerPage: min(_limit,
          context.read<PaymentMethodListController>().paymentMethodList.length),
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
          text: 'Method',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d["name"] ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          fixedWidth: isTabletMode == true ? 300 : 300,
          text: 'Journal',
          // onSort: (columnIndex, ascending) =>
          //     sort<String>((d) => (d.name ?? ''), columnIndex, ascending),
        ),
        CommonUtils.dataColumn(
          // fixedWidth: 180,
          text: 'Company',
        ),
        DataColumn2(
          fixedWidth: 20,
          label: PopupMenuButton(
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
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        title: Text('Identify Customer'),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (bool? value) {},
                        controlAffinity: ListTileControlAffinity.leading,
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        title: Text('Oustanding Account'),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (bool? value) {},
                        controlAffinity: ListTileControlAffinity.leading,
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        title: Text('Intermediary Account'),
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
                              // width: width,
                              // height: height,
                              // iconColor: iconColor,
                              // onPressed: onPressed,
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
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),

          // onSort: onSort,
        )
      ],
      source: context
          .read<PaymentMethodListController>()
          .paymentMethodInfoDataSource!,
    );
  }

  Widget _paymentDetailWidget() {
    return Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 2,
          minWidth: (MediaQuery.of(context).size.width / 2) -
              MediaQuery.of(context).size.width / 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30, vertical: 10),
      padding: EdgeInsets.all(20),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              // width:( MediaQuery.of(context).size.width/2) -MediaQuery.of(context).size.width / 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Method',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'American Express Settlement (Easy 1)',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ..._infoWidget(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tips :',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Go to Configurations > Settings > Payment Terminals in order to install a Payment Terminal and make a fully integrated payment method.',
                    style: TextStyle(
                      color: Constants.textColor.withOpacity(0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _createNewPaymentMethodWidget() {
    var spacer = SizedBox(height: 10);
    return Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 2,
          minWidth: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width / 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30, vertical: 10),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isTabletMode == true ? 1 : 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Method',
                  style: TextStyle(
                    color: Constants.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: _paymentMethodNameTextController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "Eg. Cash",
                      hintStyle: TextStyle(
                        color: Constants.disableColor.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      labelStyle: TextStyle(
                        color: Constants.primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfo("Identify Customer")),
                    Expanded(
                      flex: 2,
                      child: CheckboxListTile(
                        value: false,
                        onChanged: (bool? value) {},
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _textForDetailInfo("Journal")),
                    Expanded(
                      flex: 2,
                      child: _dropDownWidget(
                        context,
                        list,
                      ),
                    ),
                  ],
                ),
                spacer,
                Row(
                  children: [
                    Expanded(child: _textForDetailInfo("For Points")),
                    Expanded(
                      flex: 2,
                      child: CheckboxListTile(
                        value: false,
                        onChanged: (bool? value) {},
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _textForDetailInfo("Intermediary Account")),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _intermediaryAccountTextController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _textForDetailInfo("Company")),
                    Expanded(
                      flex: 2,
                      child: _textForDetailInfo(context
                              .read<PaymentMethodListController>()
                              .editingPaymentMethod
                              ?.company ??
                          "SSS International Co,Ltd.',"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: _textForDetailInfo("Allow Payments Via Wallet")),
                    Expanded(
                      flex: 2,
                      child: CheckboxListTile(
                        value: false,
                        onChanged: (bool? value) {},
                        side: MaterialStateBorderSide.resolveWith((_) =>
                            const BorderSide(
                                width: 2, color: Constants.primaryColor)),
                        checkColor: Constants.primaryColor,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _textForDetailInfo("Short Code")),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _shortCodeTextController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(flex: isTabletMode == true ? 2 : 3, child: SizedBox()),
        ],
      ),
    );
  }

  List<Widget> _infoWidget() {
    var spacer = SizedBox(height: 15);

    return [
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Identify Customer")),
          Expanded(
            flex: 2,
            child: CheckboxListTile(
              value: context
                      .read<PaymentMethodListController>()
                      .editingPaymentMethod
                      ?.identifyCustomer ==
                  true,
              onChanged: (bool? value) {},
              side: MaterialStateBorderSide.resolveWith((_) =>
                  const BorderSide(width: 2, color: Constants.primaryColor)),
              checkColor: Constants.primaryColor,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Journal")),
          Expanded(
            flex: 2,
            child: _textForDetailInfo(context
                    .read<PaymentMethodListController>()
                    .editingPaymentMethod
                    ?.journal ??
                ''),
          )
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("For Points")),
          Expanded(
            flex: 2,
            child: CheckboxListTile(
              value: context
                      .read<PaymentMethodListController>()
                      .editingPaymentMethod
                      ?.forPoint ==
                  true,
              onChanged: (bool? value) {},
              side: MaterialStateBorderSide.resolveWith((_) =>
                  const BorderSide(width: 2, color: Constants.primaryColor)),
              checkColor: Constants.primaryColor,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Outstanding Account")),
          Expanded(
            flex: 2,
            child: _textForDetailInfo(context
                    .read<PaymentMethodListController>()
                    .editingPaymentMethod
                    ?.outstandingAccount ??
                ''),
          )
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Intermediary Account")),
          Expanded(
            flex: 2,
            child: _textForDetailInfo(context
                    .read<PaymentMethodListController>()
                    .editingPaymentMethod
                    ?.intermediaryAccount ??
                ''),
          ),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Company")),
          Expanded(
              flex: 2,
              child: _textForDetailInfo(context
                      .read<PaymentMethodListController>()
                      .editingPaymentMethod
                      ?.company ??
                  '')),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Allow Payments Via Wallet")),
          Expanded(
              flex: 2,
              child: CheckboxListTile(
                value: context
                        .read<PaymentMethodListController>()
                        .editingPaymentMethod
                        ?.allowPaymentViaWallet ==
                    true,
                onChanged: (bool? value) {},
                side: MaterialStateBorderSide.resolveWith((_) =>
                    const BorderSide(width: 2, color: Constants.primaryColor)),
                checkColor: Constants.primaryColor,
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              )),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Short Code")),
          Expanded(
              flex: 2,
              child: _textForDetailInfo(context
                      .read<PaymentMethodListController>()
                      .editingPaymentMethod
                      ?.shortCode ??
                  '')),
        ],
      ),
      spacer,
    ];
  }

  Widget _textForDetailInfo(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Constants.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  List<String> list = ["Yangon", "Lashio", "Mandalay", "Nay Pyi Taw"];

  _dropDownWidget(
    BuildContext mainContext,
    List<String> list,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      // width: MediaQuery.of(mainContext).size.width / 4.8,
      // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          // color: Constants.greyColor.withOpacity(0.6),
          // borderRadius: BorderRadius.circular(20),
          border: Border(
              bottom: BorderSide(color: Constants.textColor.withOpacity(0.7)))
          // border: Border.only(color: Constants.primaryColor, width: 1.7),
          ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
              value: list.first,
              icon: SizedBox(),
              underline: Container(),
              items: list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class DataSourceForPaymentMethodListScreen extends DataTableSource {
  BuildContext context;
  late List<PaymentMethods> paymentMethodInfoList;
  int offset;
  Function() reloadDataCallback;

  DataSourceForPaymentMethodListScreen(
    this.context,
    this.paymentMethodInfoList,
    this.offset,
    this.reloadDataCallback,
  );
  @override
  DataRow? getRow(int index) {
    return _createRow(index);
  }

  void sort<T>(
      Comparable<T> Function(PaymentMethods d) getField, bool ascending) {
    paymentMethodInfoList.sort((a, b) {
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
  int get rowCount => paymentMethodInfoList.length;

  @override
  int get selectedRowCount => 0;

  DataRow _createRow(int index) {
    PaymentMethods paymentMethod = paymentMethodInfoList[index];
    return DataRow(
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text('${index + 1}'),
        ),
        DataCell(
          onTap: () {
            context.read<PaymentMethodListController>().isDetail = true;
            context.read<PaymentMethodListController>().editingPaymentMethod =
                paymentMethod;
          },
          Text(paymentMethod.method ?? ''),
        ),
        DataCell(
          onTap: () {
            context.read<PaymentMethodListController>().isDetail = true;
            context.read<PaymentMethodListController>().editingPaymentMethod =
                paymentMethod;
          },
          Text(
            paymentMethod.journal ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        DataCell(
          onTap: () {
            context.read<PaymentMethodListController>().isDetail = true;
            context.read<PaymentMethodListController>().editingPaymentMethod =
                paymentMethod;
          },
          Text(paymentMethod.company ?? ''),
        ),
        DataCell(
          onTap: () {
            context.read<PaymentMethodListController>().isDetail = true;
            context.read<PaymentMethodListController>().editingPaymentMethod =
                paymentMethod;
          },
          Text(''),
        ),
      ],
    );
  }
}

class PaymentMethods {
  String? method;
  String? journal;
  String? company;
  bool? identifyCustomer;
  bool? forPoint;
  String? outstandingAccount;
  String? intermediaryAccount;
  bool? allowPaymentViaWallet;
  String? shortCode;

  PaymentMethods(
      {this.method,
      this.journal,
      this.company,
      this.identifyCustomer,
      this.forPoint,
      this.outstandingAccount,
      this.intermediaryAccount,
      this.allowPaymentViaWallet,
      this.shortCode});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    journal = json['journal'];
    company = json['company'];
    identifyCustomer = json['identify_customer'];
    forPoint = json['for_point'];
    outstandingAccount = json['outstanding_account'];
    intermediaryAccount = json['intermediary_account'];
    allowPaymentViaWallet = json['allow_payment_via_wallet'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['journal'] = journal;
    data['company'] = company;
    data['identify_customer'] = identifyCustomer;
    data['for_point'] = forPoint;
    data['outstanding_account'] = outstandingAccount;
    data['intermediary_account'] = intermediaryAccount;
    data['allow_payment_via_wallet'] = allowPaymentViaWallet;
    data['short_code'] = shortCode;
    return data;
  }
}
