import 'package:offline_pos/components/export_files.dart';

class OrderProductPackagingController extends ChangeNotifier {
  ProductPackaging? _selectedProductPackaging;
  ProductPackaging? get selectedProductPackaging => _selectedProductPackaging;

  set selectedProductPackaging(ProductPackaging? selectedProductPackaging) {
    if (_selectedProductPackaging == selectedProductPackaging) return;
    _selectedProductPackaging = selectedProductPackaging;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  resetOrderProductPackagingController() {
    _selectedProductPackaging = null;
    notifyListeners();
  }
}
