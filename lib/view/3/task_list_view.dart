import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../data/models/task.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late final TaskController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TaskController();
    _controller.addListener(_onControllerChanged);
    _controller.loadTasks();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showAddTaskDialog() async {
    String title = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm công việc'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => title = value,
          decoration: const InputDecoration(
            labelText: 'Tên công việc',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, title),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;
    await _controller.addTask(result);
  }

  Future<void> _exportTasks() async {
    try {
      final path = await _controller.exportTasks();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã lưu file JSON: $path')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể export: $error')));
    }
  }

  Future<void> _importTasks() async {
    try {
      final imported = await _controller.importTasks();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            imported ? 'Đã import task từ file JSON' : 'Chưa chọn file JSON',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể import: $error')));
    }
  }

  Future<void> _deleteTask(Task task) async {
    if (task.id == null) return;
    await _controller.removeTask(task.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 3 - To-do backup JSON'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportTasks,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Export'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _importTasks,
                    icon: const Icon(Icons.download),
                    label: const Text('Import'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _controller.tasks.isEmpty
                ? const Center(child: Text('Chưa có công việc nào'))
                : ListView.separated(
                    itemCount: _controller.tasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final task = _controller.tasks[index];
                      return CheckboxListTile(
                        value: task.isDone,
                        onChanged: (value) {
                          _controller.toggleTask(task, value ?? false);
                        },
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        secondary: IconButton(
                          onPressed: () => _deleteTask(task),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
