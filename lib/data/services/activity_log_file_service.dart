import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class ActivityLogFileService {
  Future<File> _getLogFile() async {
    final databasePath = await getDatabasesPath();
    final folder = Directory(p.join(databasePath, 'activity_log_files'));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    return File(p.join(folder.path, 'activity_log.txt'));
  }

  Future<void> appendLogLine(String action, String time) async {
    final file = await _getLogFile();
    final line = '[$time] $action\n';
    await file.writeAsString(line, mode: FileMode.append, flush: true);
  }

  Future<String> readAllLogs() async {
    final file = await _getLogFile();
    if (!await file.exists()) return '';
    return file.readAsString();
  }
}
