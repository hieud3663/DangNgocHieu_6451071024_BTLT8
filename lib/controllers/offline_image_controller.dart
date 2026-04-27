import 'package:flutter/foundation.dart';

import '../data/models/offline_image.dart';
import '../data/repositories/offline_image_repository.dart';

class OfflineImageController extends ChangeNotifier {
  final OfflineImageRepository _repository;

  OfflineImageController({OfflineImageRepository? repository})
    : _repository = repository ?? OfflineImageRepository();

  List<OfflineImage> _images = [];
  bool _isLoading = false;

  List<OfflineImage> get images => _images;
  bool get isLoading => _isLoading;

  Future<void> loadImages() async {
    _isLoading = true;
    notifyListeners();

    _images = await _repository.getAllImages();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFakeImage() async {
    await _repository.addFakeImage();
    await loadImages();
  }
}
