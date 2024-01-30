import 'package:offline_pos/components/export_files.dart';

class LoginUserController with ChangeNotifier {
  User? _loginUser;
  User? get loginUser => _loginUser;
  set loginUser(User? loginUser) {
    _loginUser = loginUser;
    notifyListeners();
  }

  ConfigData? _selectedInventory;
  ConfigData? get selectedInventory => _selectedInventory;
  set selectedInventory(ConfigData? selectedInventory) {
    _selectedInventory = selectedInventory;
    notifyListeners();
  }

  int _selectingInventoryId = 0;
  int get selectingInventoryId => _selectingInventoryId;
  set selectingInventoryId(int selectingInventoryId) {
    if (_selectingInventoryId == selectingInventoryId) return;
    _selectingInventoryId = selectingInventoryId;
    notifyListeners();
  }

  POSConfig? _posConfig;
  POSConfig? get posConfig => _posConfig;
  set posConfig(POSConfig? posConfig) {
    _posConfig = posConfig;
    notifyListeners();
  }

  POSSession? _posSession;
  POSSession? get posSession => _posSession;
  set posSession(POSSession? posSession) {
    _posSession = posSession;
    notifyListeners();
  }

  // List<Employee> _employeeList = [];
  // List<Employee> get employeeList => _employeeList;
  // set employeeList(List<Employee> employeeList) {
  //   _employeeList = employeeList;
  //   notifyListeners();
  // }

  resetLoginUserController() {
    _loginUser = null;
    _selectedInventory = null;
    // _employeeList = [];
    notifyListeners();
  }
}
