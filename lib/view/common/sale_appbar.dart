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
          Navigator.pushNamed(
            context,
            WelcomeScreen.routeName,
          );
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
          isTabletMode ? SizedBox(width: 10) : spacer,
          CommonUtils.svgIconActionButton(
            context.watch<ViewController>().hideCategory == true
                ? 'assets/svg/category_fill.svg'
                : 'assets/svg/category_unfill.svg',
            width: 22,
            height: 22,
            onPressed: () {
              context.read<ViewController>().hideCategory =
                  !context.read<ViewController>().hideCategory;
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
              child: _cashierWidget(bContext, true),
            ),
            // PopupMenuItem<int>(
            //   value: 1,
            //   child: CommonUtils.appBarActionButtonWithText(
            //       'assets/svg/network_wifi.svg', 'Wifi Address Name',
            //       fontSize: 16, onPressed: () {}),
            // ),
            PopupMenuItem<int>(
              value: 2,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/credit_card.svg', 'Customer\'s Screen',
                  fontSize: 16, onPressed: () {}),
            ),
            PopupMenuItem<int>(
              value: 3,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/lock_open_right.svg', 'Lock / Unlock',
                  fontSize: 16, onPressed: () {
                _logOut();
              }),
            ),
            PopupMenuItem<int>(
              value: 4,
              child: CommonUtils.appBarActionButtonWithText(
                  'assets/svg/move_item.svg', 'Close',
                  fontSize: 16, onPressed: () {}),
            ),
          ];
        },
        child: CommonUtils.svgIconActionButton(
          'assets/svg/menu.svg',
        ),
      ),
    ];
  }

  Widget _cashierWidget(BuildContext bContext, bool isPopup) {
    return CommonUtils.appBarActionButtonWithText(
      'assets/svg/account_circle.svg',
      context.watch<LoginUserController>().loginEmployee?.name != null
          ? context.read<LoginUserController>().loginEmployee!.name!
          : '',
      fontSize: 16,
      onPressed: () {
        if (isPopup) {
          Navigator.pop(bContext);
        }
        return ChooseCashierDialog.chooseCashierDialogWidget(
          context,
        ).then((value) {
          if (value == true) {
            LoginUserController controller =
                context.read<LoginUserController>();
            int? configId = controller.posConfig?.id;
            Api.getPosSessionByID(configId: configId).then((sessionResponse) {
              if (sessionResponse != null &&
                  sessionResponse.statusCode == 200 &&
                  sessionResponse.data != null &&
                  sessionResponse.data is List &&
                  (sessionResponse.data as List).isNotEmpty) {
                controller.posSession =
                    POSSession.fromJson((sessionResponse.data as List).first);
                POSSessionTable.insertOrUpdatePOSSession(
                    controller.posSession!);
              } else {
                return CreateSessionDialog.createSessionDialogWidget(context)
                    .then((value) {
                  if (value == true) {
                    context.read<ThemeSettingController>().notify();
                  }
                });
              }
            });
          }
        });
      },
    );
  }

  void _logOut() {
    DatabaseHelper.logOut().then(
      (value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserLoginScreen()),
        ModalRoute.withName("/Home"),
      ),
    );
  }

  List<Widget> get _forWindowView {
    return [
      spacer,
      Expanded(
        flex: 25,
        child: _searchProductWidget(),
      ),
      spacer,
      _cashierWidget(context, false),
      // spacer,
      // CommonUtils.svgIconActionButton(
      //   'assets/svg/network_wifi.svg',
      // ),
      spacer,
      CommonUtils.svgIconActionButton(
        'assets/svg/credit_card.svg',
      ),
      spacer,
      CommonUtils.svgIconActionButton('assets/svg/lock_open_right.svg',
          onPressed: () {
        _logOut();
      }),
      spacer,
      CommonUtils.appBarActionButtonWithText(
        'assets/svg/move_item.svg',
        'Close',
        fontSize: 16,
        onPressed: () {},
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
          // autofocus: true,
          focusNode: context.read<ViewController>().searchProductFocusNode,
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
                _clearSearch();
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
            ItemListController itemListController =
                context.read<ItemListController>();
            itemListController.filterValue = value;
            itemListController.offset = 0;
            itemListController.currentIndex = 1;
            itemListController.getAllProduct(context);
          },
        ),
      ),
    );
  }

  void _clearSearch() {
    ItemListController itemListController = context.read<ItemListController>();
    _searchProductTextController.clear();
    _showSearchBox.value = false;
    itemListController.filterValue = null;
    itemListController.offset = 0;
    itemListController.currentIndex = 1;
    itemListController.getAllProduct(context);
  }
}
