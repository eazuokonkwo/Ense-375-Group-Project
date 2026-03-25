package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;

import java.util.List;

public class GradeValidator {

    public void validateStudentId(String id) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Student ID cannot be empty.");
        }
    }

    public void validateStudentName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Student name cannot be empty.");
        }
    }

    public void validateAssessment(Assessment assessment) {
        if (assessment == null) {
            throw new IllegalArgumentException("Assessment cannot be null.");
        }

        if (assessment.getName() == null || assessment.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Assessment name cannot be empty.");
        }

        if (assessment.getScore() < 0 || assessment.getScore() > 100) {
            throw new IllegalArgumentException("Assessment score must be between 0 and 100.");
        }

        if (assessment.getWeight() <= 0 || assessment.getWeight() > 100) {
            throw new IllegalArgumentException("Assessment weight must be greater than 0 and at most 100.");
        }
    }

    public void validateAssessmentList(List<Assessment> assessments) {
        if (assessments == null || assessments.isEmpty()) {
            throw new IllegalArgumentException("Assessment list cannot be empty.");
        }

        double totalWeight = 0.0;
        for (Assessment assessment : assessments) {
            validateAssessment(assessment);
            totalWeight += assessment.getWeight();
        }

        if (Math.abs(totalWeight - 100.0) > 0.0001) {
            throw new IllegalArgumentException("Total assessment weight must equal 100%.");
        }
    }
}
