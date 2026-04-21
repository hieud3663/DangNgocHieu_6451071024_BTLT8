import 'package:flutter/material.dart';
import 'package:flutter_baitap_chuong11/view/1/note_list_view.dart';
import 'package:flutter_baitap_chuong11/view/2/note_category_list_view.dart';
import '../view/dashboard/dashboard_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/notes': (context) => const NoteListView(),
        '/notes_by_category': (context) => const NoteCategoryListView(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      builder: (context, child) => Stack(
        children: [
          child!,
          Positioned(
            top: MediaQuery.of(context).padding.top + 6,
            left: 10,
            child: const Text(
              '6451071024 - Đặng Ngọc Hiếu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
