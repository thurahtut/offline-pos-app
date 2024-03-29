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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThemeSettingController>().getThemeConfig();
    });
    super.initState();
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
