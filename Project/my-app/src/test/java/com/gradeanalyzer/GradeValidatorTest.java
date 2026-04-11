package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeValidator;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GradeValidatorTest {

    private final GradeValidator validator = new GradeValidator();

    // ── validateAssessmentList ─────────────────────────────────────────────

    @Test
    void validAssessmentListShouldPass() {
        List<Assessment> assessments = List.of(
                new Assessment("Assignment", 80, 20),
                new Assessment("Midterm", 75, 30),
                new Assessment("Final", 90, 50)
        );
        assertDoesNotThrow(() -> validator.validateAssessmentList(assessments));
    }

    @Test
    void invalidWeightTotalShouldThrowException() {
        List<Assessment> assessments = List.of(
                new Assessment("Assignment", 80, 20),
                new Assessment("Midterm", 75, 20),
                new Assessment("Final", 90, 50)
        );
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessmentList(assessments));
    }

    @Test
    void nullAssessmentListShouldThrow() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessmentList(null));
    }

    @Test
    void emptyAssessmentListShouldThrow() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessmentList(List.of()));
    }

    @Test
    void singleAssessmentWithWeight100ShouldPass() {
        List<Assessment> assessments = List.of(new Assessment("Final", 80.0, 100.0));
        assertDoesNotThrow(() -> validator.validateAssessmentList(assessments));
    }

    @Test
    void weightSumJustOverToleranceShouldThrow() {
        // 100.0002 is outside the 0.0001 tolerance
        List<Assessment> assessments = List.of(
                new Assessment("A", 80.0, 50.0001),
                new Assessment("B", 80.0, 50.0001)
        );
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessmentList(assessments));
    }

    // ── validateAssessment ─────────────────────────────────────────────────

    @Test
    void invalidScoreShouldThrowException() {
        Assessment bad = new Assessment("Quiz", 120, 20);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
    }

    @Test
    void negativeScoreShouldThrow() {
        Assessment bad = new Assessment("Quiz", -1.0, 20.0);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
    }

    @Test
    void scoreBoundaryZeroShouldPass() {
        Assessment a = new Assessment("Quiz", 0.0, 100.0);
        assertDoesNotThrow(() -> validator.validateAssessment(a));
    }

    @Test
    void scoreBoundary100ShouldPass() {
        Assessment a = new Assessment("Quiz", 100.0, 100.0);
        assertDoesNotThrow(() -> validator.validateAssessment(a));
    }

    @Test
    void nullAssessmentShouldThrow() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(null));
    }

    @Test
    void assessmentWithEmptyNameShouldThrow() {
        Assessment bad = new Assessment("", 80.0, 50.0);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
    }

    @Test
    void assessmentWithBlankNameShouldThrow() {
        Assessment bad = new Assessment("   ", 80.0, 50.0);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
    }

    @Test
    void assessmentWithZeroWeightShouldThrow() {
        Assessment bad = new Assessment("Quiz", 80.0, 0.0);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
    }

    @Test
    void assessmentWithWeightOver100ShouldThrow() {
        Assessment bad = new Assessment("Quiz", 80.0, 101.0);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
    }

    @Test
    void assessmentWithWeight100ShouldPass() {
        Assessment a = new Assessment("Final", 80.0, 100.0);
        assertDoesNotThrow(() -> validator.validateAssessment(a));
    }

    // ── validateStudentId ──────────────────────────────────────────────────

    @Test
    void emptyStudentIdShouldThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentId(""));
    }

    @Test
    void blankStudentIdShouldThrow() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentId("   "));
    }

    @Test
    void nullStudentIdShouldThrow() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentId(null));
    }

    @Test
    void validStudentIdShouldPass() {
        assertDoesNotThrow(() -> validator.validateStudentId("200477240"));
    }

    // ── validateStudentName ────────────────────────────────────────────────

    @Test
    void emptyStudentNameShouldThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentName(" "));
    }

    @Test
    void nullStudentNameShouldThrow() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentName(null));
    }

    @Test
    void validStudentNameShouldPass() {
        assertDoesNotThrow(() -> validator.validateStudentName("Alice Smith"));
    }
}
