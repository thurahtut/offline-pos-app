import 'package:offline_pos/components/export_files.dart';

class OrderHistoryListController with ChangeNotifier {
  List<OrderHistoryDataModel> _orderHistoryList = [];
  List<OrderHistoryDataModel> get orderHistoryList => _orderHistoryList;
  set orderHistoryList(List<OrderHistoryDataModel> orderHistoryList) {
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
}
