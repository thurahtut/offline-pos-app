import '/components/export_files.dart';

class SessionLoginScreen extends StatefulWidget {
  const SessionLoginScreen({super.key});
  static const String routeName = "/session_login_screen";

  @override
  State<SessionLoginScreen> createState() => _SessionLoginScreenState();
}

class _SessionLoginScreenState extends State<SessionLoginScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThemeSettingController>().getThemeConfig();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeSettingController>(builder: (_, controller, __) {
      return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
        body: bodyWidget(context),
      );
    });
  }

  Widget bodyWidget(BuildContext context) {
    var children2 = [
      Column(
        children: [
          BarcodeWidget(
            data: 'Offline_POS',
            drawText: false,
            barcode: Barcode.code128(),
            width: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.width < 700 ? 4 : 8),
            height: MediaQuery.of(context).size.height / 10,
          ),
          SizedBox(height: 8),
          Text(
            'Scan Your Badge',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Text('Or'),
      BorderContainer(
        text: 'Login',
        onTap: () {
          return ChooseCashierDialog.chooseCashierDialogWidget(context)
              .then((value) {
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

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    ModalRoute.withName("/Home"),
                  );
                } else {
                  return CreateSessionDialog.createSessionDialogWidget(
                          context, true)
                      .then((value) {
                    if (value == true) {
                      context.read<ThemeSettingController>().notify();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                        ModalRoute.withName("/Home"),
                      );
                    }
                  });
                }
              });
            }
          });

          // return SessionLoginDialog.sessionLoginDialogWidget(
          //   context,
          // ).then((value) {
          //   if (value == true) {
          //     LoginUserController controller =
          //         context.read<LoginUserController>();
          //     int? configId = controller.posConfig?.id;
          //     Api.getPosSessionByID(configId: configId).then((sessionResponse) {
          //       if (sessionResponse != null &&
          //           sessionResponse.statusCode == 200 &&
          //           sessionResponse.data != null &&
          //           sessionResponse.data is List &&
          //           (sessionResponse.data as List).isNotEmpty) {
          //         controller.posSession =
          //             POSSession.fromJson((sessionResponse.data as List).first);
          //         POSSessionTable.insertOrUpdatePOSSession(
          //             controller.posSession!);

          //         Navigator.pushNamed(
          //           context,
          //           MorningSyncScreen.routeName,
          //           arguments: MorningSyncScreen(alreadyLogin: false),
          //         );
          //       } else {
          //         return CreateSessionDialog.createSessionDialogWidget(context)
          //             .then((value) {
          //           if (value == true) {
          //             context.read<ThemeSettingController>().notify();

          //             Navigator.pushNamed(
          //               context,
          //               MorningSyncScreen.routeName,
          //               arguments: MorningSyncScreen(alreadyLogin: false),
          //             );
          //           }
          //         });
          //       }
          //     });
          //   }
          // });
        },
      ),
    ];
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.width < 840 ? 1.5 : 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login to ${context.read<LoginUserController>().posConfig?.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            MediaQuery.of(context).size.width < 600
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: children2
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: e,
                            ))
                        .toList(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: children2,
                  ),
          ],
        ),
      ),
    );
  }
}
