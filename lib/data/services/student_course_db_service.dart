import 'package:flutter_baitap_chuong11/data/models/course.dart';
import 'package:flutter_baitap_chuong11/data/models/student.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StudentCourseDbService {
  static final StudentCourseDbService instance = StudentCourseDbService._init();
  static Database? _database;

  StudentCourseDbService._init();

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'student_course.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE enrollments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId INTEGER NOT NULL,
            courseId INTEGER NOT NULL,
            FOREIGN KEY(studentId) REFERENCES students(id) ON DELETE CASCADE,
            FOREIGN KEY(courseId) REFERENCES courses(id) ON DELETE CASCADE,
            UNIQUE(studentId, courseId)
          )
        ''');
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<int> insertStudent(String name) async {
    final db = await database;
    return db.insert('students', {'name': name.trim()});
  }

  Future<int> insertCourse(String name) async {
    final db = await database;
    return db.insert('courses', {'name': name.trim()});
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final maps = await db.query('students', orderBy: 'name ASC');
    return maps.map(Student.fromMap).toList();
  }

  Future<List<Course>> getAllCourses() async {
    final db = await database;
    final maps = await db.query('courses', orderBy: 'name ASC');
    return maps.map(Course.fromMap).toList();
  }

  Future<void> enrollStudentInCourse(int studentId, int courseId) async {
    final db = await database;
    await db.insert('enrollments', {
      'studentId': studentId,
      'courseId': courseId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> unenrollStudentFromCourse(int studentId, int courseId) async {
    final db = await database;

    await db.delete(
      'enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [studentId, courseId],
    );
  }

  Future<List<Course>> getCoursesByStudent(int studentId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT c.id, c.name
      FROM courses c
      INNER JOIN enrollments e ON c.id = e.courseId
      WHERE e.studentId = ?
      ORDER BY c.name ASC
    ''',
      [studentId],
    );

    return maps.map(Course.fromMap).toList();
  }

  Future<List<int>> getEnrollmentCourseIds(int studentId) async {
    final db = await database;
    final maps = await db.query(
      'enrollments',
      columns: ['courseId'],
      where: 'studentId = ?',
      whereArgs: [studentId],
    );

    return maps.map((map) => map['courseId'] as int).toList();
  }
}
