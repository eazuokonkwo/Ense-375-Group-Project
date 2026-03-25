package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Student;

public class GradeReportService {

    public String generateReport(Student student,
                                 double finalGrade,
                                 String letterGrade,
                                 String standing,
                                 double average,
                                 double highest,
                                 double lowest,
                                 String feedback) {
        StringBuilder builder = new StringBuilder();

        builder.append("Student ID: ").append(student.getId()).append("\n");
        builder.append("Student Name: ").append(student.getName()).append("\n");
        builder.append("Final Grade: ").append(String.format("%.2f%%", finalGrade)).append("\n");
        builder.append("Letter Grade: ").append(letterGrade).append("\n");
        builder.append("Standing: ").append(standing).append("\n");
        builder.append("Average Score: ").append(String.format("%.2f", average)).append("\n");
        builder.append("Highest Score: ").append(String.format("%.2f", highest)).append("\n");
        builder.append("Lowest Score: ").append(String.format("%.2f", lowest)).append("\n");
        builder.append("Feedback: ").append(feedback).append("\n");

        return builder.toString();
    }
}
