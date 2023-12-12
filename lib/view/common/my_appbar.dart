import '../../components/export_files.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}

class _MyAppBarState extends State<MyAppBar> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final spacer = Expanded(flex: 1, child: SizedBox());
  final ValueNotifier<bool> _showSearchBox = ValueNotifier(false);

  @override
  void dispose() {
    _searchProductTextController.dispose();
    _passwordTextController.dispose();
    _showSearchBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return AppBar(
      backgroundColor: Colors.white,
      leading: Image.asset(
        'assets/png/logo_small.png',
        width: 120,
        height: 60,
        fit: BoxFit.fitWidth,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonUtils.svgIconActionButton(
            'assets/svg/border_color.svg',
          ),
          isTabletMode ? SizedBox(width: 10) : spacer,
          _appBarActionButtonWithText(
            'assets/svg/Cash.svg',
            'Cash In/Out',
            fontSize: 16,
          ),
          isTabletMode ? SizedBox(width: 10) : spacer,
          _appBarActionButtonWithText(
            'assets/svg/order_approve.svg',
            'Order',
            fontSize: 16,
          ),
          ...isTabletMode
              ? [
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
                  CommonUtils.svgIconActionButton(
                    'assets/svg/menu.svg',
                  ),
                ]
              : [
                  spacer,
                  Expanded(
                    flex: 25,
                    child: _searchProductWidget(),
                  ),
                  spacer,
                  _appBarActionButtonWithText('assets/svg/account_circle.svg',
                      'Easy 3 A - Store Leader',
                      fontSize: 16, onPressed: () {
                    return ChooseCashierDialog.chooseCashierDialogWidget(
                      context,
                      _passwordTextController,
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
                  CommonUtils.svgIconActionButton(
                    'assets/svg/lock_open_right.svg',
                  ),
                  spacer,
                  _appBarActionButtonWithText(
                    'assets/svg/move_item.svg',
                    'Close',
                    fontSize: 16,
                  ),
                ],
        ],
      ),
    );
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
                  Constants.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _searchProductTextController.clear();
                _showSearchBox.value = false;
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
        ),
      ),
    );
  }

  Widget _appBarActionButtonWithText(
    String svg,
    String text, {
    double? width,
    double? height,
    Color? iconColor,
    Color? textColor,
    double? fontSize,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          CommonUtils.svgIconActionButton(
            svg,
            width: width,
            height: height,
            iconColor: iconColor,
            onPressed: onPressed,
          ),
          Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
