package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeCalculator;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GradeCalculatorTest {

    @Test
    void testCalculateFinalGrade() {
        GradeCalculator calculator = new GradeCalculator();

        List<Assessment> assessments = List.of(
                new Assessment("Assignment", 80, 20),
                new Assessment("Midterm", 70, 30),
                new Assessment("Final", 90, 50)
        );

        assertEquals(82.0, calculator.calculateFinalGrade(assessments), 0.0001);
    }

    @Test
    void testLetterGrade() {
        GradeCalculator calculator = new GradeCalculator();
        assertEquals("A", calculator.getLetterGrade(85));
        assertEquals("F", calculator.getLetterGrade(40));
    }

    @Test
    void testStanding() {
        GradeCalculator calculator = new GradeCalculator();
        assertEquals("Pass", calculator.getStanding(50));
        assertEquals("Fail", calculator.getStanding(49.99));
    }
}
