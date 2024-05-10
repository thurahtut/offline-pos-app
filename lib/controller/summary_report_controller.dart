import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite/sqflite.dart';

class SummaryReportController with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    if (_loading == loading) return;
    _loading = loading;
    notifyListeners();
  }

  List<Map<String, dynamic>> _summaryReportMap = [];
  List<Map<String, dynamic>> get summaryReportMap => _summaryReportMap;

  List<Map<String, dynamic>> _transactionReportMap = [];
  List<Map<String, dynamic>> get transactionReportMap => _transactionReportMap;

  Map<String, dynamic>? _discountMap;
  Map<String, dynamic>? get discountMap => _discountMap;

  double _totalRefund = 0;
  double get totalRefund => _totalRefund;
  set totalRefund(double totalRefund) {
    if (_totalRefund == totalRefund) return;
    _totalRefund = totalRefund;
    notifyListeners();
  }

  void getTotalSummaryByCategory({required int sessionId}) async {
    Database db = await DatabaseHelper().db;
    OrderHistoryTable.getTotalAmountByCategory(
      db: db,
      sessionId: sessionId,
    ).then((summaryMap) {
      if (summaryMap.isNotEmpty) {
        _summaryReportMap = summaryMap;
        PaymentTransactionTable.getTotalTransactionSummaryWithName(sessionId)
            .then((tranMap) {
          _transactionReportMap = tranMap;
          OrderLineIdTable.getDiscountAmtAndFOC(db: db, sessionId: sessionId)
              .then(
            (disMap) {
              _discountMap = disMap;
              OrderHistoryTable.getTotalRefundAmount(
                      db: db, sessionId: sessionId)
                  .then(
                (refund) {
                  _totalRefund = refund;
                  notifyListeners();
                },
              );
            },
          );
        });
      } else {
        CommonUtils.showSnackBar(message: 'Please check your order!');
      }
    });
  }

  resetSummaryReportController() {
    _loading = false;
    _summaryReportMap = [];
    _transactionReportMap = [];
    _totalRefund = 0;
    notifyListeners();
  }
}
