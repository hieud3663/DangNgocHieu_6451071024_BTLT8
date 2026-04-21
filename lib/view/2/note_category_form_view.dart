import 'package:flutter/material.dart';

import '../../controllers/note_category_controller.dart';
import '../../data/models/category.dart';
import '../../data/models/note.dart';

class NoteCategoryFormView extends StatefulWidget {
  final NoteCategoryController controller;
  final List<Category> categories;
  final Note? note;

  const NoteCategoryFormView({
    super.key,
    required this.controller,
    required this.categories,
    this.note,
  });

  @override
  State<NoteCategoryFormView> createState() => _NoteCategoryFormViewState();
}

class _NoteCategoryFormViewState extends State<NoteCategoryFormView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? _selectedCategoryId;
  bool _isSaving = false;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();

    if (_isEdit) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    _selectedCategoryId = widget.note?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id : null);

    if (_selectedCategoryId != null &&
      !widget.categories.any((c) => c.id == _selectedCategoryId)) {
      _selectedCategoryId =
        widget.categories.isNotEmpty ? widget.categories.first.id : null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục')),
      );
      return;
    }

    setState(() => _isSaving = true);

    await widget.controller.saveNote(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      categoryId: _selectedCategoryId!,
      editingNote: widget.note,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _deleteNote() async {
    final noteId = widget.note?.id;
    if (noteId == null) return;

    await widget.controller.removeNote(noteId);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final hasCategories = widget.categories.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Chỉnh sửa ghi chú' : 'Tạo ghi chú theo danh mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!hasCategories)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Chưa có danh mục. Vui lòng tạo danh mục trước.'),
                ),
              Row(
                children: [
                  const Text('Danh mục: '),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedCategoryId,
                      items: widget.categories
                          .map(
                            (category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: hasCategories
                          ? (value) {
                              setState(() => _selectedCategoryId = value);
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving || !hasCategories ? null : _saveNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu'),
                ),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _deleteNote,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Xóa ghi chú'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
