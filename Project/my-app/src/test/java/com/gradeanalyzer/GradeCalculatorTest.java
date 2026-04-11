package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeCalculator;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GradeCalculatorTest {

    private final GradeCalculator calculator = new GradeCalculator();

    // ── calculateFinalGrade ────────────────────────────────────────────────

    @Test
    void testCalculateFinalGrade() {
        List<Assessment> assessments = List.of(
                new Assessment("Assignment", 80, 20),
                new Assessment("Midterm", 70, 30),
                new Assessment("Final", 90, 50)
        );
        assertEquals(82.0, calculator.calculateFinalGrade(assessments), 0.0001);
    }

    @Test
    void testCalculateFinalGradeSingleAssessment() {
        List<Assessment> assessments = List.of(new Assessment("Final", 75.0, 100.0));
        assertEquals(75.0, calculator.calculateFinalGrade(assessments), 0.0001);
    }

    @Test
    void testCalculateFinalGradeEmptyListReturnsZero() {
        assertEquals(0.0, calculator.calculateFinalGrade(new ArrayList<>()), 0.0001);
    }

    @Test
    void testCalculateFinalGradePerfectScore() {
        List<Assessment> assessments = List.of(
                new Assessment("A", 100.0, 50.0),
                new Assessment("B", 100.0, 50.0)
        );
        assertEquals(100.0, calculator.calculateFinalGrade(assessments), 0.0001);
    }

    @Test
    void testCalculateFinalGradeZeroScore() {
        List<Assessment> assessments = List.of(
                new Assessment("A", 0.0, 50.0),
                new Assessment("B", 0.0, 50.0)
        );
        assertEquals(0.0, calculator.calculateFinalGrade(assessments), 0.0001);
    }

    // ── getLetterGrade — all 13 grades ────────────────────────────────────

    @Test
    void testLetterGrade() {
        assertEquals("A", calculator.getLetterGrade(85));
        assertEquals("F", calculator.getLetterGrade(40));
    }

    @Test
    void testLetterGradeAPlus() {
        assertEquals("A+", calculator.getLetterGrade(90.0));
        assertEquals("A+", calculator.getLetterGrade(100.0));
        assertEquals("A+", calculator.getLetterGrade(95.5));
    }

    @Test
    void testLetterGradeA() {
        assertEquals("A", calculator.getLetterGrade(85.0));
        assertEquals("A", calculator.getLetterGrade(89.9));
    }

    @Test
    void testLetterGradeAMinus() {
        assertEquals("A-", calculator.getLetterGrade(80.0));
        assertEquals("A-", calculator.getLetterGrade(84.9));
    }

    @Test
    void testLetterGradeBPlus() {
        assertEquals("B+", calculator.getLetterGrade(77.0));
        assertEquals("B+", calculator.getLetterGrade(79.9));
    }

    @Test
    void testLetterGradeB() {
        assertEquals("B", calculator.getLetterGrade(73.0));
        assertEquals("B", calculator.getLetterGrade(76.9));
    }

    @Test
    void testLetterGradeBMinus() {
        assertEquals("B-", calculator.getLetterGrade(70.0));
        assertEquals("B-", calculator.getLetterGrade(72.9));
    }

    @Test
    void testLetterGradeCPlus() {
        assertEquals("C+", calculator.getLetterGrade(67.0));
        assertEquals("C+", calculator.getLetterGrade(69.9));
    }

    @Test
    void testLetterGradeC() {
        assertEquals("C", calculator.getLetterGrade(63.0));
        assertEquals("C", calculator.getLetterGrade(66.9));
    }

    @Test
    void testLetterGradeCMinus() {
        assertEquals("C-", calculator.getLetterGrade(60.0));
        assertEquals("C-", calculator.getLetterGrade(62.9));
    }

    @Test
    void testLetterGradeDPlus() {
        assertEquals("D+", calculator.getLetterGrade(57.0));
        assertEquals("D+", calculator.getLetterGrade(59.9));
    }

    @Test
    void testLetterGradeD() {
        assertEquals("D", calculator.getLetterGrade(53.0));
        assertEquals("D", calculator.getLetterGrade(56.9));
    }

    @Test
    void testLetterGradeDMinus() {
        assertEquals("D-", calculator.getLetterGrade(50.0));
        assertEquals("D-", calculator.getLetterGrade(52.9));
    }

    @Test
    void testLetterGradeF() {
        assertEquals("F", calculator.getLetterGrade(49.9));
        assertEquals("F", calculator.getLetterGrade(0.0));
    }

    // ── getStanding ────────────────────────────────────────────────────────

    @Test
    void testStanding() {
        assertEquals("Pass", calculator.getStanding(50));
        assertEquals("Fail", calculator.getStanding(49.99));
    }

    @Test
    void testStandingExactBoundary() {
        assertEquals("Pass", calculator.getStanding(50.0));
        assertEquals("Fail", calculator.getStanding(49.999));
    }

    @Test
    void testStandingPerfectScore() {
        assertEquals("Pass", calculator.getStanding(100.0));
    }

    @Test
    void testStandingZero() {
        assertEquals("Fail", calculator.getStanding(0.0));
    }
}
