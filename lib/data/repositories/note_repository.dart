import '../models/category.dart';
import '../models/note.dart';
import '../services/note_db_service.dart';

class NoteRepository {
  final NoteDbService _noteDbService;

  NoteRepository({NoteDbService? noteDbService})
      : _noteDbService = noteDbService ?? NoteDbService.instance;

  Future<List<Note>> getAllNotes() {
    return _noteDbService.getAllNotes();
  }

  Future<List<Note>> getNotesByCategory(int? categoryId) {
    return _noteDbService.getNotesByCategory(categoryId);
  }

  Future<int> addNote(Note note) {
    return _noteDbService.insertNote(note);
  }

  Future<int> updateNote(Note note) {
    return _noteDbService.updateNote(note);
  }

  Future<int> deleteNote(int id) {
    return _noteDbService.deleteNote(id);
  }

  Future<List<Category>> getCategories() async {
    final maps = await _noteDbService.getCategories();
    return maps.map(Category.fromMap).toList();
  }

  Future<int> addCategory(String name) {
    return _noteDbService.insertCategory(name);
  }
}
