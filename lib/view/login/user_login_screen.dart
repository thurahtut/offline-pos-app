import 'package:offline_pos/view/inventory/choose_inventory_dialog.dart';

import '/components/export_files.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});
  static const String routeName = "/user_login_screen";

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> passwordVisibility = ValueNotifier(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ThemeSettingController>().getThemeConfig();
    });
    super.initState();
  }

  @override
  void dispose() {
    passwordVisibility.dispose();
    super.dispose();
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
        body: _bodyWidget(),
      );
    });
  }

  void showLoginDialog() {
    ChooseInventoryDialog.chooseInventoryDialogWidget(
      context,
    ).then((value) {
      if (value == true) {
        // AppConfigTable.deleteByColumnName(PRODUCT_LAST_SYNC_DATE);
        // context.read<ThemeSettingController>().appConfig?.productLastSyncDate =
        //     null;
        // context.read<ThemeSettingController>().notify();

        Navigator.pushNamed(
          context,
          MorningSyncScreen.routeName,
          arguments: MorningSyncScreen(alreadyLogin: false),
        );
      } 
    });
  }

  Widget _bodyWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Constants.textColor,
      fontWeight: FontWeight.bold,
    );
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width /
            (isMobileMode
                ? 1
                : isTabletMode
                    ? 2.3
                    : 4),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor.withOpacity(0.94),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 4,
              spreadRadius: 6,
              // offset: Offset(9, 9),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login User',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Divider(),
              SizedBox(height: MediaQuery.of(context).size.height / 13),
              _emailWidget(textStyle),
              SizedBox(height: 20),
              _pinWidget(textStyle, context),
              SizedBox(height: MediaQuery.of(context).size.height / 13),
              SizedBox(
                width: MediaQuery.of(context).size.width /
                    (isMobileMode
                        ? 1
                        : isTabletMode
                            ? 2.3
                            : 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _cancelButtonWidget(),
                    SizedBox(height: 20),
                    _okButtonWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _emailWidget(TextStyle textStyle) {
    return TextFormField(
      autofocus: true,
      style: TextStyle(
        color: Constants.textColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        label: Text('Email'),
        labelStyle: textStyle,
        contentPadding: EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(
      //     RegExp(r'^\d+'),
      //   ),
      // ],
      onSaved: (newValue) {
        context.read<ViewController>().email = newValue;
      },
      validator: (value) {
        if (value == null) {
          return "Please enter email!";
        }
        return null;
      },
    );
  }

  ValueListenableBuilder<bool> _pinWidget(
      TextStyle textStyle, BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: passwordVisibility,
      builder: (_, passwordVisible, __) {
        return TextFormField(
          autofocus: true,
          style: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.visiblePassword, //to check
          decoration: InputDecoration(
            label: Text('Password'),
            labelStyle: textStyle,
            contentPadding: EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            suffixIcon: InkWell(
              onTap: () {
                passwordVisibility.value = !passwordVisibility.value;
              },
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          // inputFormatters: [
          //   FilteringTextInputFormatter.allow(
          //     RegExp(r'^\d+'),
          //   ),
          // ],
          obscureText: !passwordVisible,
          onFieldSubmitted: (value) {
            loginUser();
          },
          onSaved: (newValue) {
            context.read<ViewController>().password = newValue;
          },
          validator: (value) {
            if (value == null) {
              return "Please enter password!";
            }
            return null;
          },
        );
      },
    );
  }

  BorderContainer _cancelButtonWidget() {
    return BorderContainer(
      text: 'Cancel',
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      containerColor: Colors.white.withOpacity(0.9),
      textColor: Constants.textColor,
      // width: MediaQuery.of(context).size.width /
      //     (isMobileMode
      //         ? 1
      //         : isTabletMode
      //             ? 2.8
      //             : 4.7),
      textSize: 18,
      radius: 8,
      onTap: () {
        setState(() {});
      },
    );
  }

  BorderContainer _okButtonWidget() {
    return BorderContainer(
      text: 'OK',
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      containerColor: primaryColor.withOpacity(0.9),
      textColor: Colors.white,
      textSize: 18,
      radius: 8,
      onTap: () {
        loginUser();
      },
    );
  }

  void loginUser() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Api.login(
        email: context.read<ViewController>().email,
        password: context.read<ViewController>().password,
      ).then((response) {
        if (response != null &&
            response.statusCode == 200 &&
            response.data != null) {
          context.read<LoginUserController>().loginUser =
              User.fromJson(response.data);
          LoginUserTable.insertOrUpdateUser(
              context.read<LoginUserController>().loginUser!);
          showLoginDialog();
        } else {
          CommonUtils.showSnackBar(
              context: context,
              message: response?.statusMessage ?? 'Something was wrong!');
        }
      });
    }
  }
}
