package com.gradeanalyzer;

import com.gradeanalyzer.model.Student;
import com.gradeanalyzer.service.GradeReportService;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class GradeReportServiceTest {

    @Test
    void testGenerateReport() {
        GradeReportService service = new GradeReportService();
        Student student = new Student("1", "Olly");

        String report = service.generateReport(
                student,
                85.0,
                "A",
                "Pass",
                84.0,
                90.0,
                78.0,
                "Good performance."
        );

        assertTrue(report.contains("Olly"));
        assertTrue(report.contains("Final Grade: 85.00%"));
    }
}
