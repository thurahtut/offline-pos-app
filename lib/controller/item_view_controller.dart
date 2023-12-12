import 'package:offline_pos/components/export_files.dart';

class ItemViewController with ChangeNotifier {
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
}
