import 'package:flutter/material.dart';

import '../../controllers/note_category_controller.dart';
import '../../data/models/note.dart';
import 'note_category_form_view.dart';

class NoteCategoryListView extends StatefulWidget {
  const NoteCategoryListView({super.key});

  @override
  State<NoteCategoryListView> createState() => _NoteCategoryListViewState();
}

class _NoteCategoryListViewState extends State<NoteCategoryListView> {
  late final NoteCategoryController _controller;
  static const int _allCategoriesValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = NoteCategoryController()..addListener(_onControllerChanged);
    _controller.loadInitialData();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _showCreateCategoryDialog() async {
    String categoryName = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo danh mục'),
        content: TextField(
          onChanged: (value) => categoryName = value,
          decoration: const InputDecoration(
            labelText: 'Tên danh mục',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, categoryName),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;
    await _controller.addCategory(result);
  }

  Future<void> _openNoteForm([Note? note]) async {
    if (_controller.categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần tạo danh mục trước.')),
      );
      return;
    }

    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteCategoryFormView(
          controller: _controller,
          categories: _controller.categories,
          note: note,
        ),
      ),
    );

    if (changed == true) {
      await _controller.loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 2 - Ghi chú có danh mục'),
        actions: [
          IconButton(
            onPressed: _showCreateCategoryDialog,
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'Tạo danh mục',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text('Lọc: '),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _controller.selectedCategoryId ?? _allCategoriesValue,
                    items: [
                      const DropdownMenuItem<int>(
                        value: _allCategoriesValue,
                        child: Text('Tất cả danh mục'),
                      ),
                      ..._controller.categories.map(
                        (category) => DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null || value == _allCategoriesValue) {
                        _controller.setFilterCategory(null);
                        return;
                      }
                      _controller.setFilterCategory(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _controller.notes.isEmpty
                    ? const Center(
                        child: Text('Không có ghi chú theo bộ lọc hiện tại.'),
                      )
                    : ListView.builder(
                        itemCount: _controller.notes.length,
                        itemBuilder: (context, index) {
                          final note = _controller.notes[index];
                          return ListTile(
                            leading: const Icon(Icons.sticky_note_2_outlined),
                            title: Text(note.title),
                            subtitle: Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Chip(
                              label: Text(note.categoryName ?? 'Mặc định'),
                            ),
                            onTap: () => _openNoteForm(note),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteForm(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm ghi chú'),
      ),
    );
  }
}
