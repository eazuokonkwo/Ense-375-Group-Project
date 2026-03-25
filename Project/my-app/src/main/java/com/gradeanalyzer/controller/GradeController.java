package com.gradeanalyzer.controller;

import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.service.DataPersistenceService;
import com.gradeanalyzer.service.GradeAnalysisService;
import com.gradeanalyzer.service.GradeCalculator;
import com.gradeanalyzer.service.GradeValidator;

import java.io.IOException;
import java.util.List;

public class GradeController {
    private final GradeValidator validator;
    private final GradeCalculator calculator;
    private final GradeAnalysisService analysisService;
    private final DataPersistenceService persistenceService;

    public GradeController() {
        this.validator = new GradeValidator();
        this.calculator = new GradeCalculator();
        this.analysisService = new GradeAnalysisService();
        this.persistenceService = new DataPersistenceService();
    }

    public void validateStudent(Student student) {
        validator.validateStudentId(student.getId());
        validator.validateStudentName(student.getName());
        validator.validateAssessmentList(student.getAssessments());
    }

    public double calculateFinalGrade(Student student) {
        return calculator.calculateFinalGrade(student.getAssessments());
    }

    public String getLetterGrade(Student student) {
        return calculator.getLetterGrade(calculateFinalGrade(student));
    }

    public String getStanding(Student student) {
        return calculator.getStanding(calculateFinalGrade(student));
    }

    public double getAverageScore(Student student) {
        return analysisService.calculateAverageScore(student.getAssessments());
    }

    public double getHighestScore(Student student) {
        return analysisService.getHighestScore(student.getAssessments());
    }

    public double getLowestScore(Student student) {
        return analysisService.getLowestScore(student.getAssessments());
    }

    public String getFeedback(Student student) {
        return analysisService.getPerformanceFeedback(calculateFinalGrade(student));
    }

    public void saveStudent(Student student) throws IOException {
        persistenceService.saveStudent(student);
    }

    public Student loadStudent(String studentId) throws IOException {
        return persistenceService.loadStudent(studentId);
    }

    public List<String> listStudents() {
        return persistenceService.listStudentIds();
    }

    public boolean deleteStudent(String studentId) {
        return persistenceService.deleteStudent(studentId);
    }
}
