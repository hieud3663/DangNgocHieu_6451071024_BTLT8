class OfflineImage {
  final int? id;
  final String path;

  const OfflineImage({this.id, required this.path});

  factory OfflineImage.fromMap(Map<String, dynamic> map) {
    return OfflineImage(id: map['id'] as int?, path: map['path'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'path': path};
  }
}
