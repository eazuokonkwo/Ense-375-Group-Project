import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.io.File;
import java.io.IOException;

public class DataPersistenceService {

    private static final String DATA_FILE_PATH = "student_data.json";
    private ObjectMapper objectMapper;

    public DataPersistenceService() {
        this.objectMapper = new ObjectMapper();
    }

    public void saveStudentData(Student student) throws IOException {
        JsonNode studentData = objectMapper.valueToTree(student);
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(new File(DATA_FILE_PATH), studentData);
    }

    public Student loadStudentData() throws IOException {
        return objectMapper.readValue(new File(DATA_FILE_PATH), Student.class);
    }

    public void deleteStudentData() {
        File file = new File(DATA_FILE_PATH);
        if (file.exists()) {
            file.delete();
        }
    }
}

class Student {
    private String name;
    private int grade;

    // Constructors, getters, and setters
    public Student() {}
    public Student(String name, int grade) {
        this.name = name;
        this.grade = grade;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getGrade() {
        return grade;
    }
    public void setGrade(int grade) {
        this.grade = grade;
    }
}
