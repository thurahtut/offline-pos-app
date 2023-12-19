import 'package:offline_pos/components/export_files.dart';

class ProductListController with ChangeNotifier {
  List<Product> _productList = [];
  List<Product> get productList => _productList;
  set productList(List<Product> productList) {
    _productList = productList;
    notifyListeners();
  }

  DataSourceForProductListScreen? _productInfoDataSource;
  DataSourceForProductListScreen? get productInfoDataSource =>
      _productInfoDataSource;
  set productInfoDataSource(
      DataSourceForProductListScreen? productInfoDataSource) {
    _productInfoDataSource = productInfoDataSource;
    notifyListeners();
  }
}
