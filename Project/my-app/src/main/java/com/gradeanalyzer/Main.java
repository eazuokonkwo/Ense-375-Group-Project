package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.view.ConsoleView;

public class Main {
    public static void main(String[] args) {
        Student student = new Student("200477240", "Olly Ogana");
        student.addAssessment(new Assessment("Assignment", 85, 20));
        student.addAssessment(new Assessment("Midterm", 78, 30));
        student.addAssessment(new Assessment("Final", 90, 50));

        GradeController controller = new GradeController();
        ConsoleView view = new ConsoleView();

        try {
            controller.validateStudent(student);

            double finalGrade = controller.calculateFinalGrade(student);
            String letterGrade = controller.getLetterGrade(student);
            String standing = controller.getStanding(student);
            double average = controller.getAverageScore(student);
            double highest = controller.getHighestScore(student);
            double lowest = controller.getLowestScore(student);
            String feedback = controller.getFeedback(student);

            view.displayStudentReport(
                    student,
                    finalGrade,
                    letterGrade,
                    standing,
                    average,
                    highest,
                    lowest,
                    feedback
            );
        } catch (Exception e) {
            view.showMessage("Error: " + e.getMessage());
        }
    }
}
