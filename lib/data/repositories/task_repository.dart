import '../models/task.dart';
import '../services/task_db_service.dart';
import '../services/task_file_service.dart';

class TaskRepository {
  final TaskDbService _dbService;
  final TaskFileService _fileService;

  TaskRepository({TaskDbService? dbService, TaskFileService? fileService})
    : _dbService = dbService ?? TaskDbService.instance,
      _fileService = fileService ?? TaskFileService();

  Future<List<Task>> getAllTasks() {
    return _dbService.getAllTasks();
  }

  Future<void> addTask(String title) {
    return _dbService.insertTask(Task(title: title));
  }

  Future<void> updateTask(Task task) {
    return _dbService.updateTask(task);
  }

  Future<void> deleteTask(int id) {
    return _dbService.deleteTask(id);
  }

  Future<String> exportTasks(List<Task> tasks) {
    return _fileService.exportTasks(tasks);
  }

  Future<bool> importTasks() async {
    final tasks = await _fileService.importTasks();
    if (tasks == null) return false;

    await _dbService.replaceAllTasks(tasks);
    return true;
  }
}
