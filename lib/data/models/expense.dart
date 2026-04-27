class Expense {
  final int? id;
  final double amount;
  final String note;
  final int categoryId;
  final String? categoryName;

  const Expense({
    this.id,
    required this.amount,
    required this.note,
    required this.categoryId,
    this.categoryName,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String,
      categoryId: map['categoryId'] as int,
      categoryName: map['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'amount': amount, 'note': note, 'categoryId': categoryId};
  }
}
