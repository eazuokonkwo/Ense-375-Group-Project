package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;

import java.util.List;

/**
 * Handles all validation rules for grade inputs.
 */
public class GradeValidator {

    public boolean isValidScore(double score) {
        return score >= 0 && score <= 100;
    }

    public boolean isValidWeight(double weight) {
        return weight > 0 && weight <= 100;
    }

    public boolean hasAssessments(List<Assessment> assessments) {
        return assessments != null && !assessments.isEmpty();
    }

    public boolean totalWeightIs100(List<Assessment> assessments) {
        if (!hasAssessments(assessments)) {
            return false;
        }

        double total = 0;
        for (Assessment assessment : assessments) {
            total += assessment.getWeight();
        }

        return Math.abs(total - 100.0) < 0.0001;
    }

    public boolean allScoresValid(List<Assessment> assessments) {
        if (!hasAssessments(assessments)) {
            return false;
        }

        for (Assessment assessment : assessments) {
            if (!isValidScore(assessment.getScore())) {
                return false;
            }
        }
        return true;
    }

    public boolean allWeightsValid(List<Assessment> assessments) {
        if (!hasAssessments(assessments)) {
            return false;
        }

        for (Assessment assessment : assessments) {
            if (!isValidWeight(assessment.getWeight())) {
                return false;
            }
        }
        return true;
    }
}