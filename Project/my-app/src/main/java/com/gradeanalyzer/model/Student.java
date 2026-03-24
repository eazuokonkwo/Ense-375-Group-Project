package com.gradeanalyzer.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a student and the student's list of assessments.
 */
public class Student {
    private String studentId;
    private String name;
    private List<Assessment> assessments;

    public Student(String studentId, String name) {
        this.studentId = studentId;
        this.name = name;
        this.assessments = new ArrayList<>();
    }

    public String getStudentId() {
        return studentId;
    }

    public String getName() {
        return name;
    }

    public List<Assessment> getAssessments() {
        return assessments;
    }

    public void addAssessment(Assessment assessment) {
        assessments.add(assessment);
    }
}