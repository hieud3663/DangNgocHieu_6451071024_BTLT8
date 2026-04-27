import 'package:flutter/foundation.dart';

import '../data/models/course.dart';
import '../data/models/student.dart';
import '../data/repositories/student_course_repository.dart';

class StudentCourseController extends ChangeNotifier {
  final StudentCourseRepository _repository;

  StudentCourseController({StudentCourseRepository? repository})
    : _repository = repository ?? StudentCourseRepository();

  List<Student> _students = [];
  List<Course> _courses = [];
  Set<int> _enrolledCourseIds = <int>{};
  int? _selectedStudentId;
  bool _isLoading = false;

  List<Student> get students => _students;
  List<Course> get courses => _courses;
  Set<int> get enrolledCourseIds => _enrolledCourseIds;
  int? get selectedStudentId => _selectedStudentId;
  bool get isLoading => _isLoading;

  List<Course> get selectedStudentCourses {
    return _courses
        .where((course) => _enrolledCourseIds.contains(course.id))
        .toList();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    _students = await _repository.getStudents();
    _courses = await _repository.getCourses();

    if (_students.isNotEmpty) {
      _selectedStudentId ??= _students.first.id;
      final ids = await _repository.getEnrollmentCourseIds(_selectedStudentId!);
      _enrolledCourseIds = ids.toSet();
    } else {
      _selectedStudentId = null;
      _enrolledCourseIds = <int>{};
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addStudent(String name) async {
    await _repository.addStudent(name);
    await loadInitialData();
  }

  Future<void> addCourse(String name) async {
    await _repository.addCourse(name);
    await loadInitialData();
  }

  Future<void> selectStudent(int studentId) async {
    _selectedStudentId = studentId;
    final ids = await _repository.getEnrollmentCourseIds(studentId);
    _enrolledCourseIds = ids.toSet();
    notifyListeners();
  }

  Future<void> toggleEnrollment(int courseId, bool checked) async {
    final studentId = _selectedStudentId;
    if (studentId == null) return;

    await _repository.setEnrollment(
      studentId: studentId,
      courseId: courseId,
      checked: checked,
    );

    final ids = await _repository.getEnrollmentCourseIds(studentId);
    _enrolledCourseIds = ids.toSet();
    notifyListeners();
  }
}
