import 'package:flutter/material.dart';

import '../data/models/note.dart';
import '../data/repositories/note_repository.dart';

class NoteController extends ChangeNotifier {
  final NoteRepository _noteRepository;

  NoteController({NoteRepository? noteRepository})
      : _noteRepository = noteRepository ?? NoteRepository();

  final List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isLoading => _isLoading;

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    final data = await _noteRepository.getAllNotes();
    _notes
      ..clear()
      ..addAll(data);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveNote({
    required String title,
    required String content,
    Note? editingNote,
    int? categoryId,
  }) async {
    final note = Note(
      id: editingNote?.id,
      title: title,
      content: content,
      categoryId: categoryId ?? editingNote?.categoryId,
    );

    if (editingNote == null) {
      await _noteRepository.addNote(note);
    } else {
      await _noteRepository.updateNote(note);
    }

    await loadNotes();
  }

  Future<void> removeNote(int id) async {
    await _noteRepository.deleteNote(id);
    await loadNotes();
  }
}
