import 'package:offline_pos/view/data_sync/morning_sync_screen.dart';
import 'package:offline_pos/view/inventory/choose_inventory_dialog.dart';
import 'package:offline_pos/view/session/create_session_dialog.dart';
import 'package:offline_pos/view/user/user_login_dialog.dart';

import '/components/export_files.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.white,
          //     size: 30,
          //   ),
          // ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ThemeSettingScreen.routeName);
                },
                icon: Icon(
                  Icons.settings,
                  size: 45,
                  color: Colors.white,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 8.0)],
                )),
          ],
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
          return UserLoginDialog.loginUserDialogWidget(
            context,
          ).then((value) {
            if (value == true) {
              return ChooseInventoryDialog.chooseInventoryDialogWidget(
                context,
              ).then((value) {
                if (value == true) {
                  AppConfigTable.deleteByColumnName(PRODUCT_LAST_SYNC_DATE);
                  context
                      .read<ThemeSettingController>()
                      .appConfig
                      ?.productLastSyncDate = null;
                  context.read<ThemeSettingController>().notify();

                  Navigator.pushNamed(context, MorningSyncScreen.routeName);
                } else if (context.read<LoginUserController>().posSession?.id ==
                        null ||
                    context.read<LoginUserController>().posSession?.id == 0) {
                  return CreateSessionDialog.createSessionDialogWidget(context)
                      .then((value) {
                    if (value == true) {
                      AppConfigTable.deleteByColumnName(PRODUCT_LAST_SYNC_DATE);
                      context
                          .read<ThemeSettingController>()
                          .appConfig
                          ?.productLastSyncDate = null;
                      context.read<ThemeSettingController>().notify();

                      Navigator.pushNamed(context, MorningSyncScreen.routeName);
                    }
                  });
                }
              });
            }
          });
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
              'Login to Easy-3 POS',
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
