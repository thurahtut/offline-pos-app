import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({
    super.key,
    required this.mainContext,
    required this.bContext,
  });
  static const String routeName = "/create_session_screen";
  final BuildContext mainContext;
  final BuildContext bContext;

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  @override
  Widget build(BuildContext ccontext) {
    return _bodyWidget();
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<ThemeSettingController>(builder: (_, controller, __) {
          return BorderContainer(
            text: 'Open Session',
            textColor: Colors.white,
            containerColor: primaryColor,
            onTap: () {
              String date = DateTime.now().toUtc().toString();
              LoginUserController userController =
                  widget.mainContext.read<LoginUserController>();
              int userId = userController.loginUser?.userData?.id ?? 0;
              CreateSession createSession = CreateSession(
                  posSession: PosSession(
                    configId: userController.posConfig?.id ?? 0,
                    createDate: date,
                    createUid: userId,
                    finishedCogs: false,
                    loginNumber: 0,
                    running: false,
                    sequenceNumber: 1,
                    state: "opened",
                    startAt: date,
                    toRunCogs: false,
                    updateStockAtClosing: true,
                    userId: userId,
                  ),
                  mailMessage: MailMessage(
                    addSign: true,
                    authorId: userController.loginUser?.partnerData?.id ?? 0,
                    body: "Point of Sale Session created",
                    createDate: date,
                    createUid: userId,
                    date: date,
                    emailFrom:
                        userController.loginEmployee?.workEmail ??
                        userController.loginEmployee?.name ??
                            '',
                    isInternal: true,
                    messageType: "notification",
                    model: "pos.session",
                    replyTo: userController.loginEmployee?.name ?? '',
                  ));
              Api.createSession(createSession: createSession).then((response) {
                if (response != null && response.statusCode == 200) {
                  Api.getPosSessionByID(configId: userController.posConfig?.id)
                      .then((sessionResponse) async {
                    if (sessionResponse != null &&
                        sessionResponse.statusCode == 200 &&
                        sessionResponse.data != null &&
                        sessionResponse.data is List &&
                        (sessionResponse.data as List).isNotEmpty) {
                      userController.posSession = POSSession.fromJson(
                          (sessionResponse.data as List).first);
                      Navigator.pop(widget.bContext, true);
                      final Database db = await DatabaseHelper().db;
                      POSSessionTable.insertOrUpdatePOSSessionWithDB(
                          db, userController.posSession!);
                    } else {
                      Navigator.pop(widget.bContext, false);
                    }
                  });
                } else {
                  Navigator.pop(widget.bContext, false);
                }
              });
            },
          );
        }),
      ],
    );
  }
}
