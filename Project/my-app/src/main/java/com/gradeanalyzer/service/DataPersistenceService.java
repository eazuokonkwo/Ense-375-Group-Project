package com.gradeanalyzer.service;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class DataPersistenceService {
    private static final String DATA_DIR = "student_data";

    public DataPersistenceService() {
        File dir = new File(DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    public void saveStudent(Student student) throws IOException {
        Path path = Paths.get(DATA_DIR, student.getId() + ".txt");

        try (BufferedWriter writer = Files.newBufferedWriter(path)) {
            writer.write(student.getId());
            writer.newLine();
            writer.write(student.getName());
            writer.newLine();
            writer.write(String.valueOf(student.getAssessments().size()));
            writer.newLine();

            for (Assessment assessment : student.getAssessments()) {
                writer.write(assessment.getName() + "|" + assessment.getScore() + "|" + assessment.getWeight());
                writer.newLine();
            }
        }
    }

    public Student loadStudent(String studentId) throws IOException {
        Path path = Paths.get(DATA_DIR, studentId + ".txt");
        if (!Files.exists(path)) {
            throw new FileNotFoundException("Student record not found.");
        }

        try (BufferedReader reader = Files.newBufferedReader(path)) {
            String id = reader.readLine();
            String name = reader.readLine();
            int count = Integer.parseInt(reader.readLine());

            Student student = new Student(id, name);
            List<Assessment> assessments = new ArrayList<>();

            for (int i = 0; i < count; i++) {
                String line = reader.readLine();
                String[] parts = line.split("\\|");
                assessments.add(new Assessment(parts[0], Double.parseDouble(parts[1]), Double.parseDouble(parts[2])));
            }

            student.setAssessments(assessments);
            return student;
        }
    }

    public List<String> listStudentIds() {
        List<String> ids = new ArrayList<>();
        File dir = new File(DATA_DIR);
        File[] files = dir.listFiles();

        if (files != null) {
            for (File file : files) {
                if (file.isFile() && file.getName().endsWith(".txt")) {
                    ids.add(file.getName().replace(".txt", ""));
                }
            }
        }

        return ids;
    }

    public boolean deleteStudent(String studentId) {
        File file = new File(DATA_DIR, studentId + ".txt");
        return file.exists() && file.delete();
    }
}
