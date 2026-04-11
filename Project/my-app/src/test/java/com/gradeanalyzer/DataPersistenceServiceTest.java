package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.service.DataPersistenceService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class DataPersistenceServiceTest {

    private final DataPersistenceService service = new DataPersistenceService();

    @AfterEach
    void cleanup() throws Exception {
        Files.deleteIfExists(Paths.get("student_data", "99999.txt"));
        Files.deleteIfExists(Paths.get("student_data", "TST001.txt"));
        Files.deleteIfExists(Paths.get("student_data", "TST002.txt"));
        Files.deleteIfExists(Paths.get("student_data", "TST003.txt"));
        Files.deleteIfExists(Paths.get("student_data", "MALFORMED.txt"));
    }

    // ── saveStudent / loadStudent ──────────────────────────────────────────

    @Test
    void testSaveAndLoadStudent() throws Exception {
        Student student = new Student("99999", "Test Student");
        student.addAssessment(new Assessment("Assignment", 85, 40));
        student.addAssessment(new Assessment("Final", 90, 60));

        service.saveStudent(student);
        Student loaded = service.loadStudent("99999");

        assertEquals("99999", loaded.getId());
        assertEquals("Test Student", loaded.getName());
        assertEquals(2, loaded.getAssessments().size());
    }

    @Test
    void testSaveAndLoadPreservesAssessmentData() throws Exception {
        Student student = new Student("TST001", "Alice");
        student.addAssessment(new Assessment("Midterm", 78.5, 30.0));
        student.addAssessment(new Assessment("Final", 92.0, 70.0));

        service.saveStudent(student);
        Student loaded = service.loadStudent("TST001");

        assertEquals("Midterm", loaded.getAssessments().get(0).getName());
        assertEquals(78.5, loaded.getAssessments().get(0).getScore(), 0.0001);
        assertEquals(30.0, loaded.getAssessments().get(0).getWeight(), 0.0001);
        assertEquals("Final", loaded.getAssessments().get(1).getName());
        assertEquals(92.0, loaded.getAssessments().get(1).getScore(), 0.0001);
    }

    // ── loadStudent — error cases ──────────────────────────────────────────

    @Test
    void testLoadNonexistentStudentThrowsFileNotFound() {
        assertThrows(FileNotFoundException.class, () -> service.loadStudent("DOESNOTEXIST"));
    }

    @Test
    void testLoadMalformedFileThrowsIOException() throws Exception {
        Files.writeString(Paths.get("student_data", "MALFORMED.txt"), "bad\ndata\nnot-a-number\n");
        assertThrows(IOException.class, () -> service.loadStudent("MALFORMED"));
    }

    // ── listStudentIds ─────────────────────────────────────────────────────

    @Test
    void testListStudentIdsContainsSavedStudent() throws Exception {
        Student student = new Student("TST002", "List Test");
        student.addAssessment(new Assessment("Final", 80.0, 100.0));
        service.saveStudent(student);

        List<String> ids = service.listStudentIds();
        assertTrue(ids.contains("TST002"));
    }

    @Test
    void testListStudentIdsReturnsListType() {
        List<String> ids = service.listStudentIds();
        assertNotNull(ids);
    }

    @Test
    void testListStudentIdsContainsMultipleSaved() throws Exception {
        Student s1 = new Student("TST002", "Student Two");
        s1.addAssessment(new Assessment("Final", 80.0, 100.0));
        Student s2 = new Student("TST003", "Student Three");
        s2.addAssessment(new Assessment("Final", 70.0, 100.0));

        service.saveStudent(s1);
        service.saveStudent(s2);

        List<String> ids = service.listStudentIds();
        assertTrue(ids.contains("TST002"));
        assertTrue(ids.contains("TST003"));
    }

    // ── deleteStudent ──────────────────────────────────────────────────────

    @Test
    void testDeleteExistingStudentReturnsTrue() throws Exception {
        Student student = new Student("TST002", "To Delete");
        student.addAssessment(new Assessment("Final", 85.0, 100.0));
        service.saveStudent(student);

        assertTrue(service.deleteStudent("TST002"));
    }

    @Test
    void testDeleteExistingStudentRemovesFile() throws Exception {
        Student student = new Student("TST002", "To Delete");
        student.addAssessment(new Assessment("Final", 85.0, 100.0));
        service.saveStudent(student);
        service.deleteStudent("TST002");

        assertFalse(Files.exists(Paths.get("student_data", "TST002.txt")));
    }

    @Test
    void testDeleteNonexistentStudentReturnsFalse() {
        assertFalse(service.deleteStudent("DOESNOTEXIST"));
    }

    @Test
    void testDeletedStudentNoLongerInList() throws Exception {
        Student student = new Student("TST002", "Gone");
        student.addAssessment(new Assessment("Final", 85.0, 100.0));
        service.saveStudent(student);
        service.deleteStudent("TST002");

        assertFalse(service.listStudentIds().contains("TST002"));
    }
}
