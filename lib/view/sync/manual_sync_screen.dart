import 'package:offline_pos/components/export_files.dart';

class ManualSyncScreen extends StatefulWidget {
  const ManualSyncScreen({super.key});
  static const String routeName = "/manual_sync_screen";

  @override
  State<ManualSyncScreen> createState() => _ManualSyncScreenState();
}

class _ManualSyncScreenState extends State<ManualSyncScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MorningsyncController>().resetMorningsyncController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        backgroundColor: primaryColor,
        leading: BackButton(
          color: Colors.white,
          style: ButtonStyle(
              iconSize: MaterialStateProperty.resolveWith((states) => 30)),
        ),
        centerTitle: true,
        title: Text(
          'Sync Data',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    bool isMobileMode = CommonUtils.isMobileMode(context);
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width /
            (isMobileMode
                ? 1
                : isTabletMode
                    ? 2.5
                    : 3),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer<MorningsyncController>(builder: (_, controller, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _productSyncWidget(controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.3,
                ),
              ),
              _priceSyncWidget(controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.3,
                ),
              ),
              _customerSyncWidget(controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.3,
                ),
              ),
              _paymentMethodSyncWidget(controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.3,
                ),
              ),
              _categorySyncWidget(controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.3,
                ),
              ),
              _backUpWidget(controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.3,
                ),
              ),
              _resetWidget(controller)
            ],
          );
        }),
      ),
    );
  }

  Widget _productSyncWidget(MorningsyncController controller) {
    return _syncWidget(
      'Product Sync',
      controller.doneActionList.contains(DataSync.product.name),
      percentage: controller.processingPercentage[DataSync.product.name],
      onSync: () {
        context.read<MorningsyncController>().getAllProductFromApi(
          context.read<ThemeSettingController>().appConfig?.productLastSyncDate,
          context.read<LoginUserController>().posConfig?.shPosLocation,
          () {
            controller.doneActionList.add(DataSync.product.name);
            controller.notify();
            if (context.read<ThemeSettingController>().appConfig == null) {
              context.read<ThemeSettingController>().appConfig = AppConfig();
            }
            context
                .read<ThemeSettingController>()
                .appConfig
                ?.productLastSyncDate = DateTime.now().toUtc().toString();
            AppConfigTable.insertOrUpdate(
                PRODUCT_LAST_SYNC_DATE, DateTime.now().toString());
          },
        );
      },
    );
  }

  Widget _priceSyncWidget(MorningsyncController controller) {
    return _syncWidget(
      'Price List Sync',
      controller.doneActionList.contains(DataSync.price.name),
      percentage: controller.processingPercentage[DataSync.price.name],
      onSync: () {
        context.read<MorningsyncController>().getAllPriceListItemFromApi(
          context.read<ThemeSettingController>().appConfig?.priceLastSyncDate,
          context.read<LoginUserController>().posConfig?.pricelistId ?? 0,
          () {
            controller.doneActionList.add(DataSync.price.name);
            controller.notify();
          },
        );
      },
    );
  }

  Widget _customerSyncWidget(MorningsyncController controller) {
    return _syncWidget(
      'Customer List Sync',
      controller.doneActionList.contains(DataSync.customer.name),
      percentage: controller.processingPercentage[DataSync.customer.name],
      onSync: () {
        context.read<MorningsyncController>().getAllCustomerFromApi(
          context
              .read<ThemeSettingController>()
              .appConfig
              ?.customerLastSyncDate,
          () {
            controller.doneActionList.add(DataSync.customer.name);
            controller.notify();
          },
        );
      },
    );
  }

  Widget _paymentMethodSyncWidget(MorningsyncController controller) {
    return _syncWidget(
      'Payment Method List Sync',
      controller.doneActionList.contains(DataSync.paymentMethod.name),
      percentage: controller.processingPercentage[DataSync.paymentMethod.name],
      onSync: () {
        context
            .read<MorningsyncController>()
            .getAllPaymentMethodListItemFromApi(
          context
                  .read<LoginUserController>()
                  .posConfig
                  ?.paymentMethodIds
                  ?.join(",") ??
              "",
          () {
            controller.doneActionList.add(DataSync.paymentMethod.name);
            controller.notify();
          },
        );
      },
    );
  }

  Widget _categorySyncWidget(MorningsyncController controller) {
    return _syncWidget(
      'Category List Sync',
      controller.doneActionList.contains(DataSync.posCategory.name),
      percentage: controller.processingPercentage[DataSync.posCategory.name],
      onSync: () {
        context.read<MorningsyncController>().getAllPosCategory(
          () {
            controller.doneActionList.add(DataSync.posCategory.name);
            controller.notify();
          },
        );
      },
    );
  }

  Widget _syncWidget(String text, bool isDone,
      {Function()? onSync, double? percentage}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 70,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Expanded(child: SizedBox()),
          !isDone && (percentage ?? 0) > 0 && (percentage ?? 0) <= 100
              ? InkWell(
                  onTap: onSync,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 60,
                      maxWidth: 60,
                    ),
                    child: Center(
                      child: GFProgressBar(
                        key: Key(text),
                        percentage: (percentage ?? 0) / 100,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        type: GFProgressType.circular,
                        circleWidth: 3,
                        radius: 25,
                        backgroundColor: Colors.black12,
                        progressBarColor: Colors.blue,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: isDone ? null : onSync,
                  icon: Icon(
                    isDone ? Icons.check_rounded : Icons.replay_rounded,
                    size: isDone ? 40 : 34,
                    color:
                        isDone ? primaryColor : Colors.black.withOpacity(0.62),
                  )),
        ],
      ),
    );
  }

  Widget _backUpWidget(MorningsyncController controller) {
    onSync() {
      DatabaseHelper().backupDatabase(context).then((value) {
        if (value == 1) {
          controller.doneActionList.add(DataSync.databaseBackup.name);
          controller.notify();
        } else {
          CommonUtils.showSnackBar(
              context: context, message: "Backup database is not successful!");
          controller.doneActionList.remove(DataSync.databaseBackup.name);
          controller.notify();
        }
      });
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 70,
      child: Row(
        children: [
          Text(
            'Database Backup',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Expanded(child: SizedBox()),
          !controller.doneActionList.contains(DataSync.databaseBackup.name) &&
                  (controller.processingPercentage[
                              DataSync.databaseBackup.name] ??
                          0) >
                      0 &&
                  (controller.processingPercentage[
                              DataSync.databaseBackup.name] ??
                          0) <=
                      100
              ? CircularProgressIndicator(color: primaryColor)
              : IconButton(
                  onPressed: controller.doneActionList
                          .contains(DataSync.databaseBackup.name)
                      ? null
                      : onSync,
                  icon: Icon(
                    controller.doneActionList
                            .contains(DataSync.databaseBackup.name)
                        ? Icons.check_rounded
                        : Icons.download_rounded,
                    size: controller.doneActionList
                            .contains(DataSync.databaseBackup.name)
                        ? 40
                        : 34,
                    color: controller.doneActionList
                            .contains(DataSync.databaseBackup.name)
                        ? primaryColor
                        : Colors.black.withOpacity(0.62),
                  )),
        ],
      ),
    );
  }

  Widget _resetWidget(MorningsyncController controller) {
    onSync() {
      DatabaseHelper().backupDatabase(context, toDelete: true).then((value) {
        if (value == 1) {
          controller.doneActionList.add(DataSync.reset.name);
          controller.notify();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserLoginScreen()),
            ModalRoute.withName("/Home"),
          );
        } else {
          CommonUtils.showSnackBar(
              context: context, message: "Reset database is not successful!");
          controller.doneActionList.remove(DataSync.reset.name);
          controller.notify();
        }
      });
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 70,
      child: Row(
        children: [
          Text(
            'Reset Data',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Expanded(child: SizedBox()),
          !controller.doneActionList.contains(DataSync.reset.name) &&
                  (controller.processingPercentage[DataSync.reset.name] ?? 0) >
                      0 &&
                  (controller.processingPercentage[DataSync.reset.name] ?? 0) <=
                      100
              ? CircularProgressIndicator(color: primaryColor)
              : IconButton(
                  onPressed:
                      controller.doneActionList.contains(DataSync.reset.name)
                          ? null
                          : onSync,
                  icon: Icon(
                    controller.doneActionList.contains(DataSync.reset.name)
                        ? Icons.check_rounded
                        : Icons.delete_forever_outlined,
                    size:
                        controller.doneActionList.contains(DataSync.reset.name)
                            ? 40
                            : 34,
                    color:
                        controller.doneActionList.contains(DataSync.reset.name)
                            ? primaryColor
                            : Colors.black.withOpacity(0.62),
                  )),
        ],
      ),
    );
  }
}
