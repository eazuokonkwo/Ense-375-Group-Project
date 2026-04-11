import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/assessment.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Student makeStudent({
    String id = '200001',
    String name = 'Alice',
    double score = 85.0,
    double weight = 100.0,
  }) =>
      Student(
        id: id,
        name: name,
        assessments: [Assessment(name: 'Final', score: score, weight: weight)],
      );

  group('StorageService', () {
    // ── getStudents ───────────────────────────────────────────────────────

    test('getStudents returns empty list when nothing saved', () async {
      final service = StorageService();
      final students = await service.getStudents();
      expect(students, isEmpty);
    });

    test('getStudents returns saved students', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent());
      final students = await service.getStudents();
      expect(students.length, 1);
    });

    test('getStudents returns all saved students', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', name: 'Alice'));
      await service.saveStudent(makeStudent(id: '200002', name: 'Bob'));
      final students = await service.getStudents();
      expect(students.length, 2);
    });

    // ── saveStudent ───────────────────────────────────────────────────────

    test('saveStudent persists student id', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001'));
      final students = await service.getStudents();
      expect(students.first.id, '200001');
    });

    test('saveStudent persists student name', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(name: 'Carol'));
      final students = await service.getStudents();
      expect(students.first.name, 'Carol');
    });

    test('saveStudent persists assessments', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(score: 92.0));
      final students = await service.getStudents();
      expect(students.first.assessments.first.score, closeTo(92.0, 0.0001));
    });

    test('saveStudent overwrites existing student with same id', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', name: 'Original'));
      await service.saveStudent(makeStudent(id: '200001', name: 'Updated'));
      final students = await service.getStudents();
      expect(students.length, 1);
      expect(students.first.name, 'Updated');
    });

    test('saveStudent preserves other students when updating', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', name: 'Alice'));
      await service.saveStudent(makeStudent(id: '200002', name: 'Bob'));
      await service.saveStudent(makeStudent(id: '200001', name: 'Alice Updated'));
      final students = await service.getStudents();
      expect(students.length, 2);
      expect(students.any((s) => s.id == '200002'), isTrue);
    });

    // ── deleteStudent ─────────────────────────────────────────────────────

    test('deleteStudent removes the student', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001'));
      await service.deleteStudent('200001');
      final students = await service.getStudents();
      expect(students, isEmpty);
    });

    test('deleteStudent only removes the target student', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', name: 'Alice'));
      await service.saveStudent(makeStudent(id: '200002', name: 'Bob'));
      await service.deleteStudent('200001');
      final students = await service.getStudents();
      expect(students.length, 1);
      expect(students.first.id, '200002');
    });

    test('deleteStudent on nonexistent id does not throw', () async {
      final service = StorageService();
      await expectLater(
        service.deleteStudent('DOESNOTEXIST'),
        completes,
      );
    });

    // ── getStudentById ────────────────────────────────────────────────────

    test('getStudentById returns matching student', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', name: 'Alice'));
      final student = await service.getStudentById('200001');
      expect(student, isNotNull);
      expect(student!.name, 'Alice');
    });

    test('getStudentById returns null when not found', () async {
      final service = StorageService();
      final student = await service.getStudentById('DOESNOTEXIST');
      expect(student, isNull);
    });

    test('getStudentById returns correct student among multiple', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', name: 'Alice'));
      await service.saveStudent(makeStudent(id: '200002', name: 'Bob'));
      final student = await service.getStudentById('200002');
      expect(student!.name, 'Bob');
    });

    test('getStudentById preserves assessment data', () async {
      final service = StorageService();
      await service.saveStudent(makeStudent(id: '200001', score: 77.5));
      final student = await service.getStudentById('200001');
      expect(student!.assessments.first.score, closeTo(77.5, 0.0001));
    });
  });
}
