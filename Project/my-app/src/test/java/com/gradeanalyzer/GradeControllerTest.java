package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GradeControllerTest {

    @Test
    void testCalculateFinalGrade() {
        GradeController controller = new GradeController();
        Student student = new Student("1", "Olly");
        student.addAssessment(new Assessment("Assignment", 80, 20));
        student.addAssessment(new Assessment("Midterm", 70, 30));
        student.addAssessment(new Assessment("Final", 90, 50));

        assertEquals(82.0, controller.calculateFinalGrade(student), 0.0001);
    }

    @Test
    void testGetLetterGrade() {
        GradeController controller = new GradeController();
        Student student = new Student("1", "Olly");
        student.addAssessment(new Assessment("Assignment", 80, 20));
        student.addAssessment(new Assessment("Midterm", 70, 30));
        student.addAssessment(new Assessment("Final", 90, 50));

        assertEquals("A-", controller.getLetterGrade(student));
    }
}
