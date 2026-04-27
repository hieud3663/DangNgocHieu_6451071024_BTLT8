import 'package:flutter/foundation.dart';

import '../data/models/task.dart';
import '../data/repositories/task_repository.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository _repository;

  TaskController({TaskRepository? repository})
    : _repository = repository ?? TaskRepository();

  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _repository.getAllTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    await _repository.addTask(trimmedTitle);
    await loadTasks();
  }

  Future<void> toggleTask(Task task, bool isDone) async {
    await _repository.updateTask(task.copyWith(isDone: isDone));
    await loadTasks();
  }

  Future<void> removeTask(int id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }

  Future<String> exportTasks() async {
    return _repository.exportTasks(_tasks);
  }

  Future<bool> importTasks() async {
    final imported = await _repository.importTasks();
    if (imported) {
      await loadTasks();
    }
    return imported;
  }
}
