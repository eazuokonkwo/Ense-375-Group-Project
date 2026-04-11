package com.gradeanalyzer;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class StudentTest {

    @Test
    void testNoArgConstructorInitializesEmptyAssessmentList() {
        Student s = new Student();
        assertNotNull(s.getAssessments());
        assertTrue(s.getAssessments().isEmpty());
    }

    @Test
    void testNoArgConstructorIdAndNameAreNull() {
        Student s = new Student();
        assertNull(s.getId());
        assertNull(s.getName());
    }

    @Test
    void testTwoArgConstructorSetsIdAndName() {
        Student s = new Student("200001", "Jane Doe");
        assertEquals("200001", s.getId());
        assertEquals("Jane Doe", s.getName());
    }

    @Test
    void testTwoArgConstructorInitializesEmptyAssessmentList() {
        Student s = new Student("200001", "Jane Doe");
        assertNotNull(s.getAssessments());
        assertTrue(s.getAssessments().isEmpty());
    }

    @Test
    void testSetId() {
        Student s = new Student();
        s.setId("300001");
        assertEquals("300001", s.getId());
    }

    @Test
    void testSetName() {
        Student s = new Student();
        s.setName("John Smith");
        assertEquals("John Smith", s.getName());
    }

    @Test
    void testAddAssessmentIncreasesSize() {
        Student s = new Student("1", "Alice");
        s.addAssessment(new Assessment("Quiz", 80.0, 20.0));
        assertEquals(1, s.getAssessments().size());
    }

    @Test
    void testAddAssessmentStoresCorrectData() {
        Student s = new Student("1", "Alice");
        s.addAssessment(new Assessment("Quiz", 80.0, 20.0));
        assertEquals("Quiz", s.getAssessments().get(0).getName());
        assertEquals(80.0, s.getAssessments().get(0).getScore(), 0.0001);
    }

    @Test
    void testAddMultipleAssessments() {
        Student s = new Student("1", "Bob");
        s.addAssessment(new Assessment("Assignment", 70.0, 30.0));
        s.addAssessment(new Assessment("Final", 90.0, 70.0));
        assertEquals(2, s.getAssessments().size());
    }

    @Test
    void testSetAssessmentsReplacesExistingList() {
        Student s = new Student("1", "Carol");
        s.addAssessment(new Assessment("Old", 50.0, 100.0));

        List<Assessment> newList = new ArrayList<>();
        newList.add(new Assessment("New", 95.0, 100.0));
        s.setAssessments(newList);

        assertEquals(1, s.getAssessments().size());
        assertEquals("New", s.getAssessments().get(0).getName());
    }
}
