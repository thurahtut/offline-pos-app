import 'package:offline_pos/components/export_files.dart';

class PaymentMethodListController with ChangeNotifier {
  List<PaymentMethod> _paymentMethodList = [];
  List<PaymentMethod> get paymentMethodList => _paymentMethodList;
  set paymentMethodList(List<PaymentMethod> paymentMethodList) {
    _paymentMethodList = paymentMethodList;
    notifyListeners();
  }

  DataSourceForPaymentMethodListScreen? _paymentMethodInfoDataSource;
  DataSourceForPaymentMethodListScreen? get paymentMethodInfoDataSource =>
      _paymentMethodInfoDataSource;
  set paymentMethodInfoDataSource(
      DataSourceForPaymentMethodListScreen? paymentMethodInfoDataSource) {
    _paymentMethodInfoDataSource = paymentMethodInfoDataSource;
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

  PaymentMethod? _editingPaymentMethod;
  PaymentMethod? get editingPaymentMethod => _editingPaymentMethod;
  set editingPaymentMethod(PaymentMethod? editingPaymentMethod) {
    if (_editingPaymentMethod == editingPaymentMethod) return;
    _editingPaymentMethod = editingPaymentMethod;
    notifyListeners();
  }

  resetPaymentMethodListController() {
    _paymentMethodList = [];
    _paymentMethodInfoDataSource = null;
    _isDetail = false;
    _isNew = false;
    _editingPaymentMethod = null;
  }
}
