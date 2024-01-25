import 'package:offline_pos/components/export_files.dart';

class PosCategoryController with ChangeNotifier {
  List<PosCategory> _posCategoryList = [];
  List<PosCategory> get posCategoryList => _posCategoryList;
  set posCategoryList(List<PosCategory> posCategoryList) {
    _posCategoryList = posCategoryList;
    notifyListeners();
  }

  int? _selectedCategory = -1;
  int? get selectedCategory => _selectedCategory;
  set selectedCategory(int? selectedCategory) {
    if (_selectedCategory == selectedCategory) return;
    _selectedCategory = selectedCategory;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
