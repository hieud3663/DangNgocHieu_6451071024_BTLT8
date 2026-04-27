import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class TaskFileService {
  Future<String> exportTasks(List<Task> tasks) async {
    final databasePath = await getDatabasesPath();
    final folder = Directory(databasePath);

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final filePath = p.join(folder.path, 'tasks_backup.json');
    final file = File(filePath);
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(tasks.map((task) => task.toJson()).toList());

    await file.writeAsString(jsonString);
    return filePath;
  }

  Future<List<Task>?> importTasks() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    final file = File(result.files.single.path!);
    final content = await file.readAsString();
    final jsonData = jsonDecode(content);

    if (jsonData is! List) {
      throw const FormatException('File JSON không đúng định dạng');
    }

    return jsonData
        .whereType<Map<String, dynamic>>()
        .map(Task.fromJson)
        .where((task) => task.title.trim().isNotEmpty)
        .toList();
  }
}
