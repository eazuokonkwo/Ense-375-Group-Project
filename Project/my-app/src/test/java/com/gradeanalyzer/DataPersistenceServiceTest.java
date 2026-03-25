import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.io.FileNotFoundException;
import java.io.IOException;

public class DataPersistenceServiceTest {
    private DataPersistenceService dataPersistenceService;
    private String testFilePath = "testdata.txt";

    @BeforeEach
    public void setUp() {
        dataPersistenceService = new DataPersistenceService();
    }

    @Test
    public void testSaveData_ShouldSaveDataSuccessfully() throws IOException {
        String dataToSave = "Test data";
        dataPersistenceService.saveData(testFilePath, dataToSave);
        String loadedData = dataPersistenceService.loadData(testFilePath);
        assertEquals(dataToSave, loadedData,"Data loaded does not match data saved!");
    }

    @Test
    public void testLoadData_FileNotFound_ShouldThrowException() {
        Exception exception = assertThrows(FileNotFoundException.class, () -> {
            dataPersistenceService.loadData("nonexistentfile.txt");
        });
        assertEquals("File not found: nonexistentfile.txt", exception.getMessage());
    }

    @Test
    public void testSaveData_InvalidPath_ShouldThrowException() {
        String invalidPath = "/invalidpath/testdata.txt";
        Exception exception = assertThrows(IOException.class, () -> {
            dataPersistenceService.saveData(invalidPath, "Test data");
        });
        assertEquals("Invalid file path: /invalidpath/testdata.txt", exception.getMessage());
    }
}