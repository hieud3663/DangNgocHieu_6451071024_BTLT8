class Task {
  final int? id;
  final String title;
  final bool isDone;

  const Task({this.id, required this.title, this.isDone = false});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      isDone: (map['isDone'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isDone': isDone ? 1 : 0};
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] is int ? json['id'] as int : null,
      title: (json['title'] ?? '').toString(),
      isDone: json['isDone'] == true || json['isDone'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }

  Task copyWith({int? id, String? title, bool? isDone}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
