import 'package:offline_pos/view/item/item_list_screen.dart';

import '/components/export_files.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<bool> _showSideBar = ValueNotifier(true);
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
      appBar: SaleAppBar(),
      body: Visibility(
          visible: !context.watch<ViewController>().isCustomerView,
          child: _bodyWidget()),
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
              if (!isTabletMode) ItemListScreen(showSideBar: _showSideBar),
              if (!isTabletMode) CurrentOrderScreen(),
              if (isTabletMode)
                Column(
                  children: [
                    Expanded(child: ItemListScreen(showSideBar: _showSideBar)),
                    Expanded(child: CurrentOrderScreen()),
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
                containerColor: !context.watch<ViewController>().isList
                    ? Constants.primaryColor
                    : Constants.unselectedColor,
                iconColor: !context.watch<ViewController>().isList
                    ? Colors.white
                    : Constants.primaryColor,
                onPressed: () {
                  context.read<ViewController>().isList = false;
                },
              ),
              spacer,
              CommonUtils.iconActionButton(
                Icons.view_list_outlined,
                withContianer: true,
                containerColor: context.watch<ViewController>().isList
                    ? Constants.primaryColor
                    : Constants.unselectedColor,
                iconColor: context.watch<ViewController>().isList
                    ? Colors.white
                    : Constants.primaryColor,
                onPressed: () {
                  context.read<ViewController>().isList = true;
                },
              ),
              spacer,
              CommonUtils.svgIconActionButton(
                'assets/svg/home.svg',
                withContianer: true,
                containerColor: context.watch<ViewController>().isHome
                    ? Constants.primaryColor
                    : Constants.unselectedColor,
                iconColor: context.watch<ViewController>().isHome
                    ? Colors.white
                    : Constants.primaryColor,
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
}
