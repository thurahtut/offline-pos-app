import 'package:offline_pos/view/user/user_login_dialog.dart';

import '/components/export_files.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String routeName = "/login_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: bodyWidget(context),
    );
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
        text: 'Select Cashier',
        onTap: () {
          return UserLoginDialog.loginUserDialogWidget(
            context,
          ).then((value) {
            if (value == true) {
              Navigator.pushNamed(context, MainScreen.routeName);
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
