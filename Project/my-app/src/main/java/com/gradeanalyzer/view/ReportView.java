package com.gradeanalyzer.view;

public class ReportView {

    public void displayDetailedReport(String report) {
        System.out.println("\n========================================");
        System.out.println("DETAILED REPORT");
        System.out.println("========================================");
        System.out.println(report);
        System.out.println("========================================");
    }

    public void displayStatistics(String statistics) {
        System.out.println("\n--- STATISTICS ---");
        System.out.println(statistics);
    }

    public void displayComparison(String comparison) {
        System.out.println("\n--- COMPARISON ---");
        System.out.println(comparison);
    }
}
