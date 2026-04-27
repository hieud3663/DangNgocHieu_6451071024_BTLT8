import 'package:flutter/material.dart';

import '../../controllers/dictionary_controller.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  late final DictionaryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DictionaryController();
    _controller.addListener(_onChanged);
    _controller.initialize();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String keyword) {
    _controller.search(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 5 - Từ điển offline'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Nhập từ cần tra...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _controller.results.isEmpty
                ? const Center(child: Text('Không tìm thấy kết quả'))
                : ListView.builder(
                    itemCount: _controller.results.length,
                    itemBuilder: (context, index) {
                      final item = _controller.results[index];
                      return ListTile(
                        title: Text(
                          item.word,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(item.meaning),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
