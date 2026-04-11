package com.gradeanalyzer.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import com.gradeanalyzer.model.Assessment;
import com.gradeanalyzer.model.Student;

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
            String countLine = reader.readLine();

            if (id == null || name == null || countLine == null) {
                throw new IOException("Malformed student file: " + studentId);
            }

            int count;
            try {
                count = Integer.parseInt(countLine.trim());
            } catch (NumberFormatException e) {
                throw new IOException("Malformed student file: invalid assessment count in " + studentId, e);
            }

            Student student = new Student(id, name);
            List<Assessment> assessments = new ArrayList<>();

            for (int i = 0; i < count; i++) {
                String line = reader.readLine();
                if (line == null) {
                    throw new IOException("Malformed student file: missing assessment data in " + studentId);
                }
                String[] parts = line.split("\\|");
                if (parts.length < 3) {
                    throw new IOException("Malformed student file: invalid assessment format in " + studentId);
                }
                try {
                    assessments.add(new Assessment(parts[0], Double.parseDouble(parts[1]), Double.parseDouble(parts[2])));
                } catch (NumberFormatException e) {
                    throw new IOException("Malformed student file: invalid numeric value in " + studentId, e);
                }
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
