import 'package:flutter/material.dart';

import '../../controllers/activity_log_controller.dart';
import '../../data/models/activity_log.dart';

class ActivityLogView extends StatefulWidget {
  const ActivityLogView({super.key});

  @override
  State<ActivityLogView> createState() => _ActivityLogViewState();
}

class _ActivityLogViewState extends State<ActivityLogView> {
  late final ActivityLogController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ActivityLogController();
    _controller.addListener(_onChanged);
    _controller.loadData();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showLogDialog({ActivityLog? editing}) async {
    String action = editing?.action ?? '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editing == null ? 'Thêm log' : 'Sửa log'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => action = value,
          decoration: InputDecoration(
            hintText: editing?.action ?? 'Nhập nội dung thao tác',
            labelText: 'Nội dung thao tác',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, action),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;

    if (editing == null) {
      await _controller.addLog(result);
    } else {
      await _controller.editLog(editing, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 8 - Nhật ký hoạt động'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _controller.logs.isEmpty
                      ? const Center(child: Text('Chưa có log nào'))
                      : ListView.builder(
                          itemCount: _controller.logs.length,
                          itemBuilder: (context, index) {
                            final log = _controller.logs[index];
                            return ListTile(
                              title: Text(log.action),
                              subtitle: Text(log.time),
                              onTap: () => _showLogDialog(editing: log),
                              trailing: IconButton(
                                onPressed: () => _controller.removeLog(log),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey.shade100,
                  child: const Text(
                    'File log (activity_log.txt)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _controller.fileLogContent.isEmpty
                          ? 'Chưa có dữ liệu file log'
                          : _controller.fileLogContent,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showLogDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
