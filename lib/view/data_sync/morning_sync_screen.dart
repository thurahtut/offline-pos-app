import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/pos_category_table.dart';

class MorningSyncScreen extends StatefulWidget {
  const MorningSyncScreen({super.key, required this.alreadyLogin});
  static const String routeName = "/morning_sync_screen";
  final bool? alreadyLogin;

  @override
  State<MorningSyncScreen> createState() => _MorningSyncScreenState();
}

class _MorningSyncScreenState extends State<MorningSyncScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.alreadyLogin == true) {
        _alreadyLogin();
      } else {
        _morningSync();
      }
    });
    super.initState();
  }

  void _alreadyLogin() {
    LoginUserController controller = context.read<LoginUserController>();
    LoginUserTable.getLoginUser().then((loginUser) {
      if (loginUser == null) {
        _alreadyLoginError();
        return;
      }
      context.read<LoginUserController>().loginUser = loginUser;
      POSConfigTable.getAppConfig().then((posConfig) {
        if (posConfig == null) {
          _alreadyLoginError();
          return;
        }
        controller.posConfig = posConfig;
        Api.getPosSessionByID(configId: posConfig.id ?? 0)
            .then((sessionResponse) {
          if (sessionResponse != null &&
              sessionResponse.statusCode == 200 &&
              sessionResponse.data != null &&
              sessionResponse.data is List &&
              (sessionResponse.data as List).isNotEmpty) {
            controller.posSession =
                POSSession.fromJson((sessionResponse.data as List).first);
            if (controller.posSession is! POSSession) {
              CommonUtils.showSnackBar(message: 'Something was wrong!');

              Navigator.pop(context, false);
              return;
            }
            POSSessionTable.insertOrUpdatePOSSession(controller.posSession!);
            POSCategoryTable.getAllPosCategory().then((posCategorys) {
              if (posCategorys.isEmpty) {
                _alreadyLoginError();
                return;
              }
              context.read<PosCategoryController>().posCategoryList = [
                PosCategory(id: -1, name: "All")
              ];
              context
                  .read<PosCategoryController>()
                  .posCategoryList
                  .addAll(posCategorys);
              context
                  .read<MorningsyncController>()
                  .getAllAmountTax(// amount tax
                      () {
                context.read<PosCategoryController>().notify();
                Navigator.pushReplacementNamed(
                    context, WelcomeScreen.routeName);
              });
            });
          } else {
            _alreadyLoginError();
          }
        });
      });
    });
  }

  void _alreadyLoginError() {
    CommonUtils.showAlertDialogWithOkButton(
      context,
      title: "Please login again",
      content: "Your previous login data is something wrong!.",
      callback: () {
        DatabaseHelper.userLogOut().then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserLoginScreen()),
            ModalRoute.withName("/Home"),
          ),
        );
      },
    );
  }

  void _morningSync() {
    context.read<MorningsyncController>().resetMorningsyncController();
    context.read<MorningsyncController>().getAllProductFromApi(
      //product
      context.read<ThemeSettingController>().appConfig?.productLastSyncDate,
      context.read<LoginUserController>().posConfig?.shPosLocation,
      () {
        if (context.read<ThemeSettingController>().appConfig == null) {
          context.read<ThemeSettingController>().appConfig = AppConfig();
        }
        context.read<ThemeSettingController>().appConfig?.productLastSyncDate =
            CommonUtils.getDateTimeNow().toString();
        AppConfigTable.insertOrUpdate(
            PRODUCT_LAST_SYNC_DATE,
            context
                .read<ThemeSettingController>()
                .appConfig
                ?.productLastSyncDate);
        context.read<MorningsyncController>().getAllCustomerFromApi(
            context
                .read<ThemeSettingController>()
                .appConfig
                ?.customerLastSyncDate, () {
          //customer

          context
              .read<ThemeSettingController>()
              .appConfig
              ?.customerLastSyncDate = CommonUtils.getDateTimeNow().toString();
          AppConfigTable.insertOrUpdate(
              CUSTOMER_LAST_SYNC_DATE,
              context
                  .read<ThemeSettingController>()
                  .appConfig
                  ?.customerLastSyncDate);
          context.read<MorningsyncController>().getAllPriceListItemFromApi(
              //price
              context
                  .read<ThemeSettingController>()
                  .appConfig
                  ?.priceLastSyncDate,
              context.read<LoginUserController>().posConfig?.pricelistId ?? 0,
              () {
            context
                .read<ThemeSettingController>()
                .appConfig
                ?.priceLastSyncDate = CommonUtils.getDateTimeNow().toString();
            AppConfigTable.insertOrUpdate(
                PRICE_LAST_SYNC_DATE,
                context
                    .read<ThemeSettingController>()
                    .appConfig
                    ?.priceLastSyncDate);
            List<int>? ids =
                context.read<LoginUserController>().posConfig?.paymentMethodIds;
            context
                .read<MorningsyncController>()
                .getAllPaymentMethodListItemFromApi(ids?.join(",") ?? "", () {
              //paymentmethod
              context.read<MorningsyncController>().getAllPosCategory(() {
                //category
                POSCategoryTable.getAllPosCategory().then((posCategorys) {
                  context.read<PosCategoryController>().posCategoryList = [
                    PosCategory(id: -1, name: "All")
                  ];
                  context
                      .read<PosCategoryController>()
                      .posCategoryList
                      .addAll(posCategorys);
                  context.read<PosCategoryController>().notify();
                });
                context
                    .read<MorningsyncController>()
                    .getAllAmountTax(// amount tax
                        () {
                  context.read<MorningsyncController>().currentTaskTitle = "";
                  Navigator.pushReplacementNamed(
                      context, WelcomeScreen.routeName);
                });
              });
            });
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    return Scaffold(
      backgroundColor:
          widget.alreadyLogin == true ? primaryColor : Colors.white,
      body: widget.alreadyLogin == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You're already logged in and is attempting to re-log in using your previous data.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: LinearProgressIndicator(
                      minHeight: 30,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                ],
              ),
            )
          : Consumer<MorningsyncController>(
              builder: (_, controller, __) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width /
                        (isMobileMode
                            ? 1
                            : isTabletMode
                                ? 1.5
                                : 2.5),
                    height: MediaQuery.of(context).size.height / 4,
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 15),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(text: "", children: [
                                    TextSpan(
                                      text: controller.currentReachTask
                                          .toString(),
                                      style: TextStyle(
                                          color: Constants.textColor
                                              .withOpacity(0.7),
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: "/",
                                      style: TextStyle(
                                        color: Constants.textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.allTask.toString(),
                                      style: TextStyle(
                                        color: Constants.textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              controller.currentTaskTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        GFProgressBar(
                          percentage: (controller.percentage ?? 0) / 100,
                          lineHeight: 25,
                          backgroundColor: Colors.black12,
                          progressBarColor: Constants.greyColor,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "${controller.percentage?.toStringAsFixed(2) ?? 0}%",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
