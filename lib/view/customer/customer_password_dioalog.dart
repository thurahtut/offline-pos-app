import 'package:offline_pos/components/export_files.dart';

class CustomerPasswordDialog {
  static Future<Object?> enterCustomerPasswordWidget(
    BuildContext context,
    Customer customer,
    TextEditingController passwordTextController,
  ) {
    ValueNotifier<bool> passwordVisibility = ValueNotifier(false);
    final formKey = GlobalKey<FormState>();
    FocusNode? myFocusNode = FocusNode();
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
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
                          color: primaryColor,
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
                        child: ValueListenableBuilder<bool>(
                          valueListenable: passwordVisibility,
                          builder: (_, passwordVisible, __) {
                            return TextFormField(
                              autofocus: true,
                              // focusNode: myFocusNode,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                              controller: passwordTextController,
                              keyboardType:
                                  TextInputType.visiblePassword, //to check
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                border: InputBorder.none,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    passwordVisibility.value =
                                        !passwordVisibility.value;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Icon(
                                      passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Constants.alertColor,
                                    ),
                                  ),
                                ),
                              ),
                              obscureText: !passwordVisible,
                              onFieldSubmitted: (value) {
                                _checkPassword(
                                    bContext, customer, passwordTextController);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    CommonUtils.okCancelWidget(
                      okCallback: () {
                        _checkPassword(
                            bContext, customer, passwordTextController);
                      },
                      cancelCallback: () {
                        Navigator.pop(context, 0);
                      },
                    ),
                    SizedBox(height: 26),
                  ],
                ),
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

  static Future<void> _checkPassword(BuildContext bContext, Customer customer,
      TextEditingController passwordTextController) async {
    CustomerTable.checkCustomerWithIdAndPassword(
      customer.id ?? 0,
      passwordTextController.text,
    ).then((value) {
      Navigator.pop(bContext, customer.id ?? 0);
    });
  }
}
