import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class IntegrationTest {

    @Test
    public void testEndToEndWorkflow() {
        // Setup test data
        Student student = new Student("John Doe", 90);
        GradeCalculator calculator = new GradeCalculator();
        FeedbackGenerator feedbackGenerator = new FeedbackGenerator();

        // Step 1: Calculate grade
        String grade = calculator.calculateGrade(student);
        assertEquals("A", grade);

        // Step 2: Generate feedback
        String feedback = feedbackGenerator.generateFeedback(student);
        assertNotNull(feedback);

        // Verify complete workflow
        System.out.println("Grade: " + grade);
        System.out.println("Feedback: " + feedback);
    }
}