import 'package:offline_pos/components/export_files.dart';

class PasswordDialog {
  static Future<Object?> enterPasswordWidget(
    BuildContext context,
    TextEditingController passwordTextController,
  ) {
    FocusNode? myFocusNode = FocusNode();
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Constants.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Center(
                      child: Text(
                        'Password ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Constants.greyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        autofocus: true,
                        // focusNode: myFocusNode,
                        controller: passwordTextController,
                        keyboardType: TextInputType.visiblePassword, //to check
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  _passwordKeyboardWidget(passwordTextController, myFocusNode),
                  SizedBox(height: 16),
                  CommonUtils.okCancelWidget(
                    okCallback: () {
                      Navigator.pop(context, true);
                    },
                    cancelCallback: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  SizedBox(height: 26),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      myFocusNode.dispose();
      return value;
    });
  }

  static Widget _passwordKeyboardWidget(
    TextEditingController passwordTextController,
    FocusNode? myFocusNode,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _eachKeyboardRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "1",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "1";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "2",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "2";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "3",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "3";
              },
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachKeyboardRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "4",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "4";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "5",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "5";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "6",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "6";
              },
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachKeyboardRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "7",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "7";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "8",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "8";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "9",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "9";
              },
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachKeyboardRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "C",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.clear();
                // myFocusNode?.requestFocus();
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "0",
              width: 70,
              height: 70,
              textSize: 20,
              onPressed: () {
                passwordTextController.text += "0";
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              width: 70,
              height: 70,
              iconSize: 28,
              icon: Icons.backspace_outlined,
              iconColor: Constants.alertColor,
              onPressed: () {
                passwordTextController.text = passwordTextController.text
                    .substring(0, passwordTextController.text.length - 1);
              },
            ),
          ],
        ),
      ],
    );
  }

  static Widget _eachKeyboardRowWidget(List<Widget> widgets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets
          .map((e) => Row(
                children: [
                  e,
                  SizedBox(
                    width: 4,
                  )
                ],
              ))
          .toList(),
    );
  }
}
