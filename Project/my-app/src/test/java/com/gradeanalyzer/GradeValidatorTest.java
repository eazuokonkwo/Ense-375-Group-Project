package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeValidator;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GradeValidatorTest {

    private final GradeValidator validator = new GradeValidator();

    @Test
    public void isValidScore_shouldReturnTrue_forBoundaryValues() {
        assertTrue(validator.isValidScore(0));
        assertTrue(validator.isValidScore(100));
    }

    @Test
    public void isValidScore_shouldReturnFalse_forInvalidValues() {
        assertFalse(validator.isValidScore(-1));
        assertFalse(validator.isValidScore(101));
    }

    @Test
    public void totalWeightIs100_shouldReturnTrue_whenTotalIsExactly100() {
        List<Assessment> assessments = new ArrayList<>();
        assessments.add(new Assessment("A1", 80, 40));
        assessments.add(new Assessment("A2", 90, 60));

        assertTrue(validator.totalWeightIs100(assessments));
    }

    @Test
    public void totalWeightIs100_shouldReturnFalse_whenTotalIsNot100() {
        List<Assessment> assessments = new ArrayList<>();
        assessments.add(new Assessment("A1", 80, 30));
        assessments.add(new Assessment("A2", 90, 60));

        assertFalse(validator.totalWeightIs100(assessments));
    }

    @Test
    public void hasAssessments_shouldReturnFalse_whenListEmpty() {
        assertFalse(validator.hasAssessments(new ArrayList<>()));
    }
}