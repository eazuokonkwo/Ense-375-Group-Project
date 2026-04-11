import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/assessment.dart';
import 'package:flutter_app/services/grade_service.dart';

void main() {
  // ── helpers ──────────────────────────────────────────────────────────────

  List<Assessment> makeAssessments({
    double score1 = 80,
    double weight1 = 20,
    double score2 = 70,
    double weight2 = 30,
    double score3 = 90,
    double weight3 = 50,
  }) =>
      [
        Assessment(name: 'Assignment', score: score1, weight: weight1),
        Assessment(name: 'Midterm', score: score2, weight: weight2),
        Assessment(name: 'Final', score: score3, weight: weight3),
      ];

  // ── validateStudent ───────────────────────────────────────────────────────

  group('GradeService.validateStudent', () {
    test('passes with valid input', () {
      expect(
        () => GradeService.validateStudent('200001', 'Alice', makeAssessments()),
        returnsNormally,
      );
    });

    test('throws when ID is empty', () {
      expect(
        () => GradeService.validateStudent('', 'Alice', makeAssessments()),
        throwsException,
      );
    });

    test('throws when ID is whitespace', () {
      expect(
        () => GradeService.validateStudent('   ', 'Alice', makeAssessments()),
        throwsException,
      );
    });

    test('throws when name is empty', () {
      expect(
        () => GradeService.validateStudent('200001', '', makeAssessments()),
        throwsException,
      );
    });

    test('throws when assessments list is empty', () {
      expect(
        () => GradeService.validateStudent('200001', 'Alice', []),
        throwsException,
      );
    });

    test('throws when assessment name is empty', () {
      final assessments = [Assessment(name: '', score: 80, weight: 100)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        throwsException,
      );
    });

    test('throws when score is below 0', () {
      final assessments = [Assessment(name: 'Quiz', score: -1, weight: 100)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        throwsException,
      );
    });

    test('throws when score is above 100', () {
      final assessments = [Assessment(name: 'Quiz', score: 101, weight: 100)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        throwsException,
      );
    });

    test('passes when score is exactly 0', () {
      final assessments = [Assessment(name: 'Quiz', score: 0, weight: 100)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        returnsNormally,
      );
    });

    test('passes when score is exactly 100', () {
      final assessments = [Assessment(name: 'Quiz', score: 100, weight: 100)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        returnsNormally,
      );
    });

    test('throws when weight is 0', () {
      final assessments = [Assessment(name: 'Quiz', score: 80, weight: 0)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        throwsException,
      );
    });

    test('throws when weight is above 100', () {
      final assessments = [Assessment(name: 'Quiz', score: 80, weight: 101)];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        throwsException,
      );
    });

    test('throws when total weight does not equal 100', () {
      final assessments = [
        Assessment(name: 'A', score: 80, weight: 50),
        Assessment(name: 'B', score: 80, weight: 30),
      ];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        throwsException,
      );
    });

    test('passes when total weight equals exactly 100', () {
      final assessments = [
        Assessment(name: 'A', score: 80, weight: 60),
        Assessment(name: 'B', score: 70, weight: 40),
      ];
      expect(
        () => GradeService.validateStudent('200001', 'Alice', assessments),
        returnsNormally,
      );
    });
  });

  // ── calculateFinalGrade ───────────────────────────────────────────────────

  group('GradeService.calculateFinalGrade', () {
    test('calculates weighted average correctly', () {
      // 80*0.2 + 70*0.3 + 90*0.5 = 16 + 21 + 45 = 82
      expect(
        GradeService.calculateFinalGrade(makeAssessments()),
        closeTo(82.0, 0.0001),
      );
    });

    test('single assessment at full weight', () {
      final assessments = [Assessment(name: 'Final', score: 75.0, weight: 100)];
      expect(GradeService.calculateFinalGrade(assessments), closeTo(75.0, 0.0001));
    });

    test('perfect score returns 100', () {
      final assessments = [
        Assessment(name: 'A', score: 100, weight: 50),
        Assessment(name: 'B', score: 100, weight: 50),
      ];
      expect(GradeService.calculateFinalGrade(assessments), closeTo(100.0, 0.0001));
    });

    test('zero score returns 0', () {
      final assessments = [
        Assessment(name: 'A', score: 0, weight: 50),
        Assessment(name: 'B', score: 0, weight: 50),
      ];
      expect(GradeService.calculateFinalGrade(assessments), closeTo(0.0, 0.0001));
    });

    test('empty list returns 0', () {
      expect(GradeService.calculateFinalGrade([]), closeTo(0.0, 0.0001));
    });
  });

  // ── getLetterGrade — all 13 grades ───────────────────────────────────────

  group('GradeService.getLetterGrade', () {
    test('A+ for >= 90', () => expect(GradeService.getLetterGrade(90), 'A+'));
    test('A+ for 100', () => expect(GradeService.getLetterGrade(100), 'A+'));
    test('A for >= 85', () => expect(GradeService.getLetterGrade(85), 'A'));
    test('A for 89.9', () => expect(GradeService.getLetterGrade(89.9), 'A'));
    test('A- for >= 80', () => expect(GradeService.getLetterGrade(80), 'A-'));
    test('A- for 84.9', () => expect(GradeService.getLetterGrade(84.9), 'A-'));
    test('B+ for >= 77', () => expect(GradeService.getLetterGrade(77), 'B+'));
    test('B+ for 79.9', () => expect(GradeService.getLetterGrade(79.9), 'B+'));
    test('B for >= 73', () => expect(GradeService.getLetterGrade(73), 'B'));
    test('B for 76.9', () => expect(GradeService.getLetterGrade(76.9), 'B'));
    test('B- for >= 70', () => expect(GradeService.getLetterGrade(70), 'B-'));
    test('B- for 72.9', () => expect(GradeService.getLetterGrade(72.9), 'B-'));
    test('C+ for >= 67', () => expect(GradeService.getLetterGrade(67), 'C+'));
    test('C+ for 69.9', () => expect(GradeService.getLetterGrade(69.9), 'C+'));
    test('C for >= 63', () => expect(GradeService.getLetterGrade(63), 'C'));
    test('C for 66.9', () => expect(GradeService.getLetterGrade(66.9), 'C'));
    test('C- for >= 60', () => expect(GradeService.getLetterGrade(60), 'C-'));
    test('C- for 62.9', () => expect(GradeService.getLetterGrade(62.9), 'C-'));
    test('D+ for >= 57', () => expect(GradeService.getLetterGrade(57), 'D+'));
    test('D+ for 59.9', () => expect(GradeService.getLetterGrade(59.9), 'D+'));
    test('D for >= 53', () => expect(GradeService.getLetterGrade(53), 'D'));
    test('D for 56.9', () => expect(GradeService.getLetterGrade(56.9), 'D'));
    test('D- for >= 50', () => expect(GradeService.getLetterGrade(50), 'D-'));
    test('D- for 52.9', () => expect(GradeService.getLetterGrade(52.9), 'D-'));
    test('F for < 50', () => expect(GradeService.getLetterGrade(49.9), 'F'));
    test('F for 0', () => expect(GradeService.getLetterGrade(0), 'F'));
  });

  // ── getStanding ───────────────────────────────────────────────────────────

  group('GradeService.getStanding', () {
    test('Pass for exactly 50', () => expect(GradeService.getStanding(50), 'Pass'));
    test('Pass for above 50', () => expect(GradeService.getStanding(75), 'Pass'));
    test('Pass for 100', () => expect(GradeService.getStanding(100), 'Pass'));
    test('Fail for 49.9', () => expect(GradeService.getStanding(49.9), 'Fail'));
    test('Fail for 0', () => expect(GradeService.getStanding(0), 'Fail'));
  });

  // ── getAverageScore ───────────────────────────────────────────────────────

  group('GradeService.getAverageScore', () {
    test('calculates average correctly', () {
      final assessments = [
        Assessment(name: 'A', score: 90, weight: 33),
        Assessment(name: 'B', score: 80, weight: 33),
        Assessment(name: 'C', score: 70, weight: 34),
      ];
      expect(GradeService.getAverageScore(assessments), closeTo(80.0, 0.0001));
    });

    test('single assessment returns its score', () {
      final assessments = [Assessment(name: 'Only', score: 65, weight: 100)];
      expect(GradeService.getAverageScore(assessments), closeTo(65.0, 0.0001));
    });

    test('empty list returns 0', () {
      expect(GradeService.getAverageScore([]), closeTo(0.0, 0.0001));
    });
  });

  // ── getHighestScore ───────────────────────────────────────────────────────

  group('GradeService.getHighestScore', () {
    test('returns highest score', () {
      expect(GradeService.getHighestScore(makeAssessments()), closeTo(90.0, 0.0001));
    });

    test('single assessment returns its score', () {
      final assessments = [Assessment(name: 'Only', score: 77, weight: 100)];
      expect(GradeService.getHighestScore(assessments), closeTo(77.0, 0.0001));
    });

    test('empty list returns 0', () {
      expect(GradeService.getHighestScore([]), closeTo(0.0, 0.0001));
    });
  });

  // ── getLowestScore ────────────────────────────────────────────────────────

  group('GradeService.getLowestScore', () {
    test('returns lowest score', () {
      expect(GradeService.getLowestScore(makeAssessments()), closeTo(70.0, 0.0001));
    });

    test('single assessment returns its score', () {
      final assessments = [Assessment(name: 'Only', score: 42, weight: 100)];
      expect(GradeService.getLowestScore(assessments), closeTo(42.0, 0.0001));
    });

    test('empty list returns 0', () {
      expect(GradeService.getLowestScore([]), closeTo(0.0, 0.0001));
    });
  });

  // ── getFeedback — all 5 tiers ─────────────────────────────────────────────

  group('GradeService.getFeedback', () {
    test('Excellent for >= 90', () {
      expect(GradeService.getFeedback(90), 'Excellent performance!');
      expect(GradeService.getFeedback(100), 'Excellent performance!');
    });

    test('Good for >= 80 and < 90', () {
      expect(GradeService.getFeedback(80), 'Good job, keep it up.');
      expect(GradeService.getFeedback(89.9), 'Good job, keep it up.');
    });

    test('Decent for >= 70 and < 80', () {
      expect(GradeService.getFeedback(70), contains('room to improve'));
      expect(GradeService.getFeedback(79.9), contains('room to improve'));
    });

    test('Needs improvement for >= 60 and < 70', () {
      expect(GradeService.getFeedback(60), 'Needs improvement.');
      expect(GradeService.getFeedback(69.9), 'Needs improvement.');
    });

    test('At risk for < 60', () {
      expect(GradeService.getFeedback(59.9), contains('At risk'));
      expect(GradeService.getFeedback(0), contains('At risk'));
    });
  });
}
