import '../models/offline_image.dart';
import '../services/offline_image_service.dart';

class OfflineImageRepository {
  final OfflineImageService _service;

  OfflineImageRepository({OfflineImageService? service})
    : _service = service ?? OfflineImageService.instance;

  Future<List<OfflineImage>> getAllImages() {
    return _service.getAllImages();
  }

  Future<void> addFakeImage() async {
    final filePath = await _service.saveFakeImageToFile();
    await _service.insertImagePath(filePath);
  }
}
