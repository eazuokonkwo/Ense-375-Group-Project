package com.gradeanalyzer;

import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.service.GradeReportService;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class GradeReportServiceTest {

    private final GradeReportService service = new GradeReportService();

    private String buildReport(double finalGrade, String letter, String standing,
                                double avg, double high, double low, String feedback) {
        Student student = new Student("200001", "Olly Ogana");
        return service.generateReport(student, finalGrade, letter, standing, avg, high, low, feedback);
    }

    // ── basic content ──────────────────────────────────────────────────────

    @Test
    void testGenerateReport() {
        Student student = new Student("1", "Olly");
        String report = service.generateReport(student, 85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Olly"));
        assertTrue(report.contains("Final Grade: 85.00%"));
    }

    @Test
    void testReportContainsStudentId() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Student ID: 200001"));
    }

    @Test
    void testReportContainsStudentName() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Student Name: Olly Ogana"));
    }

    @Test
    void testReportContainsLetterGrade() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Letter Grade: A"));
    }

    @Test
    void testReportContainsStanding() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Standing: Pass"));
    }

    @Test
    void testReportContainsAverageScore() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Average Score: 84.00"));
    }

    @Test
    void testReportContainsHighestScore() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Highest Score: 90.00"));
    }

    @Test
    void testReportContainsLowestScore() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Lowest Score: 78.00"));
    }

    @Test
    void testReportContainsFeedback() {
        String report = buildReport(85.0, "A", "Pass", 84.0, 90.0, 78.0, "Good performance.");
        assertTrue(report.contains("Feedback: Good performance."));
    }

    // ── formatting ─────────────────────────────────────────────────────────

    @Test
    void testFinalGradeFormattedToTwoDecimals() {
        String report = buildReport(82.333, "A-", "Pass", 80.0, 90.0, 70.0, "Good.");
        assertTrue(report.contains("Final Grade: 82.33%"));
    }

    @Test
    void testAverageFormattedToTwoDecimals() {
        String report = buildReport(80.0, "A-", "Pass", 83.333, 90.0, 70.0, "Good.");
        assertTrue(report.contains("Average Score: 83.33"));
    }

    // ── standing variants ──────────────────────────────────────────────────

    @Test
    void testReportWithFailStanding() {
        String report = buildReport(45.0, "F", "Fail", 45.0, 45.0, 45.0, "Poor performance.");
        assertTrue(report.contains("Standing: Fail"));
        assertTrue(report.contains("Letter Grade: F"));
    }

    // ── all fields present ─────────────────────────────────────────────────

    @Test
    void testAllFieldsPresent() {
        String report = buildReport(90.0, "A+", "Pass", 88.0, 95.0, 82.0, "Excellent performance!");
        assertAll(
            () -> assertTrue(report.contains("Student ID:")),
            () -> assertTrue(report.contains("Student Name:")),
            () -> assertTrue(report.contains("Final Grade:")),
            () -> assertTrue(report.contains("Letter Grade:")),
            () -> assertTrue(report.contains("Standing:")),
            () -> assertTrue(report.contains("Average Score:")),
            () -> assertTrue(report.contains("Highest Score:")),
            () -> assertTrue(report.contains("Lowest Score:")),
            () -> assertTrue(report.contains("Feedback:"))
        );
    }
}
