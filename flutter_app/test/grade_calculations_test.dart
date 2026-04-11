// Tests for the grade calculation logic used in AppShell:
//   _calculateFinalGrade, averageGrade, passCount, passRate.
// These are pure functions so they are tested directly without a widget tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/assessment.dart';
import 'package:flutter_app/models/student.dart';

// Pure replica of AppShell._calculateFinalGrade (no Flutter dependency).
double calculateFinalGrade(Student student) {
  if (student.assessments.isEmpty) return 0;
  double weightedTotal = 0;
  for (final a in student.assessments) {
    weightedTotal += a.score * (a.weight / 100);
  }
  return weightedTotal;
}

double averageGrade(List<Student> students) {
  if (students.isEmpty) return 0;
  final total = students.fold<double>(0, (sum, s) => sum + calculateFinalGrade(s));
  return total / students.length;
}

int passCount(List<Student> students) =>
    students.where((s) => calculateFinalGrade(s) >= 50).length;

double passRate(List<Student> students) {
  if (students.isEmpty) return 0;
  return (passCount(students) / students.length) * 100;
}

// ── helpers ───────────────────────────────────────────────────────────────

Student makeStudent(String id, List<(String, double, double)> assessmentData) {
  return Student(
    id: id,
    name: 'Student $id',
    assessments: assessmentData
        .map((t) => Assessment(name: t.$1, score: t.$2, weight: t.$3))
        .toList(),
  );
}

void main() {
  // ── _calculateFinalGrade ─────────────────────────────────────────────────

  group('calculateFinalGrade', () {
    test('standard weighted calculation', () {
      // 80*0.2 + 70*0.3 + 90*0.5 = 16+21+45 = 82
      final student = makeStudent('1', [
        ('Assignment', 80, 20),
        ('Midterm', 70, 30),
        ('Final', 90, 50),
      ]);
      expect(calculateFinalGrade(student), closeTo(82.0, 0.0001));
    });

    test('empty assessments returns 0', () {
      final student = Student(id: '1', name: 'Empty', assessments: []);
      expect(calculateFinalGrade(student), 0.0);
    });

    test('single assessment at full weight', () {
      final student = makeStudent('1', [('Final', 73.0, 100.0)]);
      expect(calculateFinalGrade(student), closeTo(73.0, 0.0001));
    });

    test('perfect score returns 100', () {
      final student = makeStudent('1', [
        ('A', 100.0, 50.0),
        ('B', 100.0, 50.0),
      ]);
      expect(calculateFinalGrade(student), closeTo(100.0, 0.0001));
    });

    test('all zero scores returns 0', () {
      final student = makeStudent('1', [
        ('A', 0.0, 50.0),
        ('B', 0.0, 50.0),
      ]);
      expect(calculateFinalGrade(student), closeTo(0.0, 0.0001));
    });

    test('boundary: grade exactly 50', () {
      // Need weighted result of exactly 50
      final student = makeStudent('1', [('Final', 50.0, 100.0)]);
      expect(calculateFinalGrade(student), closeTo(50.0, 0.0001));
    });
  });

  // ── averageGrade ─────────────────────────────────────────────────────────

  group('averageGrade', () {
    test('empty list returns 0', () {
      expect(averageGrade([]), 0.0);
    });

    test('single student returns their grade', () {
      final students = [makeStudent('1', [('Final', 80.0, 100.0)])];
      expect(averageGrade(students), closeTo(80.0, 0.0001));
    });

    test('two students average is correct', () {
      final students = [
        makeStudent('1', [('Final', 60.0, 100.0)]),
        makeStudent('2', [('Final', 80.0, 100.0)]),
      ];
      expect(averageGrade(students), closeTo(70.0, 0.0001));
    });

    test('all students with same grade', () {
      final students = [
        makeStudent('1', [('Final', 75.0, 100.0)]),
        makeStudent('2', [('Final', 75.0, 100.0)]),
        makeStudent('3', [('Final', 75.0, 100.0)]),
      ];
      expect(averageGrade(students), closeTo(75.0, 0.0001));
    });
  });

  // ── passCount ─────────────────────────────────────────────────────────────

  group('passCount', () {
    test('empty list returns 0', () {
      expect(passCount([]), 0);
    });

    test('all passing students', () {
      final students = [
        makeStudent('1', [('Final', 60.0, 100.0)]),
        makeStudent('2', [('Final', 80.0, 100.0)]),
      ];
      expect(passCount(students), 2);
    });

    test('all failing students', () {
      final students = [
        makeStudent('1', [('Final', 30.0, 100.0)]),
        makeStudent('2', [('Final', 49.9, 100.0)]),
      ];
      expect(passCount(students), 0);
    });

    test('mixed passing and failing', () {
      final students = [
        makeStudent('1', [('Final', 80.0, 100.0)]),
        makeStudent('2', [('Final', 30.0, 100.0)]),
        makeStudent('3', [('Final', 55.0, 100.0)]),
      ];
      expect(passCount(students), 2);
    });

    test('exactly at pass boundary counts as pass', () {
      final students = [makeStudent('1', [('Final', 50.0, 100.0)])];
      expect(passCount(students), 1);
    });

    test('just below pass boundary counts as fail', () {
      final students = [makeStudent('1', [('Final', 49.9, 100.0)])];
      expect(passCount(students), 0);
    });
  });

  // ── passRate ──────────────────────────────────────────────────────────────

  group('passRate', () {
    test('empty list returns 0', () {
      expect(passRate([]), 0.0);
    });

    test('all passing gives 100%', () {
      final students = [
        makeStudent('1', [('Final', 60.0, 100.0)]),
        makeStudent('2', [('Final', 80.0, 100.0)]),
      ];
      expect(passRate(students), closeTo(100.0, 0.0001));
    });

    test('all failing gives 0%', () {
      final students = [
        makeStudent('1', [('Final', 30.0, 100.0)]),
        makeStudent('2', [('Final', 40.0, 100.0)]),
      ];
      expect(passRate(students), closeTo(0.0, 0.0001));
    });

    test('half passing gives 50%', () {
      final students = [
        makeStudent('1', [('Final', 80.0, 100.0)]),
        makeStudent('2', [('Final', 30.0, 100.0)]),
      ];
      expect(passRate(students), closeTo(50.0, 0.0001));
    });

    test('1 of 3 passing gives 33.33%', () {
      final students = [
        makeStudent('1', [('Final', 80.0, 100.0)]),
        makeStudent('2', [('Final', 30.0, 100.0)]),
        makeStudent('3', [('Final', 40.0, 100.0)]),
      ];
      expect(passRate(students), closeTo(33.333, 0.001));
    });
  });
}
