import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/assessment.dart';
import 'package:flutter_app/models/student.dart';

void main() {
  Assessment makeAssessment({
    String name = 'Final',
    double score = 85.0,
    double weight = 100.0,
  }) =>
      Assessment(name: name, score: score, weight: weight);

  group('Student', () {
    // ── constructor ─────────────────────────────────────────────────────────

    test('constructor sets id', () {
      final s = Student(id: '200001', name: 'Alice', assessments: []);
      expect(s.id, '200001');
    });

    test('constructor sets name', () {
      final s = Student(id: '200001', name: 'Alice', assessments: []);
      expect(s.name, 'Alice');
    });

    test('constructor sets assessments list', () {
      final a = makeAssessment();
      final s = Student(id: '200001', name: 'Alice', assessments: [a]);
      expect(s.assessments.length, 1);
      expect(s.assessments.first.name, 'Final');
    });

    test('constructor with empty assessments list', () {
      final s = Student(id: '1', name: 'Bob', assessments: []);
      expect(s.assessments, isEmpty);
    });

    // ── toJson ──────────────────────────────────────────────────────────────

    test('toJson contains id', () {
      final s = Student(id: '200001', name: 'Alice', assessments: []);
      expect(s.toJson()['id'], '200001');
    });

    test('toJson contains name', () {
      final s = Student(id: '200001', name: 'Alice', assessments: []);
      expect(s.toJson()['name'], 'Alice');
    });

    test('toJson contains assessments list', () {
      final s = Student(id: '200001', name: 'Alice', assessments: [makeAssessment()]);
      final json = s.toJson();
      expect(json['assessments'], isA<List>());
      expect((json['assessments'] as List).length, 1);
    });

    test('toJson assessments are serialized as maps', () {
      final s = Student(
        id: '200001',
        name: 'Alice',
        assessments: [makeAssessment(name: 'Midterm', score: 78, weight: 100)],
      );
      final assessmentJson = (s.toJson()['assessments'] as List).first as Map;
      expect(assessmentJson['name'], 'Midterm');
      expect(assessmentJson['score'], 78.0);
    });

    test('toJson with no assessments has empty list', () {
      final s = Student(id: '1', name: 'Bob', assessments: []);
      expect((s.toJson()['assessments'] as List), isEmpty);
    });

    // ── fromJson ────────────────────────────────────────────────────────────

    test('fromJson sets id', () {
      final s = Student.fromJson({'id': '200002', 'name': 'Bob', 'assessments': []});
      expect(s.id, '200002');
    });

    test('fromJson sets name', () {
      final s = Student.fromJson({'id': '200002', 'name': 'Bob', 'assessments': []});
      expect(s.name, 'Bob');
    });

    test('fromJson with empty assessments produces empty list', () {
      final s = Student.fromJson({'id': '200002', 'name': 'Bob', 'assessments': []});
      expect(s.assessments, isEmpty);
    });

    test('fromJson deserializes assessments', () {
      final json = {
        'id': '200003',
        'name': 'Carol',
        'assessments': [
          {'name': 'Final', 'score': 90.0, 'weight': 100.0},
        ],
      };
      final s = Student.fromJson(json);
      expect(s.assessments.length, 1);
      expect(s.assessments.first.name, 'Final');
      expect(s.assessments.first.score, 90.0);
    });

    test('fromJson deserializes multiple assessments', () {
      final json = {
        'id': '200003',
        'name': 'Carol',
        'assessments': [
          {'name': 'Assignment', 'score': 80.0, 'weight': 30.0},
          {'name': 'Midterm', 'score': 75.0, 'weight': 30.0},
          {'name': 'Final', 'score': 90.0, 'weight': 40.0},
        ],
      };
      final s = Student.fromJson(json);
      expect(s.assessments.length, 3);
    });

    // ── round-trip ──────────────────────────────────────────────────────────

    test('toJson then fromJson preserves id', () {
      final original = Student(
        id: '200004',
        name: 'Dave',
        assessments: [makeAssessment(name: 'Quiz', score: 72, weight: 100)],
      );
      final restored = Student.fromJson(original.toJson());
      expect(restored.id, original.id);
    });

    test('toJson then fromJson preserves name', () {
      final original = Student(id: '200004', name: 'Dave', assessments: []);
      final restored = Student.fromJson(original.toJson());
      expect(restored.name, original.name);
    });

    test('toJson then fromJson preserves assessment count', () {
      final original = Student(
        id: '200004',
        name: 'Dave',
        assessments: [
          makeAssessment(name: 'A', score: 80, weight: 50),
          makeAssessment(name: 'B', score: 90, weight: 50),
        ],
      );
      final restored = Student.fromJson(original.toJson());
      expect(restored.assessments.length, original.assessments.length);
    });

    test('toJson then fromJson preserves assessment scores', () {
      final original = Student(
        id: '200004',
        name: 'Dave',
        assessments: [makeAssessment(name: 'Final', score: 88.5, weight: 100)],
      );
      final restored = Student.fromJson(original.toJson());
      expect(restored.assessments.first.score, closeTo(88.5, 0.0001));
    });
  });
}
