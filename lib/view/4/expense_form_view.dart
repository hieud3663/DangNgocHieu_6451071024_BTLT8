import 'package:flutter/material.dart';

import '../../controllers/expense_controller.dart';
import '../../data/models/expense.dart';

class ExpenseFormView extends StatefulWidget {
  final ExpenseController controller;
  final Expense? expense;

  const ExpenseFormView({super.key, required this.controller, this.expense});

  @override
  State<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _noteController = TextEditingController(text: widget.expense?.note ?? '');
    _selectedCategoryId = widget.expense?.categoryId;

    if (_selectedCategoryId == null &&
        widget.controller.categories.isNotEmpty) {
      _selectedCategoryId = widget.controller.categories.first.id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn danh mục')));
      return;
    }

    await widget.controller.saveExpense(
      amount: double.parse(_amountController.text.trim()),
      note: _noteController.text.trim(),
      categoryId: _selectedCategoryId!,
      editingExpense: widget.expense,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _deleteExpense() async {
    final id = widget.expense?.id;
    if (id == null) return;

    await widget.controller.removeExpense(id);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa chi tiêu' : 'Thêm chi tiêu'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _deleteExpense,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                if (amount == null || amount <= 0) {
                  return 'Vui lòng nhập số tiền hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập ghi chú';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Danh mục',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedCategoryId,
                  isExpanded: true,
                  items: widget.controller.categories
                      .map(
                        (category) => DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _saveExpense, child: const Text('Lưu')),
          ],
        ),
      ),
    );
  }
}
