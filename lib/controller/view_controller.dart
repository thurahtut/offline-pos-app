import 'package:offline_pos/components/export_files.dart';

class ViewController with ChangeNotifier {
  bool _isList = true;
  bool get isList => _isList;
  set isList(bool isList) {
    if (_isList == isList) return;
    _isList = isList;
    notifyListeners();
  }

  bool _isHome = true;
  bool get isHome => _isHome;
  set isHome(bool isHome) {
    if (_isHome == isHome) return;
    _isHome = isHome;
    notifyListeners();
  }

  bool _isCustomerView = false;
  bool get isCustomerView => _isCustomerView;
  set isCustomerView(bool isCustomerView) {
    if (_isCustomerView == isCustomerView) return;
    _isCustomerView = isCustomerView;
    notifyListeners();
  }

  bool _isKeyboardHide = false;
  bool get isKeyboardHide => _isKeyboardHide;
  set isKeyboardHide(bool isKeyboardHide) {
    if (_isKeyboardHide == isKeyboardHide) return;
    _isKeyboardHide = isKeyboardHide;
    notifyListeners();
  }

  bool _hideCategory = false;
  bool get hideCategory => _hideCategory;
  set hideCategory(bool hideCategory) {
    if (_hideCategory == hideCategory) return;
    _hideCategory = hideCategory;
    notifyListeners();
  }

  bool _connectedWifi = false;
  bool get connectedWifi => _connectedWifi;
  set connectedWifi(bool connectedWifi) {
    if (_connectedWifi == connectedWifi) return;
    _connectedWifi = connectedWifi;
    notifyListeners();
  }

  // int _userId = 0;
  // int get userId => _userId;
  // set userId(int userId) {
  //   if (_userId == userId) return;
  //   _userId = userId;
  //   notifyListeners();
  // }

  // int _userPinCode = 0;
  // int get userPinCode => _userPinCode;
  // set userPinCode(int userPinCode) {
  //   if (_userPinCode == userPinCode) return;
  //   _userPinCode = userPinCode;
  //   notifyListeners();
  // }

  String? _email;
  String? get email => _email;
  set email(String? email) {
    if (_email == email) return;
    _email = email;
    notifyListeners();
  }

  String? _password;
  String? get password => _password;
  set password(String? password) {
    if (_password == password) return;
    _password = password;
    notifyListeners();
  }

  // final FocusNode productFocusNode = FocusNode();
  final FocusNode searchProductFocusNode = FocusNode();

  TextEditingController? _searchProductTextController = TextEditingController();
  TextEditingController? get searchProductTextController =>
      _searchProductTextController;
  set searchProductTextController(
      TextEditingController? searchProductTextController) {
    _searchProductTextController = searchProductTextController;
    notifyListeners();
  }

  bool _barcodePackageConflict = false;
  bool get barcodePackageConflict => _barcodePackageConflict;
  set barcodePackageConflict(bool barcodePackageConflict) {
    if (_barcodePackageConflict == barcodePackageConflict) return;
    _barcodePackageConflict = barcodePackageConflict;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
