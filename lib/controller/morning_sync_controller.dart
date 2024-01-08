import 'package:offline_pos/components/export_files.dart';

class MorningsyncController with ChangeNotifier {
  final int allTask = 1;

  int _currentReachTask = 1;
  int get currentReachTask => _currentReachTask;
  set currentReachTask(int currentReachTask) {
    if (_currentReachTask == currentReachTask) return;
    _currentReachTask = currentReachTask;
    notifyListeners();
  }

  String _currentTaskTitle = "";
  String get currentTaskTitle => _currentTaskTitle;
  set currentTaskTitle(String currentTaskTitle) {
    if (_currentTaskTitle == currentTaskTitle) return;
    _currentTaskTitle = currentTaskTitle;
    notifyListeners();
  }

  double? _percentage = 0;
  double? get percentage => _percentage;
  set percentage(double? percentage) {
    if (_percentage == percentage) return;
    _percentage = percentage;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
