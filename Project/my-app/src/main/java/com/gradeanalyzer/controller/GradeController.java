package com.gradeanalyzer.controller;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.service.GradeCalculator;

import java.util.List;

/**
 * Connects the model and service layers.
 */
public class GradeController {

    private final GradeCalculator calculator;

    public GradeController() {
        this.calculator = new GradeCalculator();
    }

    public double calculateStudentFinalGrade(Student student) {
        List<Assessment> assessments = student.getAssessments();
        return calculator.calculateFinalGrade(assessments);
    }

    public String getStudentLetterGrade(Student student) {
        double finalGrade = calculateStudentFinalGrade(student);
        return calculator.getLetterGrade(finalGrade);
    }

    public String getStudentStanding(Student student) {
        double finalGrade = calculateStudentFinalGrade(student);
        return calculator.getStanding(finalGrade);
    }
}