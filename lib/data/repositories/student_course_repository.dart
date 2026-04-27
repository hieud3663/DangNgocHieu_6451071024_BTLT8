import 'package:flutter_baitap_chuong11/data/services/student_course_db_service.dart';
import 'package:flutter_baitap_chuong11/data/models/student.dart';
import 'package:flutter_baitap_chuong11/data/models/course.dart';

class StudentCourseRepository {
  final StudentCourseDbService _dbService;

  StudentCourseRepository({StudentCourseDbService? dbService})
    : _dbService = dbService ?? StudentCourseDbService.instance;

  Future<void> addStudent(String name) async {
    if (name.trim().isEmpty) return;
    await _dbService.insertStudent(name);
  }

  Future<void> addCourse(String name) async {
    if (name.trim().isEmpty) return;
    await _dbService.insertCourse(name);
  }

  Future<List<Student>> getStudents() {
    return _dbService.getAllStudents();
  }

  Future<List<Course>> getCourses() {
    return _dbService.getAllCourses();
  }

  Future<void> setEnrollment({
    required int studentId,
    required int courseId,
    required bool checked,
  }) async {
    if (checked) {
      await _dbService.enrollStudentInCourse(studentId, courseId);
    } else {
      await _dbService.unenrollStudentFromCourse(studentId, courseId);
    }
  }

  Future<List<Course>> getCoursesByStudent(int studentId) {
    return _dbService.getCoursesByStudent(studentId);
  }

  Future<List<int>> getEnrollmentCourseIds(int studentId) {
    return _dbService.getEnrollmentCourseIds(studentId);
  }
}
