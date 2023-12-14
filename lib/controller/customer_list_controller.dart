import 'package:offline_pos/components/export_files.dart';

class CustomerListController with ChangeNotifier {
  List<CustomerDataModel> _customerList = [];
  List<CustomerDataModel> get customerList => _customerList;
  set customerList(List<CustomerDataModel> customerList) {
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
}
