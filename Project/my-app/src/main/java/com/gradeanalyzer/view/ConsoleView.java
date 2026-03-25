package com.gradeanalyzer.view;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;

public class ConsoleView {

    public void displayStudentReport(Student student, double finalGrade, String letterGrade,
                                     String standing, double average, double highest,
                                     double lowest, String feedback) {
        System.out.println("\n========================================");
        System.out.println("STUDENT GRADE REPORT");
        System.out.println("========================================");
        System.out.println("Student ID: " + student.getId());
        System.out.println("Student Name: " + student.getName());

        System.out.println("\nAssessments:");
        for (Assessment assessment : student.getAssessments()) {
            System.out.printf("- %s | Score: %.2f | Weight: %.2f%%%n",
                    assessment.getName(), assessment.getScore(), assessment.getWeight());
        }

        System.out.println("\nResults:");
        System.out.printf("Final Grade: %.2f%%%n", finalGrade);
        System.out.println("Letter Grade: " + letterGrade);
        System.out.println("Standing: " + standing);

        System.out.println("\nStatistics:");
        System.out.printf("Average Score: %.2f%n", average);
        System.out.printf("Highest Score: %.2f%n", highest);
        System.out.printf("Lowest Score: %.2f%n", lowest);

        System.out.println("\nFeedback:");
        System.out.println(feedback);
        System.out.println("========================================");
    }

    public void showMessage(String message) {
        System.out.println(message);
    }
}
