import 'package:offline_pos/components/export_files.dart';

class ProductDetailController with ChangeNotifier {
  ViewMode _mode = ViewMode.view;
  ViewMode get mode => _mode;
  set mode(ViewMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  Product _creatingProduct = Product();
  Product get creatingProduct => _creatingProduct;
  set creatingProduct(Product creatingProduct) {
    _creatingProduct = creatingProduct;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();

  notify() {
    notifyListeners();
  }

  bool _isBarcodeView = false;
  bool get isBarcodeView => _isBarcodeView;
  set isBarcodeView(bool isBarcodeView) {
    _isBarcodeView = isBarcodeView;
    notifyListeners();
  }

  resetProductDetailController() {
    _mode = ViewMode.view;
    _creatingProduct = Product();
    _isBarcodeView = false;
    notifyListeners();
  }
}
