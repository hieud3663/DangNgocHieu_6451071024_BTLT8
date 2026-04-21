import 'package:flutter/material.dart';

import '../../controllers/note_controller.dart';
import '../../data/models/note.dart';

class NoteFormView extends StatefulWidget {
  final NoteController noteController;
  final Note? note;

  const NoteFormView({
    super.key,
    required this.noteController,
    this.note,
  });

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
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

    setState(() => _isSaving = true);

    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );

    await widget.noteController.saveNote(
      title: note.title,
      content: note.content,
      editingNote: _isEdit ? widget.note : null,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _deleteNote() async {
    final noteId = widget.note?.id;
    if (noteId == null) return;

    await widget.noteController.removeNote(noteId);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Chi tiết ghi chú' : 'Tạo ghi chú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
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
                  labelText: 'Content',
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
                  onPressed: _isSaving ? null : _saveNote,
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
              ]
            ],
          ),
        ),
      ),
    );
  }
}
