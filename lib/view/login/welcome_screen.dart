import 'package:offline_pos/components/export_files.dart';

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
      child:
          // GridView(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     mainAxisSpacing: 0,
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 1,
          //     childAspectRatio: 2.9,
          //   ),
          //   children: [
          //     _buttonContainer(context, 'Sale (POS)', "assets/svg/sell.svg"),
          //     _buttonContainer(
          //         context, 'Inventory', "assets/svg/inventory_2.svg"),
          //     _buttonContainer(
          //         context, 'Finance', "assets/svg/account_balance.svg"),
          //     _buttonContainer(context, 'Inventory', "assets/svg/settings.svg"),
          //   ],
          // )

          Column(
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
                  "assets/svg/sell.svg",
                  () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
                SizedBox(width: 8),
                _buttonContainer(
                  context,
                  'Inventory',
                  "assets/svg/inventory_2.svg",
                  () {
                    Navigator.pushNamed(context, InventoryListScreen.routeName);
                  },
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
                  "assets/svg/account_balance.svg",
                  () {},
                ),
                SizedBox(width: 8),
                _buttonContainer(
                  context,
                  'Settings',
                  "assets/svg/settings.svg",
                  () {},
                ),
              ],
            ),
          ]),
    );
  }

  Widget _buttonContainer(
      BuildContext context, String text, String svg, Function() onPressed) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
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
