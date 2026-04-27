import 'package:flutter/foundation.dart';

import '../data/models/activity_log.dart';
import '../data/repositories/activity_log_repository.dart';

class ActivityLogController extends ChangeNotifier {
  final ActivityLogRepository _repository;

  ActivityLogController({ActivityLogRepository? repository})
    : _repository = repository ?? ActivityLogRepository();

  List<ActivityLog> _logs = [];
  String _fileLogContent = '';
  bool _isLoading = false;

  List<ActivityLog> get logs => _logs;
  String get fileLogContent => _fileLogContent;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _logs = await _repository.getAllLogs();
    _fileLogContent = await _repository.getFileLogContent();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLog(String action) async {
    final trimmed = action.trim();
    if (trimmed.isEmpty) return;

    await _repository.addLog(trimmed);
    await loadData();
  }

  Future<void> editLog(ActivityLog log, String newAction) async {
    final trimmed = newAction.trim();
    if (trimmed.isEmpty) return;

    await _repository.updateLog(log, trimmed);
    await loadData();
  }

  Future<void> removeLog(ActivityLog log) async {
    await _repository.deleteLog(log);
    await loadData();
  }
}
