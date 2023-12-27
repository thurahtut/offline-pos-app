import 'package:offline_pos/components/export_files.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key});
  static const String routeName = "/inventory_list_screen";

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  bool? isTabletMode;
  bool? isMobileMode;
  List<Inventory> inventoryList = [];

  Inventory demoInventory = Inventory(
    shopName: "Transit Maxi - Main",
    warehouseName: "Maxi-1 (M1) Warehouse",
    process: 100,
    late: 116,
    waiting: 7,
    backOrder: 2,
    batch: 3,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      for (int i = 0; i < 10; i++) {
        inventoryList.add(demoInventory);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: InventoryAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        SizedBox(height: 10),
        _filtersWidget(),
        SizedBox(height: 10),
        Expanded(child: _inventoryListWidget()),
      ],
    );
  }

  Widget _filtersWidget() {
    return Row(
      children: [
        if (isMobileMode != true) Expanded(child: SizedBox()),
        Expanded(
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
                    // SizedBox(width: 4),
                    // CommonUtils.svgIconActionButton('assets/svg/view_list.svg'),
                    // SizedBox(width: 4),
                    // CommonUtils.svgIconActionButton('assets/svg/grid_view.svg'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _inventoryListWidget() {
    return MediaQuery.of(context).size.width < 738
        ? ListView(
            children: inventoryList
                .map(
                  (e) => _inventoryWidget(e),
                )
                .toList(),
          )
        : GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTabletMode == true ? 2 : 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: isTabletMode == true ? 1.7 : 2.2),
            children: inventoryList
                .map(
                  (e) => e.shopName != null ? _inventoryWidget(e) : SizedBox(),
                )
                .toList(),
          );
  }

  Widget _inventoryWidget(Inventory e) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductPackagingScreen.routeName);
      },
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.width < 738 ? 2.9 : 2.2,
        child: Container(
          width: MediaQuery.of(context).size.width /
              (isTabletMode == true ? 2 : 3),
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Constants.greyColor2.withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      e.shopName ?? '',
                      style: TextStyle(
                        color: Constants.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      e.warehouseName ?? '',
                      style: TextStyle(
                        color: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    BorderContainer(
                      text: '${e.process ?? 0} To Process',
                      containerColor: Constants.primaryColor,
                      textColor: Colors.white,
                      textSize: 18,
                      width: 150,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommonUtils.iconActionButton(
                            Icons.more_horiz_rounded,
                            iconColor: Constants.accentColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${e.waiting ?? 0} Waiting',
                        style: TextStyle(
                          color: Constants.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${e.late ?? 0} Late',
                        style: TextStyle(
                          color: Constants.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${e.backOrder ?? 0} Back Order',
                        style: TextStyle(
                          color: Constants.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${e.batch ?? 0} Batches',
                        style: TextStyle(
                          color: Constants.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
            
        ),
      ),
    );
  }
}

class Inventory {
  String? shopName;
  String? warehouseName;
  int? process;
  int? waiting;
  int? late;
  int? backOrder;
  int? batch;

  Inventory(
      {this.shopName,
      this.warehouseName,
      this.process,
      this.waiting,
      this.late,
      this.backOrder,
      this.batch});

  Inventory.fromJson(Map<String, dynamic> json) {
    shopName = json['shop_name'];
    warehouseName = json['warehouse_name'];
    process = json['process'];
    waiting = json['waiting'];
    late = json['late'];
    backOrder = json['back_order'];
    batch = json['batch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop_name'] = shopName;
    data['warehouse_name'] = warehouseName;
    data['process'] = process;
    data['waiting'] = waiting;
    data['late'] = late;
    data['back_order'] = backOrder;
    data['batch'] = batch;
    return data;
  }
}
