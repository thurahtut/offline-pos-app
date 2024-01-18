import 'package:offline_pos/components/export_files.dart';

class UserLoginForm extends StatefulWidget {
  const UserLoginForm({
    super.key,
    required this.mainContext,
    required this.bContext,
    required this.formKey,
  });
  final BuildContext mainContext;
  final BuildContext bContext;
  final GlobalKey<FormState> formKey;

  @override
  State<UserLoginForm> createState() => _UserLoginFormState();
}

class _UserLoginFormState extends State<UserLoginForm> {
  ValueNotifier<bool> passwordVisibility = ValueNotifier(false);

  @override
  void dispose() {
    passwordVisibility.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Constants.textColor,
      fontWeight: FontWeight.bold,
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width /
          (isMobileMode
              ? 1
              : isTabletMode
                  ? 2.3
                  : 4),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        widget.mainContext.read<ViewController>().email = newValue;
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
            loginUser(widget.bContext);
          },
          onSaved: (newValue) {
            widget.mainContext.read<ViewController>().password = newValue;
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
        Navigator.pop(widget.bContext, false);
      },
    );
  }

  BorderContainer _okButtonWidget() {
    return BorderContainer(
      text: 'OK',
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      containerColor: primaryColor.withOpacity(0.9),
      textColor: Colors.white,
      // width: MediaQuery.of(context).size.width /
      //     (isMobileMode
      //         ? 1
      //         : isTabletMode
      //             ? 2.8
      //             : 4.7),
      textSize: 18,
      radius: 8,
      onTap: () {
        loginUser(widget.bContext);
      },
    );
  }

  void loginUser(BuildContext bContext) {
    if (widget.formKey.currentState?.validate() ?? false) {
      widget.formKey.currentState?.save();
      Api.login(
        email: widget.mainContext.read<ViewController>().email,
        password: widget.mainContext.read<ViewController>().password,
      ).then((response) {
        if (response != null &&
            response.statusCode == 200 &&
            response.data != null) {
          context.read<LoginUserController>().loginUser =
              User.fromJson(response.data);
          LoginUserTable.insertOrUpdateUser(
              context.read<LoginUserController>().loginUser!);
          Navigator.pop(bContext, true);
        }
      });
    }
  }
}
