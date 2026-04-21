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
