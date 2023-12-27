import 'package:offline_pos/components/export_files.dart';

class PriceRulesListController with ChangeNotifier {
  List<PriceRules> _priceRulesList = [];
  List<PriceRules> get priceRulesList => _priceRulesList;
  set priceRulesList(List<PriceRules> priceRulesList) {
    _priceRulesList = priceRulesList;
    notifyListeners();
  }

  DataSourceForPriceRulesListScreen? _priceRulesDataSource;
  DataSourceForPriceRulesListScreen? get priceRulesDataSource =>
      _priceRulesDataSource;
  set priceRulesDataSource(
      DataSourceForPriceRulesListScreen? priceRulesDataSource) {
    _priceRulesDataSource = priceRulesDataSource;
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

  PriceRules? _editingPriceRule;
  PriceRules? get editingPriceRule => _editingPriceRule;
  set editingPriceRule(PriceRules? editingPriceRule) {
    if (_editingPriceRule == editingPriceRule) return;
    _editingPriceRule = editingPriceRule;
    notifyListeners();
  }

  PriceRules? _creatingPriceRule;
  PriceRules? get creatingPriceRule => _creatingPriceRule;
  set creatingPriceRule(PriceRules? creatingPriceRule) {
    if (_creatingPriceRule == creatingPriceRule) return;
    _creatingPriceRule = creatingPriceRule;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  resetPriceRulesListController() {
    _priceRulesList = [];
    _priceRulesDataSource = null;
    _isDetail = false;
    _isNew = false;
    _editingPriceRule = null;
    _creatingPriceRule = null;
    notifyListeners();
  }
}
