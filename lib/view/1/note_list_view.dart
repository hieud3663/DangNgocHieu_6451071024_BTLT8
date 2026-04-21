import 'package:flutter/material.dart';

import '../../controllers/note_controller.dart';
import '../../data/models/note.dart';
import '../1/note_form_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  late final NoteController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = NoteController()..addListener(_onControllerChanged);
    _noteController.loadNotes();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _noteController
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _openForm([Note? note]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormView(
          noteController: _noteController,
          note: note,
        ),
      ),
    );

    if (changed == true) {
      await _noteController.loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 1 - Ghi chú SQLite CRUD'),
      ),
      body: _noteController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _noteController.notes.isEmpty
              ? const Center(
                  child: Text('Chưa có ghi chú. Nhấn + để thêm mới.'),
                )
              : ListView.builder(
                  itemCount: _noteController.notes.length,
                  itemBuilder: (context, index) {
                    final note = _noteController.notes[index];
                    return ListTile(
                      leading: const Icon(Icons.note_alt_outlined),
                      title: Text(note.title),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _openForm(note),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
