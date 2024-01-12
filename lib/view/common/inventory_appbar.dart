import '../../components/export_files.dart';

class InventoryAppBar extends StatefulWidget implements PreferredSizeWidget {
  const InventoryAppBar({super.key});

  @override
  State<InventoryAppBar> createState() => _InventoryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}

class _InventoryAppBarState extends State<InventoryAppBar> {
  final spacer = Expanded(flex: 1, child: SizedBox());
  final ValueNotifier<bool> _showSearchBox = ValueNotifier(false);
  int index = 0;

  final List _productMenuList = [
    {
      "title": "Products",
      "onTap": (context) {
        Navigator.pushNamed(context, ProductListScreen.routeName);
      }
    },
    {"title": "Product Variants", "onTap": (context) {}},
    {"title": "Product Tags", "onTap": (context) {}},
    {"title": "Custom Product Template", "onTap": (context) {}},
    {"title": "Pricelists", "onTap": (context) {}},
    {"title": "Product Multi UOM", "onTap": (context) {}},
    {
      "title": "Product Packagings",
      "onTap": (context) {
        Navigator.pushNamed(context, ProductPackagingScreen.routeName);
      }
    },
    {
      "title": "Pricelist Item",
      "onTap": (context) {
        Navigator.pushNamed(context, PriceRulesListScreen.routeName);
      }
    },
    {"title": "Weight Barcode", "onTap": (context) {}},
    {"title": "Loyalty Programs", "onTap": (context) {}},
    {"title": "Coupon Programs", "onTap": (context) {}},
    {"title": "Notification", "onTap": (context) {}},
  ];

