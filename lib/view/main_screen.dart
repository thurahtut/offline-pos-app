import 'dart:math';

import '/components/export_files.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ValueNotifier<bool> _showSideBar = ValueNotifier(true);
  List<String> categoryList = [
    "Dry Grocery",
    "Food To Go",
    "Men Wears",
    "Women Wears",
    "B.W.S , Wine, Accessories and Tabacco",
    "Basic Grocery",
    "Beverage",
    "Bakery",
    "Butchery",
    "Cosmetic",
    "Kitchen Accessories",
    "Drink",
    "Alcohol",
    "Juice",
    "Water",
    "Tissue",
    "Electronic"
  ];

  @override
  void dispose() {
    _showSideBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.greyColor,
      appBar: MyAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 8),
        _headerWidget(),
        SizedBox(height: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<bool>(
                  valueListenable: _showSideBar,
                  builder: (_, showSidebar, __) {
                    return Visibility(
                        visible: showSidebar, child: _sideBarWidget());
                  }),
              if (!isTabletMode) _itemListWidget(),
              if (!isTabletMode) _currentOrderWidget(),
              if (isTabletMode)
                Column(
                  children: [
                    Expanded(child: _itemListWidget()),
                    Expanded(child: _currentOrderWidget()),
                  ],
                )
            ],
          ),
        )
      ],
    );
  }

  Widget _headerWidget() {
    Widget spacer = SizedBox(width: 14);
    return RawScrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      thumbColor: Constants.primaryColor,
      radius: Radius.circular(20),
      thickness: 6,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CommonUtils.svgIconActionButton(
                'assets/svg/grid_view.svg',
                withContianer: true,
                containerColor: Constants.unselectedColor,
                iconColor: Constants.primaryColor,
              ),
              spacer,
              CommonUtils.iconActionButton(
                Icons.view_list_outlined,
                withContianer: true,
                containerColor: Constants.unselectedColor,
                iconColor: Constants.primaryColor,
              ),
              spacer,
              CommonUtils.svgIconActionButton(
                'assets/svg/home.svg',
                withContianer: true,
                containerColor: Constants.unselectedColor,
                iconColor: Constants.primaryColor,
              ),
              spacer,
              ...categoryList
                  .map((e) => Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Constants.primaryColor,
                            ),
                            child: Text(
                              e,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          spacer,
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sideBarWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...CommonUtils.sideBarList
              .map((e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _eachSideBarWidget(
                        e['svgPicture'],
                        e['text'],
                        e['onTap'],
                      ),
                      SizedBox(height: 8),
                    ],
                  ))
              .toList()
        ],
      ),
    );
  }

  Widget _eachSideBarWidget(String svg, String text, Function() onTap) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: isTabletMode
            ? MediaQuery.of(context).size.width / 10
            : MediaQuery.of(context).size.width / 5.5,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Constants.greyColor2.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.only(left: 8),
        child: ListTile(
          leading: CommonUtils.svgIconActionButton(
            svg,
          ),
          title: isTabletMode
              ? null
              : Text(
                  text,
                  style: TextStyle(
                    color: Constants.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _itemListWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return ValueListenableBuilder<bool>(
        valueListenable: _showSideBar,
        builder: (_, showSidebar, __) {
          return Container(
            width: isTabletMode
                ? (MediaQuery.of(context).size.width / 10) * 9
                : ((MediaQuery.of(context).size.width / 5.3) * 3) +
                    (showSidebar ? 0 : MediaQuery.of(context).size.width / 5.5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                _itemListHeaderWidget(),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: CommonUtils.svgIconActionButton(
                          "assets/svg/${showSidebar ? "close_sidebar.svg" : "open_sidebar.svg"}",
                          height: 40,
                          onPressed: () {
                            _showSideBar.value = !_showSideBar.value;
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...CommonUtils.itemList
                                  .map((e) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _eachItemWidget(e),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14.0),
                                            child: Divider(
                                              thickness: 1.3,
                                              color: Constants.disableColor
                                                  .withOpacity(0.96),
                                            ),
                                          )
                                        ],
                                      ))
                                  .toList()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container _itemListHeaderWidget() {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Container(
      padding: EdgeInsets.all(8),
      height: 60,
      decoration: BoxDecoration(
        color: Constants.primaryColor,
      ),
      child: Row(
        children: [
          SizedBox(width: 30),
          Expanded(flex: 3, child: Text('Name', style: textStyle)),
          Expanded(child: Text('On Hand', style: textStyle)),
          Expanded(child: Text('UOM', style: textStyle)),
          Expanded(child: Text('Price', style: textStyle)),
        ],
      ),
    );
  }

  Widget _eachItemWidget(dynamic object) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 18),
      height: 52,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(text: "", children: [
                TextSpan(
                  text: "[${object["id"]}]",
                  style: textStyle.copyWith(color: Constants.successColor),
                ),
                TextSpan(text: object["name"], style: textStyle),
              ]),
            ),
          ),
          Expanded(child: Text(object["on_hand"].toString(), style: textStyle)),
          Expanded(child: Text(object["unit"], style: textStyle)),
          Expanded(child: Text(object["price"].toString(), style: textStyle)),
        ],
      ),
    );
  }

  Widget _currentOrderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _noOrderWidget()),
        _calculatorWidget(),
      ],
    );
  }

  Widget _noOrderWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return SizedBox(
      width: isTabletMode
          ? (MediaQuery.of(context).size.width / 10) * 9
          : MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width / 5.5) -
              ((MediaQuery.of(context).size.width / 5.3) * 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonUtils.svgIconActionButton("assets/svg/no_order.svg",
              height: 60,
              onPressed: null,
              iconColor: Constants.disableColor.withOpacity(
                0.77,
              )),
          Center(
            child: Text(
              'This Order is Empty',
              style: TextStyle(
                color: Constants.disableColor.withOpacity(
                  0.87,
                ),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calculatorWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    List<Widget> list = [];
    List<Widget> rowList = [];

    for (var i = 0;
        i < CommonUtils.calculatorActionWidgetList.length;
        i += (isTabletMode ? 10 : 5)) {
      int start = (list.length * (isTabletMode ? 10 : 5));
      int end =
          (isTabletMode ? 10 : 5) + (list.length * (isTabletMode ? 10 : 5));
      rowList.addAll(CommonUtils.calculatorActionWidgetList.getRange(
          start, min(end, CommonUtils.calculatorActionWidgetList.length)));

      // if (end > CommonUtils.calculatorActionWidgetList.length - 1) break;
      list.add(SizedBox(
        width: isTabletMode
            ? (MediaQuery.of(context).size.width / 10) * 9
            : MediaQuery.of(context).size.width -
                (MediaQuery.of(context).size.width / 5.5) -
                ((MediaQuery.of(context).size.width / 5.3) * 3),
        child: Row(
          children: rowList.map((e) {
            // var child = e.toString();
            return Expanded(
              //UnconstrainedBox
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: e,
              ),
            );
          }).toList(),
        ),
      ));
      rowList = [];
    }

    return Column(
      children: list,
    );
  }
}
