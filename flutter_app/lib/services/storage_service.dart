import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';

class StorageService {
  static const _key = 'students';

  Future<List<Student>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => Student.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveStudent(Student student) async {
    final students = await getStudents();
    students.removeWhere((s) => s.id == student.id);
    students.add(student);
    await _write(students);
  }

  Future<void> deleteStudent(String id) async {
    final students = await getStudents();
    students.removeWhere((s) => s.id == id);
    await _write(students);
  }

  Future<Student?> getStudentById(String id) async {
    final students = await getStudents();
    try {
      return students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _write(List<Student> students) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(students.map((s) => s.toJson()).toList()),
    );
  }
}