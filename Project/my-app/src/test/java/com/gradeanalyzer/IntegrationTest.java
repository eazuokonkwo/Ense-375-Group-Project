package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class IntegrationTest {

    @Test
    void testEndToEndWorkflow() {
        GradeController controller = new GradeController();

        Student student = new Student("12345", "John Doe");
        student.addAssessment(new Assessment("Assignment", 85, 20));
        student.addAssessment(new Assessment("Midterm", 78, 30));
        student.addAssessment(new Assessment("Final", 90, 50));

        controller.validateStudent(student);

        double finalGrade = controller.calculateFinalGrade(student);
        String letterGrade = controller.getLetterGrade(student);
        String standing = controller.getStanding(student);

        assertEquals(85.4, finalGrade, 0.0001);
        assertEquals("A", letterGrade);
        assertEquals("Pass", standing);
    }
}
