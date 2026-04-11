import '../models/assessment.dart';

class GradeService {
  static void validateStudent(String id, String name, List<Assessment> assessments) {
    if (id.trim().isEmpty) {
      throw Exception('Student ID cannot be empty.');
    }
    if (name.trim().isEmpty) {
      throw Exception('Student name cannot be empty.');
    }
    if (assessments.isEmpty) {
      throw Exception('At least one assessment is required.');
    }

    double totalWeight = 0;
    for (final a in assessments) {
      if (a.name.trim().isEmpty) {
        throw Exception('Assessment name cannot be empty.');
      }
      if (a.score < 0 || a.score > 100) {
        throw Exception('Score must be between 0 and 100.');
      }
      if (a.weight <= 0 || a.weight > 100) {
        throw Exception('Weight must be between 1 and 100.');
      }
      totalWeight += a.weight;
    }

    if ((totalWeight - 100).abs() > 0.001) {
      throw Exception('Total weight must equal 100%.');
    }
  }

  static double calculateFinalGrade(List<Assessment> assessments) {
    double grade = 0;
    for (final a in assessments) {
      grade += a.score * (a.weight / 100);
    }
    return grade;
  }

  static String getLetterGrade(double grade) {
    if (grade >= 90) return 'A+';
    if (grade >= 85) return 'A';
    if (grade >= 80) return 'A-';
    if (grade >= 77) return 'B+';
    if (grade >= 73) return 'B';
    if (grade >= 70) return 'B-';
    if (grade >= 67) return 'C+';
    if (grade >= 63) return 'C';
    if (grade >= 60) return 'C-';
    if (grade >= 57) return 'D+';
    if (grade >= 53) return 'D';
    if (grade >= 50) return 'D-';
    return 'F';
  }

  static String getStanding(double grade) {
    return grade >= 50 ? 'Pass' : 'Fail';
  }

  static double getAverageScore(List<Assessment> assessments) {
    if (assessments.isEmpty) return 0;
    final sum = assessments.fold<double>(0, (p, a) => p + a.score);
    return sum / assessments.length;
  }

  static double getHighestScore(List<Assessment> assessments) {
    if (assessments.isEmpty) return 0;
    return assessments.map((a) => a.score).reduce((a, b) => a > b ? a : b);
  }

  static double getLowestScore(List<Assessment> assessments) {
    if (assessments.isEmpty) return 0;
    return assessments.map((a) => a.score).reduce((a, b) => a < b ? a : b);
  }

  static String getFeedback(double grade) {
    if (grade >= 90) return 'Excellent performance!';
    if (grade >= 80) return 'Good job, keep it up.';
    if (grade >= 70) return 'Decent, but there’s room to improve.';
    if (grade >= 60) return 'Needs improvement.';
    return 'At risk. Immediate action required.';
  }
}