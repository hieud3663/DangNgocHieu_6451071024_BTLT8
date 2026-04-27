import 'package:flutter/material.dart';

import '../../controllers/student_course_controller.dart';
import '../../data/models/student.dart';

class StudentCourseView extends StatefulWidget {
  const StudentCourseView({super.key});

  @override
  State<StudentCourseView> createState() => _StudentCourseViewState();
}

class _StudentCourseViewState extends State<StudentCourseView> {
  late final StudentCourseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StudentCourseController();
    _controller.addListener(_onChanged);
    _controller.loadInitialData();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog({
    required String title,
    required bool student,
  }) async {
    String value = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          onChanged: (text) => value = text,
          decoration: InputDecoration(
            labelText: student ? 'Tên sinh viên' : 'Tên môn học',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, value),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;

    if (student) {
      await _controller.addStudent(result);
    } else {
      await _controller.addCourse(result);
    }
  }

  Widget _buildStudentItem(Student student) {
    final selected = _controller.selectedStudentId == student.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        selected: selected,
        selectedTileColor: Colors.teal.withValues(alpha: 0.10),
        title: Text(student.name),
        onTap: () => _controller.selectStudent(student.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedStudentId = _controller.selectedStudentId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 7 - Sinh viên và môn học'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddDialog(
                            title: 'Thêm sinh viên',
                            student: true,
                          ),
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Thêm sinh viên'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddDialog(
                            title: 'Thêm môn học',
                            student: false,
                          ),
                          icon: const Icon(Icons.library_add),
                          label: const Text('Thêm môn học'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Danh sách sinh viên',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: _controller.students.isEmpty
                                  ? const Center(
                                      child: Text('Chưa có sinh viên nào'),
                                    )
                                  : ListView.builder(
                                      itemCount: _controller.students.length,
                                      itemBuilder: (context, index) {
                                        return _buildStudentItem(
                                          _controller.students[index],
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8, top: 8),
                              child: Text(
                                'Đăng ký môn học',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: selectedStudentId == null
                                  ? const Center(
                                      child: Text(
                                        'Vui lòng thêm và chọn sinh viên',
                                      ),
                                    )
                                  : _controller.courses.isEmpty
                                  ? const Center(
                                      child: Text('Chưa có môn học nào'),
                                    )
                                  : ListView.builder(
                                      itemCount: _controller.courses.length,
                                      itemBuilder: (context, index) {
                                        final course =
                                            _controller.courses[index];
                                        final checked = _controller
                                            .enrolledCourseIds
                                            .contains(course.id);

                                        return CheckboxListTile(
                                          value: checked,
                                          onChanged: (value) {
                                            _controller.toggleEnrollment(
                                              course.id,
                                              value ?? false,
                                            );
                                          },
                                          title: Text(course.name),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey.shade100,
                  child: Text(
                    selectedStudentId == null
                        ? 'Môn đã đăng ký: chưa có'
                        : 'Môn đã đăng ký: ${_controller.selectedStudentCourses.map((e) => e.name).join(', ')}',
                  ),
                ),
              ],
            ),
    );
  }
}
