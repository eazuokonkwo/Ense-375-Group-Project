package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.service.GradeAnalysisService;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GradeAnalysisServiceTest {

    private final GradeAnalysisService service = new GradeAnalysisService();

    // ── calculateAverageScore ──────────────────────────────────────────────

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
    void testCalculateAverageScoreSingleAssessment() {
        List<Assessment> assessments = List.of(new Assessment("Only", 65.0, 100.0));
        assertEquals(65.0, service.calculateAverageScore(assessments), 0.0001);
    }

    @Test
    void testCalculateAverageScoreAllIdentical() {
        List<Assessment> assessments = List.of(
                new Assessment("A", 50.0, 25.0),
                new Assessment("B", 50.0, 25.0),
                new Assessment("C", 50.0, 25.0),
                new Assessment("D", 50.0, 25.0)
        );
        assertEquals(50.0, service.calculateAverageScore(assessments), 0.0001);
    }

    @Test
    void testCalculateAverageScoreNullThrows() {
        assertThrows(IllegalArgumentException.class, () -> service.calculateAverageScore(null));
    }

    @Test
    void testCalculateAverageScoreEmptyThrows() {
        assertThrows(IllegalArgumentException.class, () -> service.calculateAverageScore(List.of()));
    }

    // ── getHighestScore ────────────────────────────────────────────────────

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
    void testGetHighestScoreSingleAssessment() {
        List<Assessment> assessments = List.of(new Assessment("Only", 77.0, 100.0));
        assertEquals(77.0, service.getHighestScore(assessments), 0.0001);
    }

    @Test
    void testGetHighestScoreAllIdentical() {
        List<Assessment> assessments = List.of(
                new Assessment("A", 60.0, 50.0),
                new Assessment("B", 60.0, 50.0)
        );
        assertEquals(60.0, service.getHighestScore(assessments), 0.0001);
    }

    @Test
    void testGetHighestScoreNullThrows() {
        assertThrows(IllegalArgumentException.class, () -> service.getHighestScore(null));
    }

    @Test
    void testGetHighestScoreEmptyThrows() {
        assertThrows(IllegalArgumentException.class, () -> service.getHighestScore(List.of()));
    }

    // ── getLowestScore ─────────────────────────────────────────────────────

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
    void testGetLowestScoreSingleAssessment() {
        List<Assessment> assessments = List.of(new Assessment("Only", 42.0, 100.0));
        assertEquals(42.0, service.getLowestScore(assessments), 0.0001);
    }

    @Test
    void testGetLowestScoreNullThrows() {
        assertThrows(IllegalArgumentException.class, () -> service.getLowestScore(null));
    }

    @Test
    void testGetLowestScoreEmptyThrows() {
        assertThrows(IllegalArgumentException.class, () -> service.getLowestScore(List.of()));
    }

    // ── getPerformanceFeedback — all 5 tiers ──────────────────────────────

    @Test
    void testGetPerformanceFeedback() {
        assertEquals("Good performance. Continue with consistent effort.", service.getPerformanceFeedback(85));
    }

    @Test
    void testFeedbackExcellent() {
        assertEquals("Excellent performance! Keep up the outstanding work.", service.getPerformanceFeedback(90.0));
        assertEquals("Excellent performance! Keep up the outstanding work.", service.getPerformanceFeedback(100.0));
    }

    @Test
    void testFeedbackExcellentAtBoundary() {
        assertEquals("Excellent performance! Keep up the outstanding work.", service.getPerformanceFeedback(90.0));
        assertEquals("Good performance. Continue with consistent effort.", service.getPerformanceFeedback(89.9));
    }

    @Test
    void testFeedbackGood() {
        assertEquals("Good performance. Continue with consistent effort.", service.getPerformanceFeedback(80.0));
        assertEquals("Good performance. Continue with consistent effort.", service.getPerformanceFeedback(89.9));
    }

    @Test
    void testFeedbackSatisfactory() {
        assertEquals("Satisfactory performance. Consider focusing on weaker areas.", service.getPerformanceFeedback(70.0));
        assertEquals("Satisfactory performance. Consider focusing on weaker areas.", service.getPerformanceFeedback(79.9));
    }

    @Test
    void testFeedbackNeedsImprovement() {
        assertEquals("Needs improvement. Dedicate more effort to your studies.", service.getPerformanceFeedback(60.0));
        assertEquals("Needs improvement. Dedicate more effort to your studies.", service.getPerformanceFeedback(69.9));
    }

    @Test
    void testFeedbackPoor() {
        assertEquals("Poor performance. Seek additional help and resources.", service.getPerformanceFeedback(59.9));
        assertEquals("Poor performance. Seek additional help and resources.", service.getPerformanceFeedback(0.0));
    }
}
