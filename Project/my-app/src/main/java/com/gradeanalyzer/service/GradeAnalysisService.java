package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;

import java.util.List;

/**
 * Provides advanced grade analysis and statistical features.
 */
public class GradeAnalysisService {

    private final GradeCalculator calculator;

    public GradeAnalysisService() {
        this.calculator = new GradeCalculator();
    }

    /**
     * Calculates the average score across all assessments.
     */
    public double calculateAverageScore(List<Assessment> assessments) {
        if (assessments == null || assessments.isEmpty()) {
            throw new IllegalArgumentException("Assessment list cannot be empty.");
        }

        double sum = 0;
        for (Assessment assessment : assessments) {
            sum += assessment.getScore();
        }

        return sum / assessments.size();
    }

    /**
     * Finds the highest assessment score.
     */
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

    /**
     * Finds the lowest assessment score.
     */
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

    /**
     * Provides feedback on which assessments to improve.
     */
    public String getPerformanceFeedback(List<Assessment> assessments) {
        double average = calculateAverageScore(assessments);
        double finalGrade = calculator.calculateFinalGrade(assessments);

        StringBuilder feedback = new StringBuilder();

        if (finalGrade >= 90) {
            feedback.append("Excellent performance! Keep up the outstanding work.");
        } else if (finalGrade >= 80) {
            feedback.append("Good performance. Continue with consistent effort.");
        } else if (finalGrade >= 70) {
            feedback.append("Satisfactory performance. Consider focusing on weaker areas.");
        } else if (finalGrade >= 60) {
            feedback.append("Needs improvement. Dedicate more effort to your studies.");
        } else {
            feedback.append("Poor performance. Seek additional help and resources.");
        }

        return feedback.toString();
    }
}