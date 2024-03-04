import '/components/export_files.dart';

class SessionLoginScreen extends StatefulWidget {
  const SessionLoginScreen({super.key});
  static const String routeName = "/session_login_screen";

  @override
  State<SessionLoginScreen> createState() => _SessionLoginScreenState();
}

class _SessionLoginScreenState extends State<SessionLoginScreen> {

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
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PopupMenuButton(
                tooltip: "",
                child: CommonUtils.iconActionButton(
                  Icons.more_vert_rounded,
                  iconColor: Colors.white,
                  size: 30,
                ),
                itemBuilder: (bContext) {
                  return [
                    PopupMenuItem<int>(
                      value: 4,
                      child: Text(
                        'Order',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderListScreen.routeName,
                        );
                      },
                    ),
                  ];
                },
              ),
            )
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
          CommonUtils.sessionLoginMethod(context, true);
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
