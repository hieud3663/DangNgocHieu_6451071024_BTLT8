import 'package:flutter/material.dart';
import '../../data/models/dashboard_item.dart';
import '../../../widget/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      DashboardItem(
        icon: Icons.note_alt_outlined,
        iconColor: Colors.blue,
        label: 'Bài 1: Ghi chú cơ bản',
        onTap: () => Navigator.pushNamed(context, '/notes'),
      ),
      DashboardItem(
        icon: Icons.category_outlined,
        iconColor: Colors.deepOrange,
        label: 'Bài 2: Ghi chú có danh mục',
        onTap: () => Navigator.pushNamed(context, '/notes_by_category'),
      ),
      DashboardItem(
        icon: Icons.checklist_outlined,
        iconColor: Colors.green,
        label: 'Bài 3: To-do backup JSON',
        onTap: () => Navigator.pushNamed(context, '/tasks'),
      ),
      DashboardItem(
        icon: Icons.payments_outlined,
        iconColor: Colors.purple,
        label: 'Bài 4: Quản lý chi tiêu',
        onTap: () => Navigator.pushNamed(context, '/expenses'),
      ),
      DashboardItem(
        icon: Icons.menu_book_outlined,
        iconColor: Colors.indigo,
        label: 'Bài 5: Từ điển offline',
        onTap: () => Navigator.pushNamed(context, '/dictionary'),
      ),
      DashboardItem(
        icon: Icons.photo_library_outlined,
        iconColor: Colors.brown,
        label: 'Bài 6: Lưu ảnh offline',
        onTap: () => Navigator.pushNamed(context, '/offline_gallery'),
      ),
      DashboardItem(
        icon: Icons.history_outlined,
        iconColor: Colors.redAccent,
        label: 'Bài 8: Nhật ký hoạt động',
        onTap: () => Navigator.pushNamed(context, '/activity_logs'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: items.map((item) => DashboardCard(item: item)).toList(),
        ),
      ),
    );
  }
}
