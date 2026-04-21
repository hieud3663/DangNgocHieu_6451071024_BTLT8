import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class NoteDbService {
  NoteDbService._();

  static final NoteDbService instance = NoteDbService._();

  static const String _dbName = 'notes.db';
  static const String _tableName = 'notes';
  static const String _categoryTableName = 'categories';
  static const String _defaultCategoryName = 'Mặc định';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, _dbName);

    _database = await openDatabase(
      dbPath,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _upgradeToV2(db);
        }
      },
    );

    return _database!;
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $_categoryTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES $_categoryTableName(id) ON DELETE SET NULL
      )
    ''');

    await db.insert(_categoryTableName, {'name': _defaultCategoryName});
  }

  Future<void> _upgradeToV2(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_categoryTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.insert(
      _categoryTableName,
      {'name': _defaultCategoryName},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    final hasCategoryId = await _hasColumn(db, _tableName, 'categoryId');
    if (!hasCategoryId) {
      await db.execute('ALTER TABLE $_tableName ADD COLUMN categoryId INTEGER');
    }
  }

  Future<bool> _hasColumn(Database db, String tableName, String column) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    return columns.any((col) => col['name'] == column);
  }

  Future<int> _ensureDefaultCategory(Database db) async {
    final rows = await db.query(
      _categoryTableName,
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [_defaultCategoryName],
      limit: 1,
    );

    if (rows.isNotEmpty) {
      return rows.first['id'] as int;
    }

    return db.insert(_categoryTableName, {'name': _defaultCategoryName});
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT n.id, n.title, n.content, n.categoryId, c.name AS categoryName
      FROM $_tableName n
      LEFT JOIN $_categoryTableName c ON c.id = n.categoryId
      ORDER BY n.id DESC
    ''');
    return maps.map(Note.fromMap).toList();
  }

  Future<List<Note>> getNotesByCategory(int? categoryId) async {
    final db = await database;

    if (categoryId == null) {
      return getAllNotes();
    }

    final maps = await db.rawQuery(
      '''
      SELECT n.id, n.title, n.content, n.categoryId, c.name AS categoryName
      FROM $_tableName n
      LEFT JOIN $_categoryTableName c ON c.id = n.categoryId
      WHERE n.categoryId = ?
      ORDER BY n.id DESC
      ''',
      [categoryId],
    );
    return maps.map(Note.fromMap).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    final data = note.toMap()..remove('id');
    data['categoryId'] ??= await _ensureDefaultCategory(db);
    return db.insert(_tableName, data);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    final data = note.toMap()..remove('id');
    data['categoryId'] ??= await _ensureDefaultCategory(db);

    return db.update(
      _tableName,
      data,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    await _ensureDefaultCategory(db);
    return db.query(_categoryTableName, orderBy: 'name ASC');
  }

  Future<int> insertCategory(String name) async {
    final db = await database;
    return db.insert(
      _categoryTableName,
      {'name': name.trim()},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
