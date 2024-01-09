import 'package:offline_pos/components/export_files.dart';

class ProductDetailPermissionTitle extends StatefulWidget {
  const ProductDetailPermissionTitle({super.key});

  @override
  State<ProductDetailPermissionTitle> createState() =>
      _ProductDetailPermissionTitleState();
}

class _ProductDetailPermissionTitleState
    extends State<ProductDetailPermissionTitle> {
  final TextEditingController _productNameTextController =
      TextEditingController();
  bool? isMobileMode;
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isMobileMode = CommonUtils.isMobileMode(context);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _productNameTextController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thickness: MediaQuery.of(context).size.width > 1080 ? 0 : 6,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Constants.greyColor2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: MediaQuery.of(context).size.width > 1080
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._permissionTitleList().map((e) {
                if (e is SizedBox) {
                  return e;
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width > 1080
                      ? MediaQuery.of(context).size.width /
                          ((_permissionTitleList().length / 2) + 0.5)
                      : 250,
                  child: e,
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _permissionTitleList() {
    return [
      CommonUtils.iconActionButtonWithText(
        Icons.list_rounded,
        'Extra Price',
        size: 28,
      ),
      SizedBox(width: 4),
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/globe.svg',
        'Go to website',
        width: 23,
        height: 23,
      ),
      SizedBox(width: 4),
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/globe.svg',
        'Published an app',
        width: 23,
        height: 23,
      ),
      SizedBox(width: 4),
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/data_thresholding.svg',
        '0.00 Unit sold',
        width: 22,
        height: 22,
      ),
      SizedBox(width: 4),
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/package_2.svg',
        '0.00 Bags Forecasted',
        width: 24,
        height: 24,
      ),
      SizedBox(width: 4),
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/package_2.svg',
        '0.00 On Hand',
        width: 24,
        height: 24,
      ),
      SizedBox(width: 4),
      PopupMenuButton<int>(
        color: Constants.backgroundColor,
        shadowColor: Colors.transparent,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tooltip: "",
        itemBuilder: (bContext) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.iconActionButtonWithText(
                Icons.swap_horiz_rounded,
                'In : 35  Out : 35',
                size: 30,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 1,
              child: CommonUtils.appBarActionButtonWithText(
                'assets/svg/sell.svg',
                '66.00 Unit Sold',
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.iconActionButtonWithText(
                Icons.autorenew_rounded,
                '0 Reordering',
                size: 30,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.iconActionButtonWithText(
                Icons.monetization_on_rounded,
                '1 Bill of Material',
                size: 28,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 1,
              child: CommonUtils.appBarActionButtonWithText(
                'assets/svg/arrows_more_up.svg',
                '1 Used In',
                width: 20,
                height: 20,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 1,
              child: CommonUtils.appBarActionButtonWithText(
                'assets/svg/developer_guide.svg',
                'Putaway Rules',
                width: 20,
                height: 20,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.iconActionButtonWithText(
                Icons.loyalty_rounded,
                'Quality Control Points',
                size: 26,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.iconActionButtonWithText(
                Icons.storage,
                'Storage Capacities',
                size: 24,
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.iconActionButtonWithText(
                Icons.credit_card,
                '5.00 Unit Purchased',
                size: 24,
              ),
            ),
          ];
        },
        child: CommonUtils.iconActionButtonWithText(
          Icons.keyboard_arrow_down_rounded,
          'More',
          size: 28,
          switchChild: true,
        ),
      ),
    ];
  }
}
