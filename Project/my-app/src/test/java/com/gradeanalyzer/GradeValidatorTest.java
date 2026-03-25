package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeValidator;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GradeValidatorTest {

    private final GradeValidator validator = new GradeValidator();

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
    void invalidScoreShouldThrowException() {
        Assessment bad = new Assessment("Quiz", 120, 20);
        assertThrows(IllegalArgumentException.class, () -> validator.validateAssessment(bad));
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
    void emptyStudentIdShouldThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentId(""));
    }

    @Test
    void emptyStudentNameShouldThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateStudentName(" "));
    }
}
