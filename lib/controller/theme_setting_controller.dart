import 'package:offline_pos/components/export_files.dart';

class ThemeSettingController with ChangeNotifier {
  // ThemeSettingController() {
  //   getThemeConfig();
  // }

  Uint8List? _imageBytes;
  Uint8List? get imageBytes => _imageBytes;
  set imageBytes(Uint8List? imageBytes) {
    _imageBytes = imageBytes;
    notifyListeners();
  }

  String _themeColor = "";
  String get themeColor => _themeColor;
  set themeColor(String themeColor) {
    if (_themeColor == themeColor) return;
    _themeColor = themeColor;
    notifyListeners();
  }

  AppConfig? _appConfig;
  AppConfig? get appConfig => _appConfig;
  set appConfig(AppConfig? appConfig) {
    _appConfig = appConfig;
    notifyListeners();
  }

  bool _themeColorFocus = false;
  bool get themeColorFocus => _themeColorFocus;
  set themeColorFocus(bool themeColorFocus) {
    if (_themeColorFocus == themeColorFocus) return;
    _themeColorFocus = themeColorFocus;
    notifyListeners();
  }

  Future<void> getThemeConfig() async {
    AppConfigTable.getAppConfig().then((value) {
      _appConfig = value;
      _themeColor = appConfig?.themeBodyColor != null &&
              appConfig!.themeBodyColor!.isNotEmpty
          ? appConfig!.themeBodyColor!
          : primaryColor
              .toString()
              .toLowerCase()
              .replaceAll("color(0xff", "")
              .replaceAll(")", "");
      primaryColor = Color(int.parse('0xff$_themeColor'));

      if (appConfig?.logo != null) {
        _imageBytes = appConfig!.logo;
      }
      // primaryColor.value = Color(
      //   int.parse('0xff$_themeColor'),
      // );
      notifyListeners();
    });
  }

  notify() {
    _imageBytes = null;
    _themeColor = "";
    _appConfig = null;
    _themeColorFocus = false;
    notifyListeners();
  }
}
