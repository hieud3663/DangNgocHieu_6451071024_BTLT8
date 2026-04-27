import 'dart:io';

import 'package:flutter/material.dart';

import '../../controllers/offline_image_controller.dart';

class OfflineGalleryView extends StatefulWidget {
  const OfflineGalleryView({super.key});

  @override
  State<OfflineGalleryView> createState() => _OfflineGalleryViewState();
}

class _OfflineGalleryViewState extends State<OfflineGalleryView> {
  late final OfflineImageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OfflineImageController();
    _controller.addListener(_onChanged);
    _controller.loadImages();
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

  Future<void> _addImage() async {
    await _controller.addFakeImage();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu một ảnh giả lập vào bộ nhớ máy')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 6 - Lưu ảnh offline'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.images.isEmpty
          ? const Center(child: Text('Chưa có ảnh nào'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _controller.images.length,
              itemBuilder: (context, index) {
                final image = _controller.images[index];
                final file = File(image.path);

                if (!file.existsSync()) {
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addImage,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Thêm ảnh'),
      ),
    );
  }
}
