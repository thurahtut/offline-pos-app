import 'package:offline_pos/components/export_files.dart';

class PromotionListController with ChangeNotifier {
  List<Promotion> _promotionList = [];
  List<Promotion> get promotionList => _promotionList;
  set promotionList(List<Promotion> promotionList) {
    _promotionList = promotionList;
    notifyListeners();
  }

  DataSourceForPromotionListScreen? _promotionInfoDataSource;
  DataSourceForPromotionListScreen? get promotionInfoDataSource =>
      _promotionInfoDataSource;
  set promotionInfoDataSource(
      DataSourceForPromotionListScreen? promotionInfoDataSource) {
    _promotionInfoDataSource = promotionInfoDataSource;
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

  Future<void> getAllPromotion({Function()? callback, int? sessionId}) async {
    promotionList = [];
    getTotalPromotionCount();
    // await PromotionTable.getPromotionByProductId(
    //   filter: filterValue,
    //   limit: limit,
    //   offset: offset,
    //   sessionId: sessionId,
    // ).then((list) {
    //   promotionList.addAll(list);
    //   notifyListeners();
    //   callback?.call();
    // });
  }

  Future<void> getTotalPromotionCount() async {
    PromotionTable.getAllPromotionCount(
      filter: filterValue,
    ).then((count) {
      total = count;
    });
  }

  resetPromotionListController() {
    _promotionList = [];
    _promotionInfoDataSource = null;
    _currentIndex = 1;
    _total = 0;
    _offset = 0;
    _loading = false;
    notifyListeners();
  }
}
