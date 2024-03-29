import 'package:offline_pos/components/export_files.dart';

class OrderHistoryListController with ChangeNotifier {
  List<OrderHistory> _orderHistoryList = [];
  List<OrderHistory> get orderHistoryList => _orderHistoryList;
  set orderHistoryList(List<OrderHistory> orderHistoryList) {
    _orderHistoryList = orderHistoryList;
    notifyListeners();
  }

  DataSourceForOrderHistoryListScreen? _orderHistoryInfoDataSource;
  DataSourceForOrderHistoryListScreen? get orderHistoryInfoDataSource =>
      _orderHistoryInfoDataSource;
  set orderHistoryInfoDataSource(
      DataSourceForOrderHistoryListScreen? orderHistoryInfoDataSource) {
    _orderHistoryInfoDataSource = orderHistoryInfoDataSource;
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

  int _limit = 100;
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

  Future<void> getAllOrderHistory() async {
    getTotalCustomerCount();
    await OrderHistoryTable.getOrderHistorysFiltering(
      filter: filterValue,
      limit: limit,
      offset: offset,
    ).then((list) {
      orderHistoryList = [];
      orderHistoryList.addAll(list);
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
    _orderHistoryList = [];
    _orderHistoryInfoDataSource = null;
    _currentIndex = 1;
    _total = 0;
    _offset = 0;
    _loading = false;
    notifyListeners();
  }
}
