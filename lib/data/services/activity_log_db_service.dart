import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity_log.dart';

class ActivityLogDbService {
  static final ActivityLogDbService instance = ActivityLogDbService._init();
  static Database? _database;

  ActivityLogDbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'activity_logs.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            action TEXT NOT NULL,
            time TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<ActivityLog>> getAllLogs() async {
    final db = await database;
    final maps = await db.query('logs', orderBy: 'id DESC');
    return maps.map(ActivityLog.fromMap).toList();
  }

  Future<int> insertLog(ActivityLog log) async {
    final db = await database;
    return db.insert('logs', log.toMap()..remove('id'));
  }

  Future<int> updateLog(ActivityLog log) async {
    final db = await database;
    return db.update(
      'logs',
      log.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deleteLog(int id) async {
    final db = await database;
    return db.delete('logs', where: 'id = ?', whereArgs: [id]);
  }
}