  final List _configurationMenuList = [
    {"title": "Settings", "onTap": () {}},
    {"title": "Point of Sale", "onTap": () {}},
    {"title": "POS Theme Settings", "onTap": () {}},
    {"title": "Shop Information", "onTap": () {}},
    {
      "title": "Payment Methods",
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(NavigationService.navigatorKey.currentContext!,
              PaymentMethodScreen.routeName);
        }
      }
    },
    {"title": "POS Discount", "onTap": () {}},
    {"title": "Login Popup", "onTap": () {}},
    {"title": "Coins/Bills", "onTap": () {}},
    {"title": "Special Terms", "onTap": () {}},
    {"title": "Multi Banners", "onTap": () {}},
    {"title": "Member Config", "onTap": () {}},
    {"title": "Gift Card", "onTap": () {}},
    {"title": "Order Note", "onTap": () {}},
    {"title": "POS Cash In/Out", "onTap": () {}},
    {"title": "POS Product Delete History", "onTap": () {}},
    {
      "title": "Products",
      "children": [
        {"title": "POS Product Categories", "onTap": () {}},
        {"title": "Attributes", "onTap": () {}},
      ],
      "onTap": () {}
    },
    {"title": "Advanced Loyalty Programme", "onTap": () {}},
    {"title": "All Advanced Coupon", "onTap": () {}},
    {"title": "Merge POS Category", "onTap": () {}},
    {"title": "Log Track", "onTap": () {}},
  ];

  @override
  void dispose() {
    _showSearchBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);

    bool isMobileMode = CommonUtils.isMobileMode(context);
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Constants.greyColor.withOpacity(0.7),
      elevation: 12,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
        mainAxisAlignment: isMobileMode || isTabletMode
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceAround,
        mainAxisSize:
            isMobileMode || isTabletMode ? MainAxisSize.min : MainAxisSize.max,
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    ModalRoute.withName("/Home"));
              },
              icon: Icon(
                Icons.home_filled,
                color: primaryColor,
                size: 35,
              )),
          if (!isTabletMode) ..._titleList(),
        ],
      ),
      actions: [
        if (!isMobileMode) ..._actionButtonsWidget(),
        if (isTabletMode)
          PopupMenuButton(
            tooltip: "",
            itemBuilder: (bContext) {
              return [
                ..._titleList().map(
                  (e) {
                    PopupMenuEntry<int> ww = PopupMenuItem<int>(
                      value: index,
                      child: e,
                    );
                    index++;
                    return ww;
                  },
                ).toList()
              ];
            },
            child: CommonUtils.svgIconActionButton(
              'assets/svg/menu.svg',
            ),
          ),
        SizedBox(width: 4),
      ],
    );
  }

  List<Widget> _actionButtonsWidget() {
    return [
      IconButton(
        onPressed: () {},
        icon: Text(
          'SSS Int Co,Ltd.',
          style: TextStyle(
            color: Constants.textColor,
            // fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: CommonUtils.appBarActionButtonWithText(
          'assets/svg/account_circle.svg',
          'Username',
          textColor: Constants.textColor,
          // fontSize: 13,
          onPressed: () {},
        ),
      ),
    ];
  }

  List<Widget> _titleList() {
    TextStyle textStyle = TextStyle(
      color: primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    bool isMobileMode = CommonUtils.isMobileMode(context);
    return [
      if (isMobileMode) ..._actionButtonsWidget(),
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, MainScreen.routeName);
        },
        child: Text(
          'Dashboard',
          style: textStyle,
        ),
      ),
      Text(
        'Orders',
        style: textStyle,
      ),
      PopupMenuButton(
        tooltip: "",
        itemBuilder: (bContext) {
          return [
            ..._productMenuList.map(
              (e) {
                return PopupMenuItem<int>(
                  value: 0,
                  onTap: () {
                    e["onTap"]?.call(context);
                  },
                  child: Text(e['title']),
                );
              },
            ).toList()
          ];
        },
        child: CommonUtils.iconActionButtonWithText(
          Icons.keyboard_arrow_down_rounded,
          'Product',
          iconColor: Constants.accentColor,
          switchChild: true,
          textColor: textStyle.color,
          fontWeight: textStyle.fontWeight,
          fontSize: textStyle.fontSize,
        ),
      ),
      Text(
        'Wallet Management',
        style: textStyle,
      ),
      Text(
        'Point Management',
        style: textStyle,
      ),
      Text(
        'Reporting',
        style: textStyle,
      ),
      // PopupMenuButton(
      //   tooltip: "",
      //   itemBuilder: (bContext) {
      //     return [
      //       ..._configurationMenuList.map(
      //         (e) {
      //           return PopupMenuItem<int>(
      //             value: 0,
      //             onTap: e["children"] != null ? null : e["onTap"],
      //             child: e["children"] != null
      //                 ? TreeView(
      //                     treeController:
      //                         TreeController(allNodesExpanded: true),
      //                     indent: 1,
      //                     nodes: [
      //                       TreeNode(
      //                         content: Text(
      //                           e['title'],
      //                           style: textStyle.copyWith(
      //                             fontSize: 13,
      //                             color: Constants.textColor,
      //                           ),
      //                         ),
      //                         children: [
      //                           ...(e["children"] is List)
      //                               ? e["children"]
      //                                   .map(
      //                                     (value) => TreeNode(
      //                                       content: Text(
      //                                         value['title'],
      //                                         style: textStyle.copyWith(
      //                                           color: Constants.textColor,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   )
      //                                   .toList()
      //                               : []
      //                         ],
      //                       ),
      //                     ],
      //                   )
      //                 : Text(e['title']),
      //           );
      //         },
      //       ).toList()
      //     ];
      //   },
      //   child: CommonUtils.iconActionButtonWithText(
      //     Icons.keyboard_arrow_down_rounded,
      //     'Configuration',
      //     iconColor: Constants.accentColor,
      //     switchChild: true,
      //     textColor: textStyle.color,
      //     fontWeight: textStyle.fontWeight,
      //     fontSize: textStyle.fontSize,
      //   ),
      // ),
   
    ];
  }
}
