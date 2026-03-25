import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class GradeAnalysisServiceTest {

    private final GradeAnalysisService service = new GradeAnalysisService();

    @Test
    public void testCalculateAverageScore() {
        double result = service.calculateAverageScore(new int[]{90, 80, 70, 60});
        assertEquals(75.0, result, "The average score should be 75.0");
    }

    @Test
    public void testGetHighestScore() {
        int result = service.getHighestScore(new int[]{90, 80, 70, 60});
        assertEquals(90, result, "The highest score should be 90");
    }

    @Test
    public void testGetLowestScore() {
        int result = service.getLowestScore(new int[]{90, 80, 70, 60});
        assertEquals(60, result, "The lowest score should be 60");
    }

    @Test
    public void testGetPerformanceFeedback() {
        String feedback = service.getPerformanceFeedback(85);
        assertEquals("Good job!", feedback, "Feedback for score 85 should be 'Good job!'");
    }
}
