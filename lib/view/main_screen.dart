import 'package:flutter/foundation.dart';

import '/components/export_files.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.resetController});
  static const String routeName = "/main_screen";
  final bool? resetController;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final ValueNotifier<bool> _showSideBar = ValueNotifier(false);
  final scrollController = ScrollController();

  @override
  void dispose() {
    _showSideBar.dispose();
    context.read<ViewController>().searchProductFocusNode.unfocus();
    context.read<CurrentOrderController>().productTextFieldFocusNode.unfocus();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (kIsWeb || Platform.isWindows) {
        context
            .read<CurrentOrderController>()
            .productTextFieldFocusNode
            .requestFocus();
      }
      if (widget.resetController != false) {
        context.read<CurrentOrderController>().resetCurrentOrderController();
        context.read<ItemListController>().resetItemListController();
      }
      context.read<ViewController>().isCustomerView = false;
      if (kIsWeb || Platform.isWindows) {
        context.read<ViewController>().searchProductFocusNode.addListener(() {
          if ((kIsWeb || Platform.isWindows) &&
              !context.read<ViewController>().searchProductFocusNode.hasFocus) {
            context
                .read<CurrentOrderController>()
                .productTextFieldFocusNode
                .requestFocus();
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.greyColor,
      appBar: SaleAppBar(),
      body: Opacity(
          opacity: context.watch<ViewController>().isCustomerView ? 0 : 1,
          child: _bodyWidget()),
    );
  }

  Widget _bodyWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return GestureDetector(
      onTap: () {
        if (kIsWeb || Platform.isWindows) {
          context
              .read<CurrentOrderController>()
              .productTextFieldFocusNode
              .requestFocus();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
              onTap: () {
                if (kIsWeb || Platform.isWindows) {
                  context
                      .read<CurrentOrderController>()
                      .productTextFieldFocusNode
                      .requestFocus();
                }
              },
              child: SizedBox(height: 8)),
          if (context.watch<ViewController>().hideCategory == false)
            _categoryWidget(),
          GestureDetector(
              onTap: () {
                if (kIsWeb || Platform.isWindows) {
                  context
                      .read<CurrentOrderController>()
                      .productTextFieldFocusNode
                      .requestFocus();
                }
              },
              child: SizedBox(height: 16)),
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
                if (!isTabletMode)
                  ValueListenableBuilder<bool>(
                      valueListenable: _showSideBar,
                      builder: (_, showSidebar, __) {
                        double currentOrderWidth = isTabletMode
                            ? (MediaQuery.of(context).size.width / 10) * 9
                            : MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width /
                                    (showSidebar ? 5.5 : 9)) -
                                ((MediaQuery.of(context).size.width / 5.3) * 3);
                        return CurrentOrderScreen(width: currentOrderWidth);
                      }),
                if (isTabletMode)
                  Column(
                    children: [
                      Expanded(
                          child: ItemListScreen(showSideBar: _showSideBar)),
                      Expanded(
                          child: ValueListenableBuilder<bool>(
                              valueListenable: _showSideBar,
                              builder: (_, showSidebar, __) {
                                double currentOrderWidth = isTabletMode
                                    ? (MediaQuery.of(context).size.width / 10) *
                                        9
                                    : MediaQuery.of(context).size.width -
                                        (MediaQuery.of(context).size.width /
                                            (showSidebar ? 5.5 : 9)) -
                                        ((MediaQuery.of(context).size.width /
                                                5.3) *
                                            3);
                                return CurrentOrderScreen(
                                    width: currentOrderWidth);
                              })),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    Widget spacer = SizedBox(width: 14);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            if (kIsWeb || Platform.isWindows) {
              Future.delayed(Duration(milliseconds: 120), () {
                context
                    .read<CurrentOrderController>()
                    .productTextFieldFocusNode
                    .requestFocus();
              });
            }
          },
          child: RawScrollbar(
            controller: scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thumbColor: primaryColor,
            radius: Radius.circular(20),
            thickness: 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              color: Colors.transparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CommonUtils.svgIconActionButton(
                      'assets/svg/grid_view.svg',
                      withContianer: true,
                      containerColor: !context.watch<ViewController>().isList
                          ? primaryColor
                          : Constants.unselectedColor,
                      iconColor: !context.watch<ViewController>().isList
                          ? Colors.white
                          : primaryColor,
                      onPressed: () {
                        context.read<ViewController>().isList = false;
                      },
                    ),
                    spacer,
                    CommonUtils.iconActionButton(
                      Icons.view_list_outlined,
                      withContianer: true,
                      containerColor: context.watch<ViewController>().isList
                          ? primaryColor
                          : Constants.unselectedColor,
                      iconColor: context.watch<ViewController>().isList
                          ? Colors.white
                          : primaryColor,
                      onPressed: () {
                        context.read<ViewController>().isList = true;
                      },
                    ),
                    spacer,
                    CommonUtils.svgIconActionButton(
                      'assets/svg/home.svg',
                      withContianer: true,
                      containerColor: context.watch<ViewController>().isHome
                          ? primaryColor
                          : Constants.unselectedColor,
                      iconColor: context.watch<ViewController>().isHome
                          ? Colors.white
                          : primaryColor,
                    ),
                    // spacer,
                    // CommonUtils.svgIconActionButton(
                    //   'assets/svg/home.svg',
                    //   withContianer: true,
                    //   containerColor: context.watch<ViewController>().isHome
                    //       ? primaryColor
                    //       : Constants.unselectedColor,
                    //   iconColor: context.watch<ViewController>().isHome
                    //       ? Colors.white
                    //       : primaryColor,
                    // ),
                    spacer,
                    ...context
                        .read<PosCategoryController>()
                        .posCategoryList
                        .asMap()
                        .map(
                          (i, e) => MapEntry(
                              i,
                              InkWell(
                                onTap: () {
                                  context
                                          .read<PosCategoryController>()
                                          .selectedCategory =
                                      context
                                          .read<PosCategoryController>()
                                          .posCategoryList[i]
                                          .id;

                                  context.read<ItemListController>().offset = 0;
                                  context
                                      .read<ItemListController>()
                                      .currentIndex = 1;
                                  context
                                      .read<ItemListController>()
                                      .getAllProduct(
                                        context,
                                        sessionId: context
                                                .read<LoginUserController>()
                                                .posSession
                                                ?.id ??
                                            0,
                                      );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: context
                                                    .watch<
                                                        PosCategoryController>()
                                                    .selectedCategory ==
                                                context
                                                    .read<
                                                        PosCategoryController>()
                                                    .posCategoryList[i]
                                                    .id
                                            ? primaryColor
                                            : primaryColor.withOpacity(0.76),
                                      ),
                                      child: Text(
                                        e.name ?? '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: context
                                                        .watch<
                                                            PosCategoryController>()
                                                        .selectedCategory ==
                                                    context
                                                        .read<
                                                            PosCategoryController>()
                                                        .posCategoryList[i]
                                                        .id
                                                ? FontWeight.bold
                                                : FontWeight.w300),
                                      ),
                                    ),
                                    spacer,
                                  ],
                                ),
                              )),
                        )
                        .values
                        .toList(),
                  ],
                ),
              ),
            ),
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
