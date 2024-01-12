import '../../components/export_files.dart';

class SaleAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onChanged;
  const SaleAppBar({super.key, this.onChanged});

  @override
  State<SaleAppBar> createState() => _SaleAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}

class _SaleAppBarState extends State<SaleAppBar> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  final spacer = Expanded(flex: 1, child: SizedBox());
  final ValueNotifier<bool> _showSearchBox = ValueNotifier(false);

  @override
  void dispose() {
    _searchProductTextController.dispose();
    _showSearchBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: BackButton(
          color: primaryColor,
          style: ButtonStyle(
            iconSize: MaterialStateProperty.resolveWith((states) => 30),
          ),
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.watch<ThemeSettingController>().appConfig?.logo != null
          ? Image.memory(
              context.read<ThemeSettingController>().appConfig!.logo!,
        width: 120,
        height: 60,
        fit: BoxFit.fitWidth,
            )
              : SizedBox(),
          isTabletMode ? SizedBox(width: 10) : spacer,
          CommonUtils.appBarActionButtonWithText(
            'assets/svg/Cash.svg',
            'Cash In/Out',
            fontSize: 16,
            onPressed: () {
              CashInOutDialog.cashInOutDialogWidget(context);
            },
          ),
          isTabletMode ? SizedBox(width: 10) : spacer,
          CommonUtils.appBarActionButtonWithText(
            'assets/svg/order_approve.svg',
            'Order',
            fontSize: 16,
            onPressed: () {
              Navigator.pushNamed(
                context,
                OrderListScreen.routeName,
              );
            },
          ),
          ...isTabletMode ? _forTabletView : _forWindowView,
        ],
      ),
    );
  }

  List<Widget> get _forTabletView {
    return [
      Expanded(child: SizedBox()),
      ValueListenableBuilder<bool>(
        valueListenable: _showSearchBox,
        builder: (_, showSearchBox, __) {
          if (showSearchBox) {
            return Expanded(child: _searchProductWidget());
          }
          return CommonUtils.svgIconActionButton(
            'assets/svg/search.svg',
            onPressed: () {
              _showSearchBox.value = !_showSearchBox.value;
            },
          );
        },
      ),
      SizedBox(width: 4),
      PopupMenuButton(
        tooltip: "",
        itemBuilder: (bContext) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/account_circle.svg', 'Easy 3 A - Store Leader',
                  fontSize: 16, onPressed: () {
                Navigator.pop(bContext);
                return ChooseCashierDialog.chooseCashierDialogWidget(
                  context,
                );
              }),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/network_wifi.svg', 'Wifi Address Name',
                  fontSize: 16, onPressed: () {
                return ChooseCashierDialog.chooseCashierDialogWidget(
                  context,
                );
              }),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/credit_card.svg', 'Customer\'s Screen',
                  fontSize: 16, onPressed: () {
                return ChooseCashierDialog.chooseCashierDialogWidget(
                  context,
                );
              }),
            ),
            PopupMenuItem<int>(
              value: 3,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/lock_open_right.svg', 'Lock / Unlock',
                  fontSize: 16, onPressed: () {
                return ChooseCashierDialog.chooseCashierDialogWidget(
                  context,
                );
              }),
            ),
            PopupMenuItem<int>(
              value: 4,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/move_item.svg', 'Close', fontSize: 16,
                  onPressed: () {
                return ChooseCashierDialog.chooseCashierDialogWidget(
                  context,
                );
              }),
            ),
          ];
        },
        child: CommonUtils.svgIconActionButton(
          'assets/svg/menu.svg',
        ),
      ),
    ];
  }

  List<Widget> get _forWindowView {
    return [
      spacer,
      Expanded(
        flex: 25,
        child: _searchProductWidget(),
      ),
      spacer,
      CommonUtils.appBarActionButtonWithText(
          'assets/svg/account_circle.svg', 'Easy 3 A - Store Leader',
          fontSize: 16, onPressed: () {
        return ChooseCashierDialog.chooseCashierDialogWidget(
          context,
        );
      }),
      spacer,
      CommonUtils.svgIconActionButton(
        'assets/svg/network_wifi.svg',
      ),
      spacer,
      CommonUtils.svgIconActionButton(
        'assets/svg/credit_card.svg',
      ),
      spacer,
      CommonUtils.svgIconActionButton('assets/svg/lock_open_right.svg',
          onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            ModalRoute.withName("/Home"));
      }),
      spacer,
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/move_item.svg',
        'Close',
        fontSize: 16,
      ),
    ];
  }

  Center _searchProductWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
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
            hintText: 'Search Products...',
            hintStyle: TextStyle(fontSize: 14),
            filled: true,
            fillColor: Constants.greyColor,
            prefixIcon: UnconstrainedBox(
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _searchProductTextController.clear();
                _showSearchBox.value = false;
                context.read<ItemListController>().filterValue = null;
                context.read<ItemListController>().offset = 0;
                context.read<ItemListController>().currentIndex = 1;
                context.read<ItemListController>().getAllProduct();
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
          onChanged: (value) {
            context.read<ItemListController>().filterValue = value;
            context.read<ItemListController>().offset = 0;
            context.read<ItemListController>().currentIndex = 1;
            context.read<ItemListController>().getAllProduct();
          },
        ),
      ),
    );
  }
}
