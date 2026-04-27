import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/dictionary_entry.dart';
import '../services/dictionary_db_service.dart';

class DictionaryRepository {
  final DictionaryDbService _dbService;

  DictionaryRepository({DictionaryDbService? dbService})
    : _dbService = dbService ?? DictionaryDbService.instance;

  Future<void> ensureSeededFromAsset() async {
    final count = await _dbService.countEntries();
    if (count > 0) return;

    final jsonString = await rootBundle.loadString(
      'assets/dictionary/dictionary_data.json',
    );
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) return;

    final entries = decoded
        .whereType<Map<String, dynamic>>()
        .map(DictionaryEntry.fromJson)
        .where(
          (entry) =>
              entry.word.trim().isNotEmpty && entry.meaning.trim().isNotEmpty,
        )
        .toList();

    if (entries.isEmpty) return;
    await _dbService.insertMany(entries);
  }

  Future<List<DictionaryEntry>> searchWords(String keyword) {
    return _dbService.searchWords(keyword);
  }
}
