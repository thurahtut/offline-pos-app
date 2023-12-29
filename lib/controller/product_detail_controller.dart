import 'package:offline_pos/components/export_files.dart';

class ProductDetailController with ChangeNotifier {
  ProductDetailMode _mode = ProductDetailMode.view;
  ProductDetailMode get mode => _mode;
  set mode(ProductDetailMode mode) {
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

  resetProductDetailController() {
    _mode = ProductDetailMode.view;
    _creatingProduct = Product();
    notifyListeners();
  }
}
