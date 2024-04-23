import 'package:offline_pos/components/export_files.dart';

class OrderListController with ChangeNotifier {
  List<OrderHistory> _orderList = [];
  List<OrderHistory> get orderList => _orderList;
  set orderList(List<OrderHistory> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  DataSourceForOrderListScreen? _orderInfoDataSource;
  DataSourceForOrderListScreen? get orderInfoDataSource => _orderInfoDataSource;
  set orderInfoDataSource(DataSourceForOrderListScreen? orderInfoDataSource) {
    _orderInfoDataSource = orderInfoDataSource;
    notifyListeners();
  }

  String? _filterValue;
  String? get filterValue => _filterValue;
  set filterValue(String? filterValue) {
    if (_filterValue == filterValue) return;
    _filterValue = filterValue;
    notifyListeners();
  }

  String? _typefilterValue;
  String? get typefilterValue => _typefilterValue;
  set typefilterValue(String? typefilterValue) {
    if (_typefilterValue == typefilterValue) return;
    _typefilterValue = typefilterValue;
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

  DateTime? _dateFilter;
  DateTime? get dateFilter => _dateFilter;
  set dateFilter(DateTime? dateFilter) {
    if (_dateFilter == dateFilter) return;
    _dateFilter = dateFilter;
    notify();
  }

  notify() {
    notifyListeners();
  }

  Future<void> getAllOrderHistory() async {
    getAllOrderHistoryCount();
    await OrderHistoryTable.getOrderHistorysFiltering(
      filter: filterValue,
      typeFilter: typefilterValue,
      limit: limit,
      offset: offset,
      dateFilter: dateFilter?.toString(),
    ).then((list) {
      orderList = [];
      orderList.addAll(list);
      notifyListeners();
    });
  }

  Future<void> getAllOrderHistoryCount() async {
    OrderHistoryTable.getAllOrderHistoryCount(
      filter: filterValue,
    ).then((count) {
      total = count;
    });
  }

  resetCustomerListController() {
    _orderList = [];
    _orderInfoDataSource = null;
    _currentIndex = 1;
    _total = 0;
    _offset = 0;
    _loading = false;
    _dateFilter = null;
    notifyListeners();
  }
}
