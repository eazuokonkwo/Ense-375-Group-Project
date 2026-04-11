package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.view.ConsoleView;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.junit.jupiter.api.Assertions.*;

public class ConsoleViewTest {

    private final ConsoleView view = new ConsoleView();
    private final ByteArrayOutputStream out = new ByteArrayOutputStream();
    private PrintStream originalOut;

    @BeforeEach
    void redirectOutput() {
        originalOut = System.out;
        System.setOut(new PrintStream(out));
    }

    @AfterEach
    void restoreOutput() {
        System.setOut(originalOut);
    }

    private Student makeStudent() {
        Student student = new Student("200001", "Alice Smith");
        student.addAssessment(new Assessment("Midterm", 78.0, 40.0));
        student.addAssessment(new Assessment("Final", 88.0, 60.0));
        return student;
    }

    // ── displayStudentReport ───────────────────────────────────────────────

    @Test
    void testReportContainsStudentId() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("200001"));
    }

    @Test
    void testReportContainsStudentName() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("Alice Smith"));
    }

    @Test
    void testReportContainsLetterGrade() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("A-"));
    }

    @Test
    void testReportContainsStanding() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("Pass"));
    }

    @Test
    void testReportContainsFinalGrade() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("84.00"));
    }

    @Test
    void testReportContainsAverageScore() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("83.00"));
    }

    @Test
    void testReportContainsHighestScore() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("88.00"));
    }

    @Test
    void testReportContainsLowestScore() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("78.00"));
    }

    @Test
    void testReportContainsFeedback() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        assertTrue(out.toString().contains("Good performance."));
    }

    @Test
    void testReportContainsAssessmentName() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        String output = out.toString();
        assertTrue(output.contains("Midterm"));
        assertTrue(output.contains("Final"));
    }

    @Test
    void testReportContainsSectionHeaders() {
        view.displayStudentReport(makeStudent(), 84.0, "A-", "Pass", 83.0, 88.0, 78.0, "Good performance.");
        String output = out.toString();
        assertTrue(output.contains("STUDENT GRADE REPORT"));
        assertTrue(output.contains("Assessments:"));
        assertTrue(output.contains("Results:"));
        assertTrue(output.contains("Statistics:"));
        assertTrue(output.contains("Feedback:"));
    }

    // ── showMessage ────────────────────────────────────────────────────────

    @Test
    void testShowMessage() {
        view.showMessage("Hello, World!");
        assertTrue(out.toString().contains("Hello, World!"));
    }

    @Test
    void testShowMessageEmptyString() {
        view.showMessage("");
        assertNotNull(out.toString());
    }

    @Test
    void testShowMessageSpecialCharacters() {
        view.showMessage("Score: 100% — Excellent!");
        assertTrue(out.toString().contains("Score: 100% — Excellent!"));
    }
}
