import 'package:offline_pos/components/export_files.dart';

class QuotationOrderListController with ChangeNotifier {
  List<QuotationDataModel> _quotationList = [];
  List<QuotationDataModel> get quotationList => _quotationList;
  set quotationList(List<QuotationDataModel> quotationList) {
    _quotationList = quotationList;
    notifyListeners();
  }

  DataSourceForQuotationListScreen? _quotationInfoDataSource;
  DataSourceForQuotationListScreen? get quotationInfoDataSource =>
      _quotationInfoDataSource;
  set quotationInfoDataSource(
      DataSourceForQuotationListScreen? quotationInfoDataSource) {
    _quotationInfoDataSource = quotationInfoDataSource;
    notifyListeners();
  }
}
