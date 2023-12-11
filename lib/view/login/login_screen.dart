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
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width / 3,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    BarcodeWidget(
                      data: 'Offline_POS',
                      drawText: false,
                      barcode: Barcode.code128(),
                      width: MediaQuery.of(context).size.width / 8,
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
                    Navigator.pushNamed(context, MainScreen.routeName);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
