class ExpenseCategory {
  final int id;
  final String name;

  const ExpenseCategory({required this.id, required this.name});

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(id: map['id'] as int, name: map['name'] as String);
  }
}
