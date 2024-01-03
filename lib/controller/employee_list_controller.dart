import 'package:offline_pos/components/export_files.dart';

class EmployeeListController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  ViewMode _mode = ViewMode.view;
  ViewMode get mode => _mode;
  set mode(ViewMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  Employee _creatingEmployee = Employee();
  Employee get creatingEmployee => _creatingEmployee;
  set creatingEmployee(Employee creatingEmployee) {
    _creatingEmployee = creatingEmployee;
    notifyListeners();
  }

  Employee _toSelectEmployee = Employee();
  Employee get toSelectEmployee => _toSelectEmployee;
  set toSelectEmployee(Employee toSelectEmployee) {
    toSelectEmployee = toSelectEmployee;
    notifyListeners();
  }

  List<Employee> _employeeList = [];
  List<Employee> get employeeList => _employeeList;
  set employeeList(List<Employee> employeeList) {
    _employeeList = employeeList;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  resetEmployeeListController() {
    _mode = ViewMode.view;
    _creatingEmployee = Employee();
    _toSelectEmployee = Employee();
    _employeeList.clear;
    notifyListeners();
  }
}
