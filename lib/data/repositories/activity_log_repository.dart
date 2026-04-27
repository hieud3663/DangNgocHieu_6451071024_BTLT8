import '../models/activity_log.dart';
import '../services/activity_log_db_service.dart';
import '../services/activity_log_file_service.dart';

class ActivityLogRepository {
  final ActivityLogDbService _dbService;
  final ActivityLogFileService _fileService;

  ActivityLogRepository({
    ActivityLogDbService? dbService,
    ActivityLogFileService? fileService,
  }) : _dbService = dbService ?? ActivityLogDbService.instance,
       _fileService = fileService ?? ActivityLogFileService();

  String _nowIso() {
    return DateTime.now().toIso8601String();
  }

  Future<List<ActivityLog>> getAllLogs() {
    return _dbService.getAllLogs();
  }

  Future<String> getFileLogContent() {
    return _fileService.readAllLogs();
  }

  Future<void> addLog(String action) async {
    final time = _nowIso();
    await _dbService.insertLog(ActivityLog(action: action, time: time));
    await _fileService.appendLogLine('CREATE: $action', time);
  }

  Future<void> updateLog(ActivityLog log, String newAction) async {
    final time = _nowIso();
    await _dbService.updateLog(
      ActivityLog(id: log.id, action: newAction, time: time),
    );
    await _fileService.appendLogLine('UPDATE: #${log.id} "$newAction"', time);
  }

  Future<void> deleteLog(ActivityLog log) async {
    final time = _nowIso();
    if (log.id != null) {
      await _dbService.deleteLog(log.id!);
      await _fileService.appendLogLine(
        'DELETE: #${log.id} "${log.action}"',
        time,
      );
    }
  }
}
