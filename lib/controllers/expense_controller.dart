import 'package:flutter/foundation.dart';

import '../data/models/category_total.dart';
import '../data/models/expense.dart';
import '../data/models/expense_category.dart';
import '../data/repositories/expense_repository.dart';

class ExpenseController extends ChangeNotifier {
  final ExpenseRepository _repository;

  ExpenseController({ExpenseRepository? repository})
    : _repository = repository ?? ExpenseRepository();

  List<ExpenseCategory> _categories = [];
  List<Expense> _expenses = [];
  List<CategoryTotal> _totals = [];
  bool _isLoading = false;

  List<ExpenseCategory> get categories => _categories;
  List<Expense> get expenses => _expenses;
  List<CategoryTotal> get totals => _totals;
  bool get isLoading => _isLoading;

  double get totalAmount {
    return _totals.fold(0, (sum, item) => sum + item.total);
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _categories = await _repository.getCategories();
    _expenses = await _repository.getAllExpenses();
    _totals = await _repository.getTotalsByCategory();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _repository.addCategory(name);
    await loadData();
  }

  Future<void> saveExpense({
    required double amount,
    required String note,
    required int categoryId,
    Expense? editingExpense,
  }) async {
    if (editingExpense == null) {
      await _repository.addExpense(
        amount: amount,
        note: note,
        categoryId: categoryId,
      );
    } else {
      await _repository.updateExpense(
        Expense(
          id: editingExpense.id,
          amount: amount,
          note: note,
          categoryId: categoryId,
        ),
      );
    }

    await loadData();
  }

  Future<void> removeExpense(int id) async {
    await _repository.deleteExpense(id);
    await loadData();
  }
}
