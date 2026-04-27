class Enrollment {
  final int id;
  final int studentId;
  final int courseId;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['id'] as int,
      studentId: map['studentId'] as int,
      courseId: map['courseId'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'studentId': studentId, 'courseId': courseId};
  }
}