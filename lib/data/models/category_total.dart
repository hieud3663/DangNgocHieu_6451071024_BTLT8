class CategoryTotal {
  final int categoryId;
  final String categoryName;
  final double total;

  const CategoryTotal({
    required this.categoryId,
    required this.categoryName,
    required this.total,
  });

  factory CategoryTotal.fromMap(Map<String, dynamic> map) {
    return CategoryTotal(
      categoryId: map['categoryId'] as int,
      categoryName: map['categoryName'] as String,
      total: (map['total'] as num).toDouble(),
    );
  }
}
