import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/dictionary_entry.dart';

class DictionaryDbService {
  static final DictionaryDbService instance = DictionaryDbService._init();
  static Database? _database;

  DictionaryDbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'dictionary.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dictionary(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            meaning TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> countEntries() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM dictionary',
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<void> insertMany(List<DictionaryEntry> entries) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final entry in entries) {
        await txn.insert('dictionary', entry.toMap()..remove('id'));
      }
    });
  }

  Future<List<DictionaryEntry>> searchWords(String keyword) async {
    final db = await database;

    if (keyword.trim().isEmpty) {
      final maps = await db.query('dictionary', orderBy: 'word ASC', limit: 30);
      return maps.map(DictionaryEntry.fromMap).toList();
    }

    final maps = await db.query(
      'dictionary',
      where: 'LOWER(word) LIKE ?',
      whereArgs: ['%${keyword.toLowerCase()}%'],
      orderBy: 'word ASC',
      limit: 100,
    );

    return maps.map(DictionaryEntry.fromMap).toList();
  }
}
