import 'package:offline_pos/components/export_files.dart';

class ProductPackagingController with ChangeNotifier {
  List<ProductPackaging> _productPackagingList = [];
  List<ProductPackaging> get productPackagingList => _productPackagingList;
  set productPackagingList(List<ProductPackaging> productPackagingList) {
    _productPackagingList = productPackagingList;
    notifyListeners();
  }

  DataSourceForProductPackagingListScreen? _productPackagingInfoDataSource;
  DataSourceForProductPackagingListScreen? get productPackagingInfoDataSource =>
      _productPackagingInfoDataSource;
  set productPackagingInfoDataSource(
      DataSourceForProductPackagingListScreen? productPackagingInfoDataSource) {
    _productPackagingInfoDataSource = productPackagingInfoDataSource;
    notifyListeners();
  }
}
