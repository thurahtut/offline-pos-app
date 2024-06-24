import 'package:offline_pos/components/export_files.dart';

class PriceListItemController with ChangeNotifier {
  List<Product> _priceItemList = [];
  List<Product> get priceItemList => _priceItemList;
  set priceItemList(List<Product> priceItemList) {
    _priceItemList = priceItemList;
    notifyListeners();
  }

  DataSourceForPriceItemListScreen? _priceItemDataSource;
  DataSourceForPriceItemListScreen? get priceItemDataSource =>
      _priceItemDataSource;
  set priceItemDataSource(
      DataSourceForPriceItemListScreen? priceItemDataSource) {
    _priceItemDataSource = priceItemDataSource;
    notifyListeners();
  }

  bool _isDetail = false;
  bool get isDetail => _isDetail;
  set isDetail(bool isDetail) {
    if (_isDetail == isDetail) return;
    _isDetail = isDetail;
    notifyListeners();
  }

  bool _isNew = false;
  bool get isNew => _isNew;
  set isNew(bool isNew) {
    if (_isNew == isNew) return;
    _isNew = isNew;
    notifyListeners();
  }

  Product? _editingPriceItem;
  Product? get editingPriceItem => _editingPriceItem;
  set editingPriceItem(Product? editingPriceItem) {
    if (_editingPriceItem == editingPriceItem) return;
    _editingPriceItem = editingPriceItem;
    notifyListeners();
  }

  Product? _creatingPriceItem;
  Product? get creatingPriceItem => _creatingPriceItem;
  set creatingPriceItem(Product? creatingPriceItem) {
    if (_creatingPriceItem == creatingPriceItem) return;
    _creatingPriceItem = creatingPriceItem;
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

  Future<void> getAllPriceItemList({
    String? filter,
    required String? categoryListFilter,
  }) async {
    priceItemList = [];
    getTotalProductCount(categoryListFilter);
    await PriceListItemTable.getPriceItemByFilteringWithProduct(
      filter: filterValue,
      limit: limit,
      offset: offset,
    ).then((list) {
      priceItemList.addAll(list);
      notifyListeners();
    });
  }

  Future<void> getTotalProductCount(String? categoryListFilter) async {
    ProductTable.getAllProductCount(
      filter: filterValue,
      categoryListFilter: categoryListFilter,
    ).then((count) {
      total = count;
    });
  }

  resetPriceItemListController() {
    _priceItemList = [];
    _priceItemDataSource = null;
    _isDetail = false;
    _isNew = false;
    _editingPriceItem = null;
    _creatingPriceItem = null;
    notifyListeners();
  }
}
