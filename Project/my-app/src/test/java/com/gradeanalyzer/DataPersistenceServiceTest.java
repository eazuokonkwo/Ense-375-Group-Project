package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.service.DataPersistenceService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.*;

public class DataPersistenceServiceTest {

    @AfterEach
    void cleanup() throws Exception {
        Files.deleteIfExists(Paths.get("student_data", "99999.txt"));
    }

    @Test
    void testSaveAndLoadStudent() throws Exception {
        DataPersistenceService service = new DataPersistenceService();

        Student student = new Student("99999", "Test Student");
        student.addAssessment(new Assessment("Assignment", 85, 40));
        student.addAssessment(new Assessment("Final", 90, 60));

        service.saveStudent(student);
        Student loaded = service.loadStudent("99999");

        assertEquals("99999", loaded.getId());
        assertEquals("Test Student", loaded.getName());
        assertEquals(2, loaded.getAssessments().size());
    }
}
