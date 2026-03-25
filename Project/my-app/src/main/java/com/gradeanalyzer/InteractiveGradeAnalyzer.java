package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.view.ConsoleView;

import java.io.IOException;
import java.util.List;
import java.util.Scanner;

public class InteractiveGradeAnalyzer {
    private static final Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        GradeController controller = new GradeController();
        ConsoleView view = new ConsoleView();

        boolean running = true;
        while (running) {
            System.out.println("\n========================================");
            System.out.println("INTERACTIVE GRADE ANALYZER");
            System.out.println("========================================");
            System.out.println("1. Create student record");
            System.out.println("2. View student record");
            System.out.println("3. List all students");
            System.out.println("4. Delete student record");
            System.out.println("5. Exit");
            System.out.print("Enter choice: ");

            String choice = scanner.nextLine().trim();

            switch (choice) {
                case "1":
                    createStudentRecord(controller, view);
                    break;
                case "2":
                    viewStudentRecord(controller, view);
                    break;
                case "3":
                    listStudents(controller, view);
                    break;
                case "4":
                    deleteStudentRecord(controller, view);
                    break;
                case "5":
                    running = false;
                    view.showMessage("Exiting application.");
                    break;
                default:
                    view.showMessage("Invalid option. Please try again.");
            }
        }
    }

    private static void createStudentRecord(GradeController controller, ConsoleView view) {
        try {
            System.out.print("Enter student ID: ");
            String id = scanner.nextLine().trim();

            System.out.print("Enter student name: ");
            String name = scanner.nextLine().trim();

            Student student = new Student(id, name);

            System.out.print("Enter number of assessments: ");
            int assessmentCount = Integer.parseInt(scanner.nextLine().trim());

            for (int i = 1; i <= assessmentCount; i++) {
                System.out.println("\nAssessment " + i + ":");

                System.out.print("Name: ");
                String assessmentName = scanner.nextLine().trim();

                System.out.print("Score (0-100): ");
                double score = Double.parseDouble(scanner.nextLine().trim());

                System.out.print("Weight (%): ");
                double weight = Double.parseDouble(scanner.nextLine().trim());

                student.addAssessment(new Assessment(assessmentName, score, weight));
            }

            controller.validateStudent(student);
            controller.saveStudent(student);

            double finalGrade = controller.calculateFinalGrade(student);
            String letterGrade = controller.getLetterGrade(student);
            String standing = controller.getStanding(student);
            double average = controller.getAverageScore(student);
            double highest = controller.getHighestScore(student);
            double lowest = controller.getLowestScore(student);
            String feedback = controller.getFeedback(student);

            view.showMessage("\nStudent record saved successfully.");
            view.displayStudentReport(student, finalGrade, letterGrade, standing, average, highest, lowest, feedback);

        } catch (NumberFormatException e) {
            view.showMessage("Invalid numeric input.");
        } catch (IllegalArgumentException e) {
            view.showMessage("Validation error: " + e.getMessage());
        } catch (IOException e) {
            view.showMessage("File error: " + e.getMessage());
        }
    }

    private static void viewStudentRecord(GradeController controller, ConsoleView view) {
        try {
            System.out.print("Enter student ID: ");
            String id = scanner.nextLine().trim();

            Student student = controller.loadStudent(id);

            double finalGrade = controller.calculateFinalGrade(student);
            String letterGrade = controller.getLetterGrade(student);
            String standing = controller.getStanding(student);
            double average = controller.getAverageScore(student);
            double highest = controller.getHighestScore(student);
            double lowest = controller.getLowestScore(student);
            String feedback = controller.getFeedback(student);

            view.displayStudentReport(student, finalGrade, letterGrade, standing, average, highest, lowest, feedback);

        } catch (IOException e) {
            view.showMessage("Could not load student: " + e.getMessage());
        }
    }

    private static void listStudents(GradeController controller, ConsoleView view) {
        List<String> studentIds = controller.listStudents();

        if (studentIds.isEmpty()) {
            view.showMessage("No student records found.");
            return;
        }

        view.showMessage("\nSaved student IDs:");
        for (String id : studentIds) {
            view.showMessage("- " + id);
        }
    }

    private static void deleteStudentRecord(GradeController controller, ConsoleView view) {
        System.out.print("Enter student ID to delete: ");
        String id = scanner.nextLine().trim();

        boolean deleted = controller.deleteStudent(id);
        if (deleted) {
            view.showMessage("Student record deleted.");
        } else {
            view.showMessage("Student record not found.");
        }
    }
}
