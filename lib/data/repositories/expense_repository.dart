import '../models/category_total.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/expense_db_service.dart';

class ExpenseRepository {
  final ExpenseDbService _dbService;

  ExpenseRepository({ExpenseDbService? dbService})
    : _dbService = dbService ?? ExpenseDbService.instance;

  Future<List<ExpenseCategory>> getCategories() {
    return _dbService.getCategories();
  }

  Future<void> addCategory(String name) async {
    if (name.trim().isEmpty) return;
    await _dbService.insertCategory(name);
  }

  Future<List<Expense>> getAllExpenses() {
    return _dbService.getAllExpenses();
  }

  Future<List<CategoryTotal>> getTotalsByCategory() {
    return _dbService.getTotalsByCategory();
  }

  Future<void> addExpense({
    required double amount,
    required String note,
    required int categoryId,
  }) {
    return _dbService.insertExpense(
      Expense(amount: amount, note: note, categoryId: categoryId),
    );
  }

  Future<void> updateExpense(Expense expense) {
    return _dbService.updateExpense(expense);
  }

  Future<void> deleteExpense(int id) {
    return _dbService.deleteExpense(id);
  }
}
