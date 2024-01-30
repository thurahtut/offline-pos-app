import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/login/session_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String routeName = "/welcome_screen";
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
