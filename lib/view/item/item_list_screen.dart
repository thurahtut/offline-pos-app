import 'package:offline_pos/components/export_files.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key, required this.showSideBar});

  final ValueNotifier<bool> showSideBar;
  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  Widget build(BuildContext context) {
    return _itemListWidget();
  }

  Widget _itemListWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return ValueListenableBuilder<bool>(
        valueListenable: widget.showSideBar,
        builder: (_, showSidebar, __) {
          return Container(
            width: isTabletMode
                ? (MediaQuery.of(context).size.width / 10) * 9
                : ((MediaQuery.of(context).size.width / 5.3) * 3) +
                    (showSidebar ? 0 : MediaQuery.of(context).size.width / 5.5),
            decoration: BoxDecoration(
              color:
                  context.watch<ViewController>().isList
                  ? Colors.white
                  : null,
            ),
            child: context.watch<ViewController>().isList
                ? _itemListWithListViewWidget(showSidebar)
                : _itemListWithGridViewWidget(showSidebar),
          );
        });
  }

  Widget _itemListWithListViewWidget(bool showSidebar) {
    return Column(
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
                    widget.showSideBar.value = !widget.showSideBar.value;
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
    );
  }

  Widget _itemListWithGridViewWidget(bool showSidebar) {
    TextStyle textStyle = TextStyle(
      color: Constants.textColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return SizedBox(
      width: isTabletMode
          ? (MediaQuery.of(context).size.width / 10) * 9
          : ((MediaQuery.of(context).size.width / 5.3) * 3) +
              (showSidebar ? 0 : MediaQuery.of(context).size.width / 5.5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: CommonUtils.svgIconActionButton(
              "assets/svg/${showSidebar ? "close_sidebar.svg" : "open_sidebar.svg"}",
              height: 40,
              onPressed: () {
                widget.showSideBar.value = !widget.showSideBar.value;
              },
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTabletMode ? 5 : 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              children: CommonUtils.itemList
                  .map((e) => InkWell(
                        onTap: () => _addItemToList(e),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(
                                  color:
                                      Constants.greyColor2.withOpacity(0.2))),
                          color: Constants.unselectedColor.withOpacity(0.8),
                          shadowColor: Colors.white,
                          elevation: 7,
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            "${e["price"]} Ks".toString(),
                                            style: textStyle)),
                                    CommonUtils.svgIconActionButton(
                                      'assets/svg/Info.svg',
                                    ),
                                  ],
                                ),
                                CommonUtils.svgIconActionButton(
                                  'assets/svg/broken_image.svg',
                                  iconColor: Constants.disableColor,
                                  width: 35,
                                  height: 35,
                                ),
                                RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(text: "", children: [
                                    TextSpan(
                                      text: "[${e["id"]}]",
                                      style: textStyle.copyWith(
                                          color: Constants.successColor),
                                    ),
                                    TextSpan(text: e["name"], style: textStyle),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
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
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return InkWell(
      onTap: () => _addItemToList(object),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 18),
        height: isTabletMode ? 46 : 52,
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
            Expanded(
                child: Text(object["on_hand"].toString(), style: textStyle)),
            Expanded(child: Text(object["unit"], style: textStyle)),
            Expanded(child: Text(object["price"].toString(), style: textStyle)),
          ],
        ),
      ),
    );
  }

  void _addItemToList(dynamic object) {
    object["qty"] = 1;
    context.read<CurrentOrderController>().currentOrderList.add(object);
    context.read<CurrentOrderController>().notify();
  }
}
