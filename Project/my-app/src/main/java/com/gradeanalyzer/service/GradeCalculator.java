package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;

import java.util.List;

/**
 * Calculates final grades and assigns letter grades.
 */
public class GradeCalculator {

    private final GradeValidator validator;

    public GradeCalculator() {
        this.validator = new GradeValidator();
    }

    public double calculateFinalGrade(List<Assessment> assessments) {
        if (!validator.hasAssessments(assessments)) {
            throw new IllegalArgumentException("Assessment list cannot be empty.");
        }

        if (!validator.allScoresValid(assessments)) {
            throw new IllegalArgumentException("One or more scores are invalid.");
        }

        if (!validator.allWeightsValid(assessments)) {
            throw new IllegalArgumentException("One or more weights are invalid.");
        }

        if (!validator.totalWeightIs100(assessments)) {
            throw new IllegalArgumentException("Total weight must equal 100.");
        }

        double finalGrade = 0;

        for (Assessment assessment : assessments) {
            finalGrade += assessment.getScore() * (assessment.getWeight() / 100.0);
        }

        return finalGrade;
    }

    public String getLetterGrade(double finalGrade) {
        if (finalGrade < 0 || finalGrade > 100) {
            throw new IllegalArgumentException("Final grade must be between 0 and 100.");
        }

        if (finalGrade >= 90) {
            return "A+";
        } else if (finalGrade >= 80) {
            return "A";
        } else if (finalGrade >= 70) {
            return "B";
        } else if (finalGrade >= 60) {
            return "C";
        } else if (finalGrade >= 50) {
            return "D";
        } else {
            return "F";
        }
    }

    public String getStanding(double finalGrade) {
        if (finalGrade < 0 || finalGrade > 100) {
            throw new IllegalArgumentException("Final grade must be between 0 and 100.");
        }

        if (finalGrade < 50) {
            return "Fail";
        } else {
            return "Pass";
        }
    }
}