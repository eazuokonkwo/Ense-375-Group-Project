package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.view.ConsoleView;

/**
 * Entry point for the Student Grade Analyzer application.
 */
public class Main {
    public static void main(String[] args) {
        Student student = new Student("200457779", "Ebelechukwu Azu-Okonkwo");
        student.addAssessment(new Assessment("Assignment", 85, 20));
        student.addAssessment(new Assessment("Midterm", 78, 30));
        student.addAssessment(new Assessment("Final Exam", 90, 50));

        GradeController controller = new GradeController();
        ConsoleView view = new ConsoleView();

        try {
            double finalGrade = controller.calculateStudentFinalGrade(student);
            String letterGrade = controller.getStudentLetterGrade(student);
            String standing = controller.getStudentStanding(student);

            view.displayStudentResult(student, finalGrade, letterGrade, standing);
        } catch (IllegalArgumentException e) {
            view.displayError(e.getMessage());
        }
    }
}