package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GradeControllerTest {

    private final GradeController controller = new GradeController();

    private Student makeStudent(String id, String name, double... scoresAndWeights) {
        Student s = new Student(id, name);
        for (int i = 0; i < scoresAndWeights.length; i += 2) {
            s.addAssessment(new Assessment("A" + (i / 2 + 1), scoresAndWeights[i], scoresAndWeights[i + 1]));
        }
        return s;
    }

    @AfterEach
    void cleanup() throws Exception {
        Files.deleteIfExists(Paths.get("student_data", "CTL001.txt"));
        Files.deleteIfExists(Paths.get("student_data", "CTL002.txt"));
    }

    // ── calculateFinalGrade ────────────────────────────────────────────────

    @Test
    void testCalculateFinalGrade() {
        Student student = new Student("1", "Olly");
        student.addAssessment(new Assessment("Assignment", 80, 20));
        student.addAssessment(new Assessment("Midterm", 70, 30));
        student.addAssessment(new Assessment("Final", 90, 50));
        assertEquals(82.0, controller.calculateFinalGrade(student), 0.0001);
    }

    // ── getLetterGrade ─────────────────────────────────────────────────────

    @Test
    void testGetLetterGrade() {
        Student student = new Student("1", "Olly");
        student.addAssessment(new Assessment("Assignment", 80, 20));
        student.addAssessment(new Assessment("Midterm", 70, 30));
        student.addAssessment(new Assessment("Final", 90, 50));
        assertEquals("A-", controller.getLetterGrade(student));
    }

    // ── getStanding ────────────────────────────────────────────────────────

    @Test
    void testGetStandingPass() {
        Student student = makeStudent("1", "Alice", 80.0, 100.0);
        assertEquals("Pass", controller.getStanding(student));
    }

    @Test
    void testGetStandingFail() {
        Student student = makeStudent("1", "Bob", 40.0, 100.0);
        assertEquals("Fail", controller.getStanding(student));
    }

    @Test
    void testGetStandingExactBoundary() {
        Student student = makeStudent("1", "Carol", 50.0, 100.0);
        assertEquals("Pass", controller.getStanding(student));
    }

    // ── getAverageScore ────────────────────────────────────────────────────

    @Test
    void testGetAverageScore() {
        Student student = new Student("1", "Dave");
        student.addAssessment(new Assessment("A", 90.0, 50.0));
        student.addAssessment(new Assessment("B", 70.0, 50.0));
        assertEquals(80.0, controller.getAverageScore(student), 0.0001);
    }

    @Test
    void testGetAverageScoreSingleAssessment() {
        Student student = makeStudent("1", "Eve", 65.0, 100.0);
        assertEquals(65.0, controller.getAverageScore(student), 0.0001);
    }

    // ── getHighestScore ────────────────────────────────────────────────────

    @Test
    void testGetHighestScore() {
        Student student = new Student("1", "Frank");
        student.addAssessment(new Assessment("A", 95.0, 50.0));
        student.addAssessment(new Assessment("B", 75.0, 50.0));
        assertEquals(95.0, controller.getHighestScore(student), 0.0001);
    }

    // ── getLowestScore ─────────────────────────────────────────────────────

    @Test
    void testGetLowestScore() {
        Student student = new Student("1", "Grace");
        student.addAssessment(new Assessment("A", 95.0, 50.0));
        student.addAssessment(new Assessment("B", 55.0, 50.0));
        assertEquals(55.0, controller.getLowestScore(student), 0.0001);
    }

    // ── getFeedback ────────────────────────────────────────────────────────

    @Test
    void testGetFeedbackExcellent() {
        Student student = makeStudent("1", "Hana", 100.0, 100.0);
        assertEquals("Excellent performance! Keep up the outstanding work.", controller.getFeedback(student));
    }

    @Test
    void testGetFeedbackPoor() {
        Student student = makeStudent("1", "Ian", 10.0, 100.0);
        assertEquals("Poor performance. Seek additional help and resources.", controller.getFeedback(student));
    }

    // ── validateStudent ────────────────────────────────────────────────────

    @Test
    void testValidateStudentValidInput() {
        Student student = new Student("200001", "Valid Student");
        student.addAssessment(new Assessment("Final", 80.0, 100.0));
        assertDoesNotThrow(() -> controller.validateStudent(student));
    }

    @Test
    void testValidateStudentEmptyIdThrows() {
        Student student = new Student("", "Valid Name");
        student.addAssessment(new Assessment("Final", 80.0, 100.0));
        assertThrows(IllegalArgumentException.class, () -> controller.validateStudent(student));
    }

    @Test
    void testValidateStudentEmptyNameThrows() {
        Student student = new Student("200001", "");
        student.addAssessment(new Assessment("Final", 80.0, 100.0));
        assertThrows(IllegalArgumentException.class, () -> controller.validateStudent(student));
    }

    @Test
    void testValidateStudentBadWeightThrows() {
        Student student = new Student("200001", "Name");
        student.addAssessment(new Assessment("A", 80.0, 50.0));
        student.addAssessment(new Assessment("B", 80.0, 30.0)); // total 80, not 100
        assertThrows(IllegalArgumentException.class, () -> controller.validateStudent(student));
    }

    // ── saveStudent / loadStudent / listStudents / deleteStudent ───────────

    @Test
    void testSaveAndLoadStudent() throws Exception {
        Student student = new Student("CTL001", "Controller Save Test");
        student.addAssessment(new Assessment("Final", 88.0, 100.0));

        controller.saveStudent(student);
        Student loaded = controller.loadStudent("CTL001");

        assertEquals("CTL001", loaded.getId());
        assertEquals("Controller Save Test", loaded.getName());
        assertEquals(1, loaded.getAssessments().size());
    }

    @Test
    void testListStudentsContainsSaved() throws Exception {
        Student student = new Student("CTL002", "List Student");
        student.addAssessment(new Assessment("Final", 75.0, 100.0));
        controller.saveStudent(student);

        List<String> ids = controller.listStudents();
        assertTrue(ids.contains("CTL002"));
    }

    @Test
    void testDeleteStudentReturnsTrue() throws Exception {
        Student student = new Student("CTL001", "Delete Me");
        student.addAssessment(new Assessment("Final", 75.0, 100.0));
        controller.saveStudent(student);

        assertTrue(controller.deleteStudent("CTL001"));
    }

    @Test
    void testDeleteNonexistentStudentReturnsFalse() {
        assertFalse(controller.deleteStudent("DOESNOTEXIST"));
    }
}
