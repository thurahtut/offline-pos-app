import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/controller/morning_sync_controller.dart';

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
      getAllProductFromApi(() {
        getAllCustomerFromApi(() {
          context.read<MorningsyncController>().currentTaskTitle = "";
          Navigator.pop(context);
          Navigator.pushNamed(context, MainScreen.routeName);
        });
      });
    });
    super.initState();
  }

  void getAllProductFromApi(Function() callback) {
    context.read<MorningsyncController>().currentTaskTitle =
        "Product List Sync....";
    Api.getAllProduct(
      onSendProgress: (sent, total) {
        double value = double.parse((sent / total).toStringAsFixed(2)) * 100;
        context.read<MorningsyncController>().percentage =
            value == 100 ? null : value;
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          ProductTable.insertOrUpdate(response.data)
              .then((value) => callback());
        }
      }
    });
  }

  void getAllCustomerFromApi(Function() callback) {
    context.read<MorningsyncController>().currentTaskTitle =
        "Customer List Sync....";
    Api.getAllCustomer(
      onSendProgress: (sent, total) {
        double value = double.parse((sent / total).toStringAsFixed(2)) * 100;
        context.read<MorningsyncController>().percentage =
            value == 100 ? null : value;
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          CustomerTable.insertOrUpdate(response.data)
              .then((value) => callback());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    return Scaffold(
      body: Consumer<MorningsyncController>(builder: (_, controller, __) {
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
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Constants.primaryColor.withOpacity(0.3),
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
                              text: context
                                  .read<MorningsyncController>()
                                  .currentReachTask
                                  .toString(),
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
                              text: context
                                  .read<MorningsyncController>()
                                  .allTask
                                  .toString(),
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
                      // controller.currentTaskTitle ??
                      'Product List Sync',
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
                  percentage: controller.percentage ?? 0 / 100,
                  lineHeight: 25,
                  backgroundColor: Colors.black12,
                  progressBarColor: Constants.greyColor,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "${controller.percentage ?? 0}%",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
