import 'dart:convert';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image/image.dart' as img;
import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ThemeSettingScreen extends StatefulWidget {
  const ThemeSettingScreen({super.key});
  static const String routeName = "/theme_setting_screen";

  @override
  State<ThemeSettingScreen> createState() => _ThemeSettingScreenState();
}

class _ThemeSettingScreenState extends State<ThemeSettingScreen> {
  var formKey = GlobalKey<FormState>();
  bool? isSwitch = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThemeSettingController>().getThemeConfig();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Form(
      key: formKey,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Constants.greyColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Constants.greyColor2.withOpacity(0.3),
                blurRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(children: [
            _titleWidget(),
            SizedBox(height: 50),
            _logoWidget(),
            SizedBox(height: 20),
            _themeBodyColorWidget(),
            SizedBox(
              height: 20,
            ),
            _rememberPasswordWidget(),
            Expanded(child: SizedBox()),
            _actionWidget(),
          ]),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return CommonUtils.okCancelWidget(
      textSize: 15,
      outsidePadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 12,
      ),
      switchBtns: true,
      okLabel: 'Save',
      cancelCallback: () {
        context.read<ThemeSettingController>().getThemeConfig();
      },
      okCallback: () async {
        ThemeSettingController controller =
            context.read<ThemeSettingController>();
        final Database db = await DatabaseHelper().db;
        // await db.transaction((txn) async {
        // final Database database = txn.database;
        await AppConfigTable.insertOrUpdateWithDB(
            db, THEME_BODY_COLOR, controller.themeColor);

        if (controller.imageBytes != null &&
            controller.imageBytes!.isNotEmpty) {
          await AppConfigTable.insertOrUpdateWithDB(
              db, LOGO, base64Encode(controller.imageBytes!));
        }
        // });
        controller.getThemeConfig();
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(
          style: ButtonStyle(
            iconSize: MaterialStateProperty.resolveWith((states) => 30),
          ),
        ),
        Text(
          'Setting',
          style: TextStyle(
            color: Constants.textColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(),
      ],
    );
  }

  Widget _logoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _childrenTitleWidget('Logo'),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              InkWell(
                onTap: _pickImage,
                child: (context.watch<ThemeSettingController>().imageBytes !=
                        null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Image.memory(context
                                    .read<ThemeSettingController>()
                                    .imageBytes!),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 30,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black, blurRadius: 8.0)
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Constants.disableColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: const [
                              Center(
                                child: Text(
                                  'No image selected',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 8.0)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _childrenTitleWidget(String text) {
    return Text(
      text,
      // textAlign: TextAlign.end,
      style: TextStyle(
        color: Constants.textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _themeBodyColorWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _childrenTitleWidget('Theme Body Color'),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Consumer<ThemeSettingController>(builder: (_, cc, __) {
            Color themeColor = Color(0xff000000);
            try {
              Color(
                int.parse('0xff${cc.themeColor}'),
              );
              themeColor = Color(int.parse('0xff${cc.themeColor}'));
            } catch (e) {
              themeColor = Color(0xff000000);
            }
            return TextFormField(
              key: Key(themeColor.value.toString()),
              autofocus: cc.themeColorFocus,
              initialValue: cc.themeColor,
              style: TextStyle(
                color: Constants.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              decoration: InputDecoration(
                  hintText: '007ACC',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.textColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.textColor,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              enableAlpha: false,
                              pickerColor: themeColor,
                              onColorChanged: (color) {
                                cc.themeColor = color
                                    .toString()
                                    .toLowerCase()
                                    .replaceAll("color(0xff", "")
                                    .replaceAll(")", "");
                              },
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Confirm'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: themeColor,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )),
              onChanged: (value) {
                cc.themeColorFocus = true;
                context.read<ThemeSettingController>().themeColor = value;
              },
              onFieldSubmitted: (value) {},
            );
          }),
        ),
      ],
    );
  }

  Widget _rememberPasswordWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
        flex: 1,
        child: _childrenTitleWidget('Remember Password'),
      ),
      SizedBox(width: 20),
      Expanded(
        flex: 2,
        child: Consumer<ThemeSettingController>(builder: (_, cc, __) {
          return SwitchListTile(
            value: //isSwitch ?? true,
                cc.appConfig?.rememberPassword ?? true,
            onChanged: (value) {
              cc.appConfig?.rememberPassword = value;
              cc.notify();
              // setState(() {
              //   isSwitch = value;
              // });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: primaryColor,
            // side: MaterialStateBorderSide.resolveWith(
            //     (_) => BorderSide(width: 2, color: primaryColor)),
            // checkColor: primaryColor,
            // fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
          );
        }),
      )
    ]);
  }

  Future<void> _pickImage() async {
    // Pick an image
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    // Read the image file
    Uint8List? imageBytes = await pickedFile.readAsBytes();

    // Optionally, you can resize the image using the image package
    img.Image? image = img.decodeImage(imageBytes);
    if (image != null) {
      image = img.copyResize(image, width: 300); // Adjust the width as needed
      imageBytes = Uint8List.fromList(img.encodePng(image));
      if (mounted) {
        context.read<ThemeSettingController>().imageBytes = imageBytes;
      }
    }
  }
}
