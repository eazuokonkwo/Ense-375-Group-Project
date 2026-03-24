package com.gradeanalyzer;

import com.gradeanalyzer.controller.GradeController;
import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class GradeControllerTest {

    @Test
    public void calculateStudentFinalGrade_shouldReturnCorrectValue() {
        Student student = new Student("1", "John");
        student.addAssessment(new Assessment("Assignment", 80, 20));
        student.addAssessment(new Assessment("Midterm", 70, 30));
        student.addAssessment(new Assessment("Final", 90, 50));

        GradeController controller = new GradeController();

        double result = controller.calculateStudentFinalGrade(student);

        assertEquals(82.0, result, 0.0001);
    }

    @Test
    public void getStudentLetterGrade_shouldReturnCorrectLetter() {
        Student student = new Student("1", "John");
        student.addAssessment(new Assessment("Assignment", 80, 20));
        student.addAssessment(new Assessment("Midterm", 70, 30));
        student.addAssessment(new Assessment("Final", 90, 50));

        GradeController controller = new GradeController();

        assertEquals("A", controller.getStudentLetterGrade(student));
    }
}