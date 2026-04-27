import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/offline_image.dart';

class OfflineImageService {
  static final OfflineImageService instance = OfflineImageService._init();
  static Database? _database;

  final List<String> _listOfFakeImages = [ 'adidas_bag.jpg', 'casio_watch.jpg', 'sony_headphone.jpg', 'nike_shoes.jpg', 'rayban_glasses.webp', 'uniqlo_jacket.jpg', 'avatar.png' ];

  OfflineImageService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'offline_images.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE images(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<OfflineImage>> getAllImages() async {
    final db = await database;
    final maps = await db.query('images', orderBy: 'id DESC');
    return maps.map(OfflineImage.fromMap).toList();
  }

  Future<void> insertImagePath(String imagePath) async {
    final db = await database;
    await db.insert('images', {'path': imagePath});
  }

  Future<String> saveFakeImageToFile() async {
    final databasePath = await getDatabasesPath();
    final folder = Directory(p.join(databasePath, 'offline_gallery'));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    String randomImageName = (_listOfFakeImages..shuffle()).first;

    final data = await rootBundle.load('assets/images/$randomImageName');
    final bytes = data.buffer.asUint8List();
    final filePath = p.join(
      folder.path,
      'img_${DateTime.now().millisecondsSinceEpoch}.png',
    );

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return filePath;
  }
}
