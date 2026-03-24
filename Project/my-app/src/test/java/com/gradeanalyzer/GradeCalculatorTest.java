package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeCalculator;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GradeCalculatorTest {

    private final GradeCalculator calculator = new GradeCalculator();

    @Test
    public void calculateFinalGrade_shouldReturnCorrectWeightedAverage() {
        List<Assessment> assessments = new ArrayList<>();
        assessments.add(new Assessment("Assignment", 80, 20));
        assessments.add(new Assessment("Midterm", 70, 30));
        assessments.add(new Assessment("Final", 90, 50));

        double result = calculator.calculateFinalGrade(assessments);

        assertEquals(82.0, result, 0.0001);
    }

    @Test
    public void calculateFinalGrade_shouldThrowException_whenListEmpty() {
        List<Assessment> assessments = new ArrayList<>();

        assertThrows(IllegalArgumentException.class, () ->
                calculator.calculateFinalGrade(assessments));
    }

    @Test
    public void calculateFinalGrade_shouldThrowException_whenScoreInvalid() {
        List<Assessment> assessments = new ArrayList<>();
        assessments.add(new Assessment("Assignment", -5, 50));
        assessments.add(new Assessment("Final", 90, 50));

        assertThrows(IllegalArgumentException.class, () ->
                calculator.calculateFinalGrade(assessments));
    }

    @Test
    public void calculateFinalGrade_shouldThrowException_whenWeightNot100() {
        List<Assessment> assessments = new ArrayList<>();
        assessments.add(new Assessment("Assignment", 80, 30));
        assessments.add(new Assessment("Final", 90, 30));

        assertThrows(IllegalArgumentException.class, () ->
                calculator.calculateFinalGrade(assessments));
    }

    @Test
    public void getLetterGrade_shouldReturnAPlus_for90AndAbove() {
        assertEquals("A+", calculator.getLetterGrade(90));
        assertEquals("A+", calculator.getLetterGrade(100));
    }

    @Test
    public void getLetterGrade_shouldReturnF_forBelow50() {
        assertEquals("F", calculator.getLetterGrade(49.99));
    }

    @Test
    public void getStanding_shouldReturnPass_for50AndAbove() {
        assertEquals("Pass", calculator.getStanding(50));
    }

    @Test
    public void getStanding_shouldReturnFail_forBelow50() {
        assertEquals("Fail", calculator.getStanding(49.99));
    }
}