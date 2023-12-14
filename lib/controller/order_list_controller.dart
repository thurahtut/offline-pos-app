import 'package:offline_pos/components/export_files.dart';

class OrderListController with ChangeNotifier {
  List<OrderDataModel> _orderList = [];
  List<OrderDataModel> get orderList => _orderList;
  set orderList(List<OrderDataModel> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  DataSourceForOrderListScreen? _orderInfoDataSource;
  DataSourceForOrderListScreen? get orderInfoDataSource => _orderInfoDataSource;
  set orderInfoDataSource(DataSourceForOrderListScreen? orderInfoDataSource) {
    _orderInfoDataSource = orderInfoDataSource;
    notifyListeners();
  }
}
