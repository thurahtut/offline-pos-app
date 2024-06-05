import 'package:offline_pos/components/export_files.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String routeName = "/welcome_screen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ThemeSettingController themeSettingController =
          context.read<ThemeSettingController>();
      MorningsyncController morningsyncController =
          context.read<MorningsyncController>();
      await themeSettingController.getThemeConfig();
      if (themeSettingController.appConfig?.storageStartDate == null) {
        int dateArg = CommonUtils.getDateTimeNow().millisecondsSinceEpoch;
        themeSettingController.appConfig?.storageStartDate = dateArg;
        AppConfigTable.insertOrUpdate(STORAGE_START_DATE, dateArg.toString());
      } else {
        int storageStartDate =
            themeSettingController.appConfig?.storageStartDate ?? 0;
        Duration diff = CommonUtils.getDateTimeNow()
            .difference(DateTime.fromMillisecondsSinceEpoch(storageStartDate));
        int daysDifference = diff.inSeconds; //diff.inDays;
        if (daysDifference > 31) {
          bool isExistUnSyncedOrders =
              await OrderHistoryTable.isExistUnSyncedOrders();
          if (isExistUnSyncedOrders) {
            _dialogForDatabaseRemove(
              text:
                  'Your data is saved for one month. To delete these, sync the entire order and close session.',
            );
          } else if (mounted) {
            int? configId = context.read<LoginUserController>().posConfig?.id;
            Api.getPosSessionByID(configId: configId).then((sessionResponse) {
              if (sessionResponse != null &&
                  sessionResponse.statusCode != 200 &&
                  sessionResponse.data['error']
                      ?.contains("no opened session")) {
                _dialogForDatabaseRemove(
                  text:
                      'Your data is saved for one month. Your database will now be reset.',
                  callback: () {
                    DatabaseHelper()
                        .backupDatabase(context, toDelete: true)
                        .then((value) {
                      if (value == 1) {
                        _dialogForDatabaseRemove(
                            text: 'Reset database is successful!');
                        AppConfigTable.insertOrUpdate(
                            STORAGE_START_DATE,
                            CommonUtils.getDateTimeNow()
                                .millisecondsSinceEpoch
                                .toString());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserLoginScreen()),
                          ModalRoute.withName("/Home"),
                        );
                      } else {
                        _dialogForDatabaseRemove(
                            text: 'Reset database is not successful!');
                        morningsyncController.doneActionList
                            .remove(DataSync.reset.name);
                        morningsyncController.notify();
                      }
                    });
                  },
                );
              } else {
                _dialogForDatabaseRemove(
                  text:
                      'Your data is saved for one month. To delete these, sync the entire order and close session.',
                );
              }
            });
          }
        }
      }
    });
    super.initState();
  }

  Future<Object?> _dialogForDatabaseRemove(
      {required String text, Function()? callback}) {
    return CommonUtils.showGeneralDialogWidget(
        NavigationService.navigatorKey.currentContext!,
        (context, animation, secondaryAnimation) => AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width > 300
                    ? 300
                    : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 50,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 10),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                BorderContainer(
                  text: 'Ok',
                  containerColor: primaryColor,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).pop();
                    callback?.call();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeSettingController>(builder: (_, controller, __) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        body: _bodyWidget(context),
      );
    });
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      color: primaryColor,
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buttonContainer(
            context,
            'Sale (POS)',
            () {
              Navigator.pushNamed(context, SessionLoginScreen.routeName);
            },
            svg: "assets/svg/sell.svg",
          ),
          SizedBox(width: 8),
          _buttonContainer(
            context,
            'Inventory',
            () {
              Navigator.pushNamed(context, ProductListScreen.routeName);
            },
            svg: "assets/svg/inventory_2.svg",
          ),
          // SizedBox(width: 8),
          // _buttonContainer(
          //   context,
          //   'Finance',
          //   () {},
          //   svg: "assets/svg/account_balance.svg",
          // ),
          SizedBox(width: 8),
          _buttonContainer(
            context,
            'Settings',
            () {
              Navigator.pushNamed(context, ThemeSettingScreen.routeName);
            },
            svg: "assets/svg/settings.svg",
          ),
          SizedBox(width: 8),
          _buttonContainer(context, 'Sync', () {
            Navigator.pushNamed(context, ManualSyncScreen.routeName);
          }, icon: Icons.replay_rounded),
          // SizedBox(width: 8),
          // _buttonContainer(context, 'Deleted Logs', () {
          //   Navigator.pushNamed(context, DeletedLogsTypeScreen.routeName);
          // }, icon: Icons.delete_sweep),
        ],
      ),
    );
  }

  Widget _buttonContainer(
    BuildContext context,
    String text,
    Function() onPressed, {
    String? svg,
    IconData? icon,
  }) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          if (svg != null)
            CommonUtils.svgIconActionButton(
              svg,
              width:
                  MediaQuery.of(context).size.width / (isTabletMode ? 12 : 30),
              height:
                  MediaQuery.of(context).size.width / (isTabletMode ? 12 : 30),
              withContianer: true,
              radius: 12,
              padding:
                  MediaQuery.of(context).size.width / (isTabletMode ? 16 : 30),
              iconColor: primaryColor,
              containerColor: Colors.white,
            ),
          if (icon != null)
            CommonUtils.iconActionButton(
              icon,
              size:
                  MediaQuery.of(context).size.width / (isTabletMode ? 12 : 30),
              withContianer: true,
              radius: 12,
              padding:
                  MediaQuery.of(context).size.width / (isTabletMode ? 16 : 30),
              iconColor: primaryColor,
              containerColor: Colors.white,
            ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
