package com.gradeanalyzer.view;

import com.gradeanalyzer.model.Student;

/**
 * Handles simple console output.
 */
public class ConsoleView {

    public void displayStudentResult(Student student, double finalGrade, String letterGrade, String standing) {
        System.out.println("Student ID: " + student.getStudentId());
        System.out.println("Student Name: " + student.getName());
        System.out.printf("Final Grade: %.2f%n", finalGrade);
        System.out.println("Letter Grade: " + letterGrade);
        System.out.println("Standing: " + standing);
    }

    public void displayError(String message) {
        System.out.println("Error: " + message);
    }
}