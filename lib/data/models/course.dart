import 'package:flutter/foundation.dart';

class Course {
  final int id;
  final String name;

  const Course({
    required this.id,
    required this.name,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int,
      name: (map['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}