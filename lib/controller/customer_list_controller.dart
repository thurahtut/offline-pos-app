import 'package:offline_pos/components/export_files.dart';

class CustomerListController with ChangeNotifier {
  List<Customer> _customerList = [];
  List<Customer> get customerList => _customerList;
  set customerList(List<Customer> customerList) {
    _customerList = customerList;
    notifyListeners();
  }

  CustomerInfoDataSourceForCustomerListScreen? _customerInfoDataSource;
  CustomerInfoDataSourceForCustomerListScreen? get customerInfoDataSource =>
      _customerInfoDataSource;
  set customerInfoDataSource(
      CustomerInfoDataSourceForCustomerListScreen? customerInfoDataSource) {
    _customerInfoDataSource = customerInfoDataSource;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
