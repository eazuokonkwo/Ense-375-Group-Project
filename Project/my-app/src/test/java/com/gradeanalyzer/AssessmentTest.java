package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class AssessmentTest {

    @Test
    void testFullConstructor() {
        Assessment a = new Assessment("Quiz", 85.0, 20.0);
        assertEquals("Quiz", a.getName());
        assertEquals(85.0, a.getScore(), 0.0001);
        assertEquals(20.0, a.getWeight(), 0.0001);
    }

    @Test
    void testNoArgConstructorDefaultsAreNull() {
        Assessment a = new Assessment();
        assertNull(a.getName());
        assertEquals(0.0, a.getScore(), 0.0001);
        assertEquals(0.0, a.getWeight(), 0.0001);
    }

    @Test
    void testSetName() {
        Assessment a = new Assessment();
        a.setName("Midterm");
        assertEquals("Midterm", a.getName());
    }

    @Test
    void testSetScore() {
        Assessment a = new Assessment();
        a.setScore(72.5);
        assertEquals(72.5, a.getScore(), 0.0001);
    }

    @Test
    void testSetWeight() {
        Assessment a = new Assessment();
        a.setWeight(30.0);
        assertEquals(30.0, a.getWeight(), 0.0001);
    }

    @Test
    void testToStringContainsName() {
        Assessment a = new Assessment("Final Exam", 91.5, 50.0);
        assertTrue(a.toString().contains("Final Exam"));
    }

    @Test
    void testToStringContainsScore() {
        Assessment a = new Assessment("Final Exam", 91.5, 50.0);
        assertTrue(a.toString().contains("91.50"));
    }

    @Test
    void testToStringContainsWeight() {
        Assessment a = new Assessment("Final Exam", 91.5, 50.0);
        assertTrue(a.toString().contains("50.00"));
    }

    @Test
    void testSettersOverrideConstructorValues() {
        Assessment a = new Assessment("Original", 50.0, 25.0);
        a.setName("Updated");
        a.setScore(99.0);
        a.setWeight(100.0);
        assertEquals("Updated", a.getName());
        assertEquals(99.0, a.getScore(), 0.0001);
        assertEquals(100.0, a.getWeight(), 0.0001);
    }
}
