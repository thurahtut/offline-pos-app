import 'package:offline_pos/components/export_files.dart';

class PaymentMethodListController with ChangeNotifier {
  List<PaymentMethods> _paymentMethodList = [];
  List<PaymentMethods> get paymentMethodList => _paymentMethodList;
  set paymentMethodList(List<PaymentMethods> paymentMethodList) {
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

  PaymentMethods? _editingPaymentMethod;
  PaymentMethods? get editingPaymentMethod => _editingPaymentMethod;
  set editingPaymentMethod(PaymentMethods? editingPaymentMethod) {
    if (_editingPaymentMethod == editingPaymentMethod) return;
    _editingPaymentMethod = editingPaymentMethod;
    notifyListeners();
  }
}
