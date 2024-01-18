import 'package:offline_pos/components/export_files.dart';

class MorningSyncScreen extends StatefulWidget {
  const MorningSyncScreen({super.key});
  static const String routeName = "/morning_sync_screen";

  @override
  State<MorningSyncScreen> createState() => _MorningSyncScreenState();
}

class _MorningSyncScreenState extends State<MorningSyncScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MorningsyncController>().resetMorningsyncController();
      context.read<MorningsyncController>().getAllProductFromApi(
        context.read<ThemeSettingController>().appConfig?.productLastSyncDate,
        context.read<LoginUserController>().posConfig?.shPosLocation,
        () {
          context
              .read<ThemeSettingController>()
              .appConfig
              ?.productLastSyncDate = DateTime.now().toUtc().toString();
          AppConfigTable.insertOrUpdate(
              PRODUCT_LAST_SYNC_DATE, DateTime.now().toString());
          context.read<MorningsyncController>().getAllCustomerFromApi(() {
            context.read<MorningsyncController>().getAllPriceListItemFromApi(
                context.read<LoginUserController>().posConfig?.pricelistId ?? 0,
                () {
              List<int>? ids = context
                  .read<LoginUserController>()
                  .posConfig
                  ?.paymentMethodIds;
              context
                  .read<MorningsyncController>()
                  .getAllPaymentMethodListItemFromApi(ids?.join(",") ?? "", () {
                context.read<MorningsyncController>().currentTaskTitle = "";
              Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
              });
            });
          });
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    return Scaffold(
      body: Consumer<MorningsyncController>(
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
                                text: controller.currentReachTask.toString(),
                                style: TextStyle(
                                    color: Constants.textColor.withOpacity(0.7),
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
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
