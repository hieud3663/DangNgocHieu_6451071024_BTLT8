class ActivityLog {
  final int? id;
  final String action;
  final String time;

  const ActivityLog({this.id, required this.action, required this.time});

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'] as int?,
      action: map['action'] as String,
      time: map['time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'action': action, 'time': time};
  }
}
