import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/assessment.dart';

void main() {
  group('Assessment', () {
    // ── constructor ─────────────────────────────────────────────────────────

    test('constructor sets all fields', () {
      final a = Assessment(name: 'Midterm', score: 78.5, weight: 30.0);
      expect(a.name, 'Midterm');
      expect(a.score, 78.5);
      expect(a.weight, 30.0);
    });

    // ── toJson ──────────────────────────────────────────────────────────────

    test('toJson contains name', () {
      final a = Assessment(name: 'Final', score: 90.0, weight: 50.0);
      expect(a.toJson()['name'], 'Final');
    });

    test('toJson contains score', () {
      final a = Assessment(name: 'Final', score: 90.0, weight: 50.0);
      expect(a.toJson()['score'], 90.0);
    });

    test('toJson contains weight', () {
      final a = Assessment(name: 'Final', score: 90.0, weight: 50.0);
      expect(a.toJson()['weight'], 50.0);
    });

    test('toJson produces map with exactly 3 keys', () {
      final a = Assessment(name: 'Quiz', score: 75.0, weight: 20.0);
      expect(a.toJson().keys, containsAll(['name', 'score', 'weight']));
      expect(a.toJson().length, 3);
    });

    // ── fromJson ────────────────────────────────────────────────────────────

    test('fromJson sets name', () {
      final a = Assessment.fromJson({'name': 'Assignment', 'score': 85.0, 'weight': 40.0});
      expect(a.name, 'Assignment');
    });

    test('fromJson sets score', () {
      final a = Assessment.fromJson({'name': 'Assignment', 'score': 85.0, 'weight': 40.0});
      expect(a.score, 85.0);
    });

    test('fromJson sets weight', () {
      final a = Assessment.fromJson({'name': 'Assignment', 'score': 85.0, 'weight': 40.0});
      expect(a.weight, 40.0);
    });

    test('fromJson handles int score (num cast)', () {
      final a = Assessment.fromJson({'name': 'Quiz', 'score': 80, 'weight': 25});
      expect(a.score, 80.0);
      expect(a.weight, 25.0);
    });

    // ── round-trip ──────────────────────────────────────────────────────────

    test('toJson then fromJson preserves name', () {
      final original = Assessment(name: 'Project', score: 92.5, weight: 25.0);
      final restored = Assessment.fromJson(original.toJson());
      expect(restored.name, original.name);
    });

    test('toJson then fromJson preserves score', () {
      final original = Assessment(name: 'Project', score: 92.5, weight: 25.0);
      final restored = Assessment.fromJson(original.toJson());
      expect(restored.score, closeTo(original.score, 0.0001));
    });

    test('toJson then fromJson preserves weight', () {
      final original = Assessment(name: 'Project', score: 92.5, weight: 25.0);
      final restored = Assessment.fromJson(original.toJson());
      expect(restored.weight, closeTo(original.weight, 0.0001));
    });

    // ── edge values ─────────────────────────────────────────────────────────

    test('score of 0 round-trips correctly', () {
      final a = Assessment(name: 'Zero', score: 0.0, weight: 100.0);
      final restored = Assessment.fromJson(a.toJson());
      expect(restored.score, 0.0);
    });

    test('score of 100 round-trips correctly', () {
      final a = Assessment(name: 'Perfect', score: 100.0, weight: 100.0);
      final restored = Assessment.fromJson(a.toJson());
      expect(restored.score, 100.0);
    });
  });
}
