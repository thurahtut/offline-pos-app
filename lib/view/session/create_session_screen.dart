import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/cash_register.dart';
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
  final TextEditingController amountTextController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      amountTextController.text = context
              .read<LoginUserController>()
              .posConfig
              ?.startingAmt
              ?.toString() ??
          '';
    });
    super.initState();
  }

  @override
  void dispose() {
    amountTextController.dispose();
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ccontext) {
    return _bodyWidget();
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              'Opening Cash',
              style: TextStyle(
                color: Constants.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                enabled: false,
                controller: amountTextController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                decoration: InputDecoration(
                  hintText:
                      "${CommonUtils.priceFormat.format(context.read<LoginUserController>().posConfig?.startingAmt ?? 0)} Ks",
                  hintStyle: TextStyle(
                    color: Constants.disableColor.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), border: Border.all()),
          child: TextField(
            controller: noteTextController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            style: TextStyle(
              color: primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              hintText: "Note",
              hintStyle: TextStyle(
                color: Constants.disableColor.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        SizedBox(height: 20),
        Divider(),
        SizedBox(height: 20),
        Consumer<ThemeSettingController>(builder: (_, controller, __) {
          return BorderContainer(
            text: 'Open Session',
            textColor: Colors.white,
            containerColor: primaryColor,
            onTap: () {
              _openSession();
            },
          );
        }),
        SizedBox(height: 20),
      ],
    );
  }

  void _openSession() {
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
          emailFrom: userController.loginEmployee?.workEmail ??
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
            .then((sessionResponse) {
          if (sessionResponse != null &&
              sessionResponse.statusCode == 200 &&
              sessionResponse.data != null &&
              sessionResponse.data is List &&
              (sessionResponse.data as List).isNotEmpty) {
            userController.posSession =
                POSSession.fromJson((sessionResponse.data as List).first);

            CashRegister cashRegister = CashRegister(
              configId: userController.posConfig?.id ?? 0,
              createDate: date,
              createUid: userId,
              date: date,
              name: userController.posSession?.name ?? '',
              state: 'open',
              userId: userId,
              writeDate: date,
              writeUid: userId,
              posSessionId: userController.posSession?.id ?? 0,
              balanceStart:
                  double.tryParse(amountTextController.text.toString()),
              balanceEnd: 0.0,
              difference: 0.0,
              balanceEndReal: 0.0,
              openingNotes: noteTextController.text,
            );
            Api.cashRegister(cashRegister: cashRegister)
                .then((cshResponse) async {
              if (cshResponse != null &&
                  cshResponse.statusCode == 200 &&
                  cshResponse.data != null) {
                Navigator.pop(widget.bContext, true);
                final Database db = await DatabaseHelper().db;
                POSSessionTable.insertOrUpdatePOSSessionWithDB(
                    db, userController.posSession!);
              }
            });
          } else {
            Navigator.pop(widget.bContext, false);
          }
        });
      } else {
        Navigator.pop(widget.bContext, false);
      }
    });
  }
}
