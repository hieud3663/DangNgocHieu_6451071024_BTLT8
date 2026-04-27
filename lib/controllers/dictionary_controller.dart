import 'package:flutter/foundation.dart';

import '../data/models/dictionary_entry.dart';
import '../data/repositories/dictionary_repository.dart';

class DictionaryController extends ChangeNotifier {
  final DictionaryRepository _repository;

  DictionaryController({DictionaryRepository? repository})
    : _repository = repository ?? DictionaryRepository();

  List<DictionaryEntry> _results = [];
  bool _isLoading = false;

  List<DictionaryEntry> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _repository.ensureSeededFromAsset();
    _results = await _repository.searchWords('');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String keyword) async {
    _results = await _repository.searchWords(keyword);
    notifyListeners();
  }
}
