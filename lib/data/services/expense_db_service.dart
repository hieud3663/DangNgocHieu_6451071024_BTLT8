import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category_total.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';

class ExpenseDbService {
  static final ExpenseDbService instance = ExpenseDbService._init();
  static Database? _database;

  ExpenseDbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expenses.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            note TEXT NOT NULL,
            categoryId INTEGER NOT NULL,
            FOREIGN KEY(categoryId) REFERENCES categories(id) ON DELETE CASCADE
          )
        ''');

        await _insertDefaultCategories(db);
      },
    );
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = ['Ăn uống', 'Di chuyển', 'Mua sắm', 'Học tập'];

    for (final name in defaultCategories) {
      await db.insert('categories', {'name': name});
    }
  }

  Future<List<ExpenseCategory>> getCategories() async {
    final db = await database;
    final maps = await db.query('categories', orderBy: 'name ASC');
    return maps.map(ExpenseCategory.fromMap).toList();
  }

  Future<int> insertCategory(String name) async {
    final db = await database;
    return db.insert('categories', {
      'name': name.trim(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT expenses.id, expenses.amount, expenses.note, expenses.categoryId,
             categories.name AS categoryName
      FROM expenses
      INNER JOIN categories ON categories.id = expenses.categoryId
      ORDER BY expenses.id DESC
    ''');

    return maps.map(Expense.fromMap).toList();
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert('expenses', expense.toMap()..remove('id'));
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return db.update(
      'expenses',
      expense.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CategoryTotal>> getTotalsByCategory() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT categories.id AS categoryId,
             categories.name AS categoryName,
             COALESCE(SUM(expenses.amount), 0) AS total
      FROM categories
      LEFT JOIN expenses ON expenses.categoryId = categories.id
      GROUP BY categories.id, categories.name
      ORDER BY categories.name ASC
    ''');

    return maps.map(CategoryTotal.fromMap).toList();
  }
}
