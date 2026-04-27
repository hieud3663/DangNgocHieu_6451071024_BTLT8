import 'package:flutter/material.dart';

import '../../controllers/expense_controller.dart';
import '../../data/models/expense.dart';
import 'expense_form_view.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  late final ExpenseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseController();
    _controller.addListener(_onControllerChanged);
    _controller.loadData();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openForm([Expense? expense]) async {
    if (_controller.categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có danh mục chi tiêu')),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ExpenseFormView(controller: _controller, expense: expense),
      ),
    );
  }

  Future<void> _showCreateCategoryDialog() async {
    String categoryName = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm danh mục'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => categoryName = value,
          decoration: const InputDecoration(
            labelText: 'Tên danh mục',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, categoryName),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;
    await _controller.addCategory(result);
  }

  String _formatMoney(double value) {
    return '${value.toStringAsFixed(0)} đ';
  }

  Widget _buildTotalSection() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng tiền: ${_formatMoney(_controller.totalAmount)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._controller.totals.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.categoryName),
                    Text(_formatMoney(item.total)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => _openForm(expense),
        title: Text(
          _formatMoney(expense.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${expense.note}\nDanh mục: ${expense.categoryName ?? ''}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: () {
            if (expense.id != null) {
              _controller.removeExpense(expense.id!);
            }
          },
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 4 - Quản lý chi tiêu'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showCreateCategoryDialog,
            icon: const Icon(Icons.add_card_outlined),
            tooltip: 'Thêm danh mục',
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTotalSection(),
                Expanded(
                  child: _controller.expenses.isEmpty
                      ? const Center(child: Text('Chưa có chi tiêu nào'))
                      : ListView.builder(
                          itemCount: _controller.expenses.length,
                          itemBuilder: (context, index) {
                            return _buildExpenseCard(
                              _controller.expenses[index],
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
