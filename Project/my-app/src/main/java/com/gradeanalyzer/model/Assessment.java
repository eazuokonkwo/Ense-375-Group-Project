package com.gradeanalyzer.model;

/**
 * Represents one assessment item such as an assignment, midterm, or final exam.
 */
public class Assessment {
    private String name;
    private double score;
    private double weight;

    public Assessment(String name, double score, double weight) {
        this.name = name;
        this.score = score;
        this.weight = weight;
    }

    public String getName() {
        return name;
    }

    public double getScore() {
        return score;
    }

    public double getWeight() {
        return weight;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }
}