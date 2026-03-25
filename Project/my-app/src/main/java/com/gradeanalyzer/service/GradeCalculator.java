package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;

import java.util.List;

public class GradeCalculator {

    public double calculateFinalGrade(List<Assessment> assessments) {
        double finalGrade = 0.0;

        for (Assessment assessment : assessments) {
            finalGrade += assessment.getScore() * (assessment.getWeight() / 100.0);
        }

        return finalGrade;
    }

    public String getLetterGrade(double finalGrade) {
        if (finalGrade >= 90) return "A+";
        if (finalGrade >= 85) return "A";
        if (finalGrade >= 80) return "A-";
        if (finalGrade >= 77) return "B+";
        if (finalGrade >= 73) return "B";
        if (finalGrade >= 70) return "B-";
        if (finalGrade >= 67) return "C+";
        if (finalGrade >= 63) return "C";
        if (finalGrade >= 60) return "C-";
        if (finalGrade >= 57) return "D+";
        if (finalGrade >= 53) return "D";
        if (finalGrade >= 50) return "D-";
        return "F";
    }

    public String getStanding(double finalGrade) {
        return finalGrade >= 50 ? "Pass" : "Fail";
    }
}
