package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;

import java.util.List;

public class GradeAnalysisService {

    public double calculateAverageScore(List<Assessment> assessments) {
        if (assessments == null || assessments.isEmpty()) {
            throw new IllegalArgumentException("Assessment list cannot be empty.");
        }

        double sum = 0.0;
        for (Assessment assessment : assessments) {
            sum += assessment.getScore();
        }
        return sum / assessments.size();
    }

    public double getHighestScore(List<Assessment> assessments) {
        if (assessments == null || assessments.isEmpty()) {
            throw new IllegalArgumentException("Assessment list cannot be empty.");
        }

        double highest = assessments.get(0).getScore();
        for (Assessment assessment : assessments) {
            if (assessment.getScore() > highest) {
                highest = assessment.getScore();
            }
        }
        return highest;
    }

    public double getLowestScore(List<Assessment> assessments) {
        if (assessments == null || assessments.isEmpty()) {
            throw new IllegalArgumentException("Assessment list cannot be empty.");
        }

        double lowest = assessments.get(0).getScore();
        for (Assessment assessment : assessments) {
            if (assessment.getScore() < lowest) {
                lowest = assessment.getScore();
            }
        }
        return lowest;
    }

    public String getPerformanceFeedback(double finalGrade) {
        if (finalGrade >= 90) {
            return "Excellent performance! Keep up the outstanding work.";
        } else if (finalGrade >= 80) {
            return "Good performance. Continue with consistent effort.";
        } else if (finalGrade >= 70) {
            return "Satisfactory performance. Consider focusing on weaker areas.";
        } else if (finalGrade >= 60) {
            return "Needs improvement. Dedicate more effort to your studies.";
        } else {
            return "Poor performance. Seek additional help and resources.";
        }
    }
}
