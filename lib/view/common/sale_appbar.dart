import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../../components/export_files.dart';

class SaleAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onChanged;
  const SaleAppBar({super.key, this.onChanged});

  @override
  State<SaleAppBar> createState() => _SaleAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}

class _SaleAppBarState extends State<SaleAppBar> with TickerProviderStateMixin {
  final spacer = Expanded(flex: 1, child: SizedBox());
  final ValueNotifier<bool> _showSearchBox = ValueNotifier(false);
  final ValueNotifier<bool> _isSyncOH = ValueNotifier(false);
  AnimationController? _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _clearSearch();
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (mounted) {
        context.read<ViewController>().connectedWifi =
            (connectivityResult != ConnectivityResult.none);
      }
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        context.read<ViewController>().connectedWifi =
            (result != ConnectivityResult.none);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _showSearchBox.dispose();
    _controller?.dispose();
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
          // CommonUtils.appBarActionButtonWithText(
          //   'assets/svg/Cash.svg',
          //   'Cash In/Out',
          //   fontSize: 16,
          //   onPressed: () {
          //     CashInOutDialog.cashInOutDialogWidget(context);
          //   },
          // ),
          Text(
            context.read<LoginUserController>().posSession?.name ?? '',
            style: TextStyle(fontSize: 16),
          ),
          isTabletMode ? SizedBox(width: 10) : spacer,
          TooltipWidget(
            message: 'Order',
            child: CommonUtils.appBarActionButtonWithText(
              'assets/svg/order_approve.svg',
              'Order',
              fontSize: 16,
              onPressed: () {
                if (context
                    .read<CurrentOrderController>()
                    .currentOrderList
                    .isNotEmpty) {
                  CommonUtils.uploadOrderHistoryToDatabase(
                    context,
                    isNavigate: false,
                  ).then((value) {
                    context
                        .read<CurrentOrderController>()
                        .resetCurrentOrderController();
                    Navigator.pushNamed(
                      context,
                      OrderListScreen.routeName,
                    );
                  });
                } else {
                  Navigator.pushNamed(
                    context,
                    OrderListScreen.routeName,
                  );
                }
              },
            ),
          ),
          isTabletMode ? SizedBox(width: 10) : spacer,
          TooltipWidget(
            message: context.watch<ViewController>().hideCategory == true
                ? 'Show Category'
                : 'Hide Category',
            child: CommonUtils.svgIconActionButton(
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
      TooltipWidget(
        message: 'Wifi',
        child: Consumer<ViewController>(builder: (_, controller, __) {
          return CommonUtils.iconActionButton(
            controller.connectedWifi ? Icons.wifi : Icons.signal_wifi_0_bar,
            size: 30,
          );
        }),
      ),
      SizedBox(width: 4),
      PopupMenuButton(
        tooltip: "",
        child: CommonUtils.svgIconActionButton(
          'assets/svg/menu.svg',
        ),
        onSelected: (value) {},
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
            // PopupMenuItem<int>(
            //   value: 1,
            //   child: TooltipWidget(
            //     message: 'Customer\'s Screen',
            //     child: CommonUtils.appBarActionButtonWithText(
            //         'assets/svg/credit_card.svg', 'Customer\'s Screen',
            //         fontSize: 16, onPressed: () {}),
            //   ),
            // ),
            PopupMenuItem<int>(
              value: 2,
              child: TooltipWidget(
                message: 'Lock / Unlock',
                child: CommonUtils.appBarActionButtonWithText(
                    'assets/svg/lock_open_right.svg', 'Lock / Unlock',
                    fontSize: 16, onPressed: () {
                  _logOut();
                }),
              ),
            ),
            PopupMenuItem<int>(
              value: 3,
              child: TooltipWidget(
                message: 'Sync Order History',
                child: ValueListenableBuilder<bool>(
                    valueListenable: _isSyncOH,
                    builder: (_, isSyncOH, __) {
                      return _controller != null
                          ? CommonUtils.appBarActionButtonWithText(
                              'assets/svg/sync.svg', 'Sync Order History',
                              fontSize: 16, iconParentWidget: (child) {
                              return RotationTransition(
                                turns: _controller!,
                                child: child,
                              );
                            }, onPressed: () {
                              _syncOrderHistory();
                            })
                          : CommonUtils.appBarActionButtonWithText(
                              'assets/svg/sync.svg', 'Sync Order History',
                              fontSize: 16, onPressed: () {
                              _syncOrderHistory();
                            });
                    }),
              ),
            ),
            PopupMenuItem<int>(
              value: 4,
              child: _closeSessionWidget(bContext, true),
            ),
          ];
        },
      ),
    ];
  }

  Widget _closeSessionWidget(BuildContext bContext, bool isPopup) {
    return TooltipWidget(
      message: 'Close Session',
      child: CommonUtils.appBarActionButtonWithText(
        'assets/svg/move_item.svg',
        'Close',
        fontSize: 16,
        onPressed: () {
          if (isPopup) {
            Navigator.pop(bContext);
          }
          return CreateSessionDialog.createSessionDialogWidget(context, false);
        },
      ),
    );
  }

  Widget _cashierWidget(BuildContext bContext, bool isPopup) {
    return Consumer<LoginUserController>(builder: (_, controller, __) {
      return TooltipWidget(
        message: controller.loginEmployee?.name != null
            ? controller.loginEmployee!.name!
            : 'Account',
        child: CommonUtils.appBarActionButtonWithText(
          'assets/svg/account_circle.svg',
          controller.loginEmployee?.name != null
              ? controller.loginEmployee!.name!
              : '',
          fontSize: 16,
          onPressed: () {
            int sessionId = controller.posSession?.id ?? 0;
            OrderHistoryTable.isExistDraftOrders(sessionId: sessionId)
                .then((value) {
              if (value == true) {
                CommonUtils.showSnackBar(
                  context: context,
                  message:
                      'You can\'t change cashier due to existing draft orders.',
                );
              } else {
                if (isPopup) {
                  Navigator.pop(bContext);
                }
                CommonUtils.sessionLoginMethod(context, false);
              }
            });
          },
        ),
      );
    });
  }

  void _logOut() {
    int sessionId = context.read<LoginUserController>().posSession?.id ?? 0;
    OrderHistoryTable.isExistDraftOrders(sessionId: sessionId).then((value) {
      if (value == true) {
        CommonUtils.showSnackBar(
          context: context,
          message: "You can't logout due to existing draft orders.",
        );
      } else {
        context.read<LoginUserController>().loginEmployee = null;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          ModalRoute.withName("/Home"),
        );
      }
    });
  }

  _syncOrderHistory() {
    if (!context.read<ViewController>().connectedWifi) {
      CommonUtils.showAlertDialogWithOkButton(context,
          title: "No Internet Connection!",
          content: "You can't sync data cause no internet connection.");
      return;
    }
    int sessionId = context.read<LoginUserController>().posSession?.id ?? 0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..repeat();
    _isSyncOH.value = true;
    try {
      OrderHistoryTable.getOrderHistoryList(
        isCloseSession: true,
        sessionId: sessionId,
        isReturnOrder: false,
      ).then((value) async {
        for (var mapArg in value) {
          print(jsonEncode(mapArg));
        }
        await _uploadSyncOrderHistoryToOfflineDb(value);
        OrderHistoryTable.getOrderHistoryList(
          isCloseSession: true,
          sessionId: sessionId,
          isReturnOrder: true,
        ).then((value2) async {
          if (value.isEmpty && value2.isEmpty) {
            CommonUtils.showSnackBar(
                context: context,
                message: 'There is no record to sync order history.');
          }
          for (var mapArg in value2) {
            print(jsonEncode(mapArg));
          }
          await _uploadSyncOrderHistoryToOfflineDb(value2);
          _isSyncOH.value = false;
          _controller?.stop();
        });
      });
    } catch (e) {
      _isSyncOH.value = false;
      _controller?.stop();
    }
  }

  Future<void> _uploadSyncOrderHistoryToOfflineDb(
      List<Map<String, dynamic>> value) async {
    final Database db = await DatabaseHelper().db;
    for (var mapArg in value) {
      print(jsonEncode(mapArg));
      await Api.syncOrders(
        orderMap: mapArg,
      ).then((syncedResult) async {
        if (syncedResult != null &&
            syncedResult.statusCode == 200 &&
            syncedResult.data != null) {
          OrderHistoryTable.updateValue(
            db: db,
            whereColumnName: RECEIPT_NUMBER,
            whereValue: mapArg[RECEIPT_NUMBER],
            columnName: ORDER_CONDITION,
            value: OrderCondition.sync.text,
          );
          for (var lineMap in syncedResult.data['orderLines'] ?? []) {
            await OrderLineIdTable.updateValue(
              db: db,
              whereColumnName: ORDER_LINE_ID,
              whereValue: lineMap[ORDER_LINE_ID],
              columnName: ODOO_ORDER_LINE_ID,
              value: lineMap['id'],
            );
            await OrderLineIdTable.updateValue(
              db: db,
              whereColumnName: REFERENCE_ORDER_LINE_ID,
              whereValue: lineMap[ORDER_LINE_ID],
              columnName: REFUNDED_ORDER_LINE_ID,
              value: lineMap['id'],
            );
          }
        } else if (syncedResult == null || syncedResult.statusCode != 200) {
          CommonUtils.showSnackBar(
              context: context,
              message: syncedResult!.statusMessage ?? 'Something was wrong!');
        }
      });
      if (mounted) {
        CommonUtils.showSnackBar(
            context: context, message: 'Order synced successful!');
      }
    }
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
      // spacer,
      // TooltipWidget(
      //   message: 'Customer\'s Screen',
      //   child: CommonUtils.svgIconActionButton(
      //     'assets/svg/credit_card.svg',
      //   ),
      // ),
      spacer,
      TooltipWidget(
        message: 'Lock / Unlock',
        child: CommonUtils.svgIconActionButton('assets/svg/lock_open_right.svg',
            onPressed: () {
          _logOut();
        }),
      ),
      spacer,
      TooltipWidget(
        message: 'Wifi',
        child: Consumer<ViewController>(builder: (_, controller, __) {
          return CommonUtils.iconActionButton(
            controller.connectedWifi ? Icons.wifi : Icons.signal_wifi_0_bar,
            size: 30,
          );
        }),
      ),
      spacer,
      TooltipWidget(
        message: 'Sync Order History',
        child: ValueListenableBuilder<bool>(
            valueListenable: _isSyncOH,
            builder: (_, isSyncOH, __) {
              return _controller != null
                  ? RotationTransition(
                      turns: _controller!,
                      child: CommonUtils.svgIconActionButton(
                          'assets/svg/sync.svg',
                          width: 30,
                          height: 30, onPressed: () {
                        _syncOrderHistory();
                      }),
                    )
                  : CommonUtils.svgIconActionButton('assets/svg/sync.svg',
                      width: 30, height: 30, onPressed: () {
                      _syncOrderHistory();
                    });
            }),
      ),
      spacer,
      _closeSessionWidget(context, false),
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
          controller:
              context.read<ViewController>().searchProductTextController,
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
            context.read<ViewController>().barcodePackageConflict = false;
            ItemListController itemListController =
                context.read<ItemListController>();
            itemListController.filterValue = value;
            itemListController.offset = 0;
            itemListController.currentIndex = 1;
            print(
                'Product Sync Date : ${context.read<ThemeSettingController>().appConfig?.productLastSyncDate}');

            List<int>? ids = NavigationService.navigatorKey.currentContext!
                .read<LoginUserController>()
                .posConfig
                ?.posCategoryIds;
            itemListController.getAllProduct(context,
                sessionId:
                    context.read<LoginUserController>().posSession?.id ?? 0,
                productLastSyncDate: context
                    .read<ThemeSettingController>()
                    .appConfig
                    ?.productLastSyncDate,
                categoryListFilter: ids?.join(","));
          },
        ),
      ),
    );
  }

  void _clearSearch() {
    context.read<ViewController>().searchProductTextController?.clear();
    ItemListController itemListController = context.read<ItemListController>();
    _showSearchBox.value = false;
    itemListController.filterValue = null;
    itemListController.offset = 0;
    itemListController.currentIndex = 1;
    List<int>? ids = NavigationService.navigatorKey.currentContext!
        .read<LoginUserController>()
        .posConfig
        ?.posCategoryIds;
    itemListController.getAllProduct(
      context,
      sessionId: context.read<LoginUserController>().posSession?.id ?? 0,
      productLastSyncDate:
          context.read<ThemeSettingController>().appConfig?.productLastSyncDate,
      categoryListFilter: ids?.join(","),
    );
  }
}
