import 'package:offline_pos/components/export_files.dart';

class CloseSessionController with ChangeNotifier {
  Map<int, PaymentTransaction> _paymentTransactionList = {};
  Map<int, PaymentTransaction> get paymentTransactionList =>
      _paymentTransactionList;
  set paymentTransactionList(
      Map<int, PaymentTransaction> paymentTransactionList) {
    _paymentTransactionList = paymentTransactionList;
    notifyListeners();
  }

  Map<String, double> _totalSummaryMap = {};
  Map<String, double> get totalSummaryMap => _totalSummaryMap;
  set totalSummaryMap(Map<String, double> totalSummaryMap) {
    _totalSummaryMap = totalSummaryMap;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  resetCloseSessionController() {
    _paymentTransactionList = {};
    notifyListeners();
  }
}
