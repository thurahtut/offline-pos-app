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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonUtils.svgIconActionButton(
                'assets/svg/grid_outlined.svg',
                width: 28,
                height: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Point of Sale',
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
      color: Constants.primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    bool isMobileMode = CommonUtils.isMobileMode(context);
    return [
      if (isMobileMode) ..._actionButtonsWidget(),
      Text(
        'Dashboard',
        style: textStyle,
      ),
      Text(
        'Orders',
        style: textStyle,
      ),
      Text(
        'Product',
        style: textStyle,
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
      Text(
        'Configuration',
        style: textStyle,
      ),
    ];
  }
}
