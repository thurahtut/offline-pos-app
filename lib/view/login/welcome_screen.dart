import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/theme/theme_setting_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String routeName = "/welcome_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      color: Constants.primaryColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buttonContainer(
                  context,
                  'Sale (POS)',
                  () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
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
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buttonContainer(
                  context,
                  'Finance',
                  () {},
                  svg: "assets/svg/account_balance.svg",
                ),
                SizedBox(width: 8),
                _buttonContainer(
                  context,
                  'Settings',
                  () {
                    Navigator.pushNamed(context, ThemeSettingScreen.routeName);
                  },
                  svg: "assets/svg/settings.svg",
                ),
              ],
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     _buttonContainer(
            //       context,
            //       'Employee',
            //       () {
            //         Navigator.pushNamed(context, EmployeeListScreen.routeName);
            //       },
            //       icon: Icons.people_alt_outlined,
            //     ),
            //     SizedBox(width: 8),
            //     SizedBox(width: 8),
            //   ],
            // ),
          ]),
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
            width: MediaQuery.of(context).size.width / (isTabletMode ? 12 : 30),
            height:
                MediaQuery.of(context).size.width / (isTabletMode ? 12 : 30),
            withContianer: true,
            radius: 12,
            padding:
                MediaQuery.of(context).size.width / (isTabletMode ? 16 : 30),
            iconColor: Constants.primaryColor,
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
              iconColor: Constants.primaryColor,
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
