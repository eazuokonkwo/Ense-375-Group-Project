package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeAnalysisService;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GradeAnalysisServiceTest {

    private final GradeAnalysisService service = new GradeAnalysisService();

    @Test
    void testCalculateAverageScore() {
        List<Assessment> assessments = List.of(
                new Assessment("A1", 90, 20),
                new Assessment("A2", 80, 30),
                new Assessment("A3", 70, 50)
        );

        assertEquals(80.0, service.calculateAverageScore(assessments), 0.0001);
    }

    @Test
    void testGetHighestScore() {
        List<Assessment> assessments = List.of(
                new Assessment("A1", 90, 20),
                new Assessment("A2", 80, 30),
                new Assessment("A3", 70, 50)
        );

        assertEquals(90.0, service.getHighestScore(assessments), 0.0001);
    }

    @Test
    void testGetLowestScore() {
        List<Assessment> assessments = List.of(
                new Assessment("A1", 90, 20),
                new Assessment("A2", 80, 30),
                new Assessment("A3", 70, 50)
        );

        assertEquals(70.0, service.getLowestScore(assessments), 0.0001);
    }

    @Test
    void testGetPerformanceFeedback() {
        assertEquals("Good performance. Continue with consistent effort.", service.getPerformanceFeedback(85));
    }
}
