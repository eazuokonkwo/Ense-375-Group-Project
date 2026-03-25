package com.gradeanalyzer.model;

public class Assessment {
    private String name;
    private double score;
    private double weight;

    public Assessment() {
    }

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

    public void setName(String name) {
        this.name = name;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    @Override
    public String toString() {
        return String.format("%s - Score: %.2f, Weight: %.2f%%", name, score, weight);
    }
}
