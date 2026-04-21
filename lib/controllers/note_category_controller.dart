import 'package:flutter/material.dart';

import '../data/models/category.dart';
import '../data/models/note.dart';
import '../data/repositories/note_repository.dart';

class NoteCategoryController extends ChangeNotifier {
  final NoteRepository _noteRepository;

  NoteCategoryController({NoteRepository? noteRepository})
      : _noteRepository = noteRepository ?? NoteRepository();

  final List<Note> _notes = [];
  final List<Category> _categories = [];
  bool _isLoading = false;
  int? _selectedCategoryId;

  List<Note> get notes => List.unmodifiable(_notes);
  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  int? get selectedCategoryId => _selectedCategoryId;

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    await _loadCategoriesInternal();
    await _loadNotesInternal();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setFilterCategory(int? categoryId) async {
    _selectedCategoryId = categoryId;
    _isLoading = true;
    notifyListeners();

    await _loadNotesInternal();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;

    await _noteRepository.addCategory(trimmedName);
    await _loadCategoriesInternal();
    notifyListeners();
  }

  Future<void> saveNote({
    required String title,
    required String content,
    required int categoryId,
    Note? editingNote,
  }) async {
    final note = Note(
      id: editingNote?.id,
      title: title,
      content: content,
      categoryId: categoryId,
    );

    if (editingNote == null) {
      await _noteRepository.addNote(note);
    } else {
      await _noteRepository.updateNote(note);
    }

    await _loadNotesInternal();
    notifyListeners();
  }

  Future<void> removeNote(int id) async {
    await _noteRepository.deleteNote(id);
    await _loadNotesInternal();
    notifyListeners();
  }

  Future<void> _loadCategoriesInternal() async {
    final data = await _noteRepository.getCategories();
    _categories
      ..clear()
      ..addAll(data);
  }

  Future<void> _loadNotesInternal() async {
    final data = await _noteRepository.getNotesByCategory(_selectedCategoryId);
    _notes
      ..clear()
      ..addAll(data);
  }
}
