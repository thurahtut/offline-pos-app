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

  String? _filterValue;
  String? get filterValue => _filterValue;
  set filterValue(String? filterValue) {
    if (_filterValue == filterValue) return;
    _filterValue = filterValue;
    notifyListeners();
  }

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;
  set currentIndex(int currentIndex) {
    if (currentIndex == _currentIndex) return;
    _currentIndex = currentIndex;
    notifyListeners();
  }

  int _total = 0;
  int get total => _total;
  set total(int total) {
    if (total == _total) return;
    _total = total;
    notifyListeners();
  }

  int _limit = 20;
  int get limit => _limit;
  set limit(int limit) {
    if (limit == _limit) return;
    _limit = limit;
    notifyListeners();
  }

  int _offset = 0;
  int get offset => _offset;
  set offset(int offset) {
    if (offset == _offset) return;
    _offset = offset;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    if (_loading == loading) return;
    _loading = loading;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  Future<void> getAllCustomer() async {
    customerList = [];
    getTotalCustomerCount();
    await CustomerTable.getCustomersFiltering(
      filter: filterValue,
      limit: limit,
      offset: offset,
    ).then((list) {
      customerList.addAll(list);
      notifyListeners();
    });
  }

  Future<void> getTotalCustomerCount() async {
    CustomerTable.getAllCustomerCount(
      filter: filterValue,
    ).then((count) {
      total = count;
    });
  }

  resetCustomerListController() {
    _customerList = [];
    _customerInfoDataSource = null;
    _currentIndex = 1;
    _total = 0;
    _offset = 0;
    _loading = false;
    notifyListeners();
  }
}
