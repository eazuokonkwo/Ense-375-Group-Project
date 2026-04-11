# Student Grade Analyser

A course project for **ENSE 375 – Software Testing and Validation** that evolved from a console-based student grading system into a modern **Flutter web application**. The system allows users to create student records, add weighted assessments, calculate final grades, and view detailed reports with persistent local storage.

---

## Team Members

- **Ebelechukwu Azu-Okonkwo**  
- **Gbolabo Ogunrinde**  
- **Abdulkarim Fattal**  
- **Oluchukwu Ogana**

---

## Project Overview

The Student Grade Analyser was developed to improve the process of managing and evaluating academic grades. In many educational settings, grades are still handled manually or through basic spreadsheets, which can be inefficient and prone to human error. This project provides a more structured and reliable solution through automated grade calculation, validation, and reporting.

This repository contains:

- a **console application** version of the project
- a **Flutter web application** version inside the `flutter_app/` folder

The Flutter version is the main UI-based implementation and represents the more polished, user-facing system.

---

## Objectives

The main objectives of this project are to:

- store and manage student records
- support multiple assessments per student
- validate assessment weights and scores
- calculate final grades automatically
- generate student performance summaries
- present data in a clean and modern interface
- persist records locally without third-party servers

---

## Features

### Core Features
- Add a new student
- Add one or more assessments for each student
- Assign a score and weight to each assessment
- Automatically calculate final grades
- Display letter grades
- Display pass/fail standing
- View student records
- Delete student records
- Generate detailed student performance reports
- Persist data locally using `SharedPreferences`

### Flutter UI Features
- Modern dashboard layout
- Sidebar navigation
- Dynamic assessment form
- Records page with expandable student details
- Reports page with summary cards and performance insights
- Individual student report page
- Local persistence across sessions

---

## Testing

This project was built for **ENSE 375 – Software Testing and Validation** and includes a comprehensive test suite covering both implementations.

| Project | Test Files | Tests | Coverage Areas |
|---|---|---|---|
| Java console app | 10 | 144 | Models, services, controller, persistence, view, integration |
| Flutter web app | 6 | 133 | Grade service, models, storage, calculations, widget smoke test |
| **Total** | **16** | **277** | |

### Running Java Tests
```bash
cd Project/my-app
mvn test
```

### Running Flutter Tests
```bash
cd flutter_app
flutter test
```

---

## Repository Structure

```text
Ense-375-Group-Project/
│
├── flutter_app/                    # Flutter web application (primary deliverable)
│   ├── lib/
│   │   ├── models/
│   │   │   ├── student.dart
│   │   │   └── assessment.dart
│   │   ├── services/
│   │   │   ├── grade_service.dart
│   │   │   └── storage_service.dart
│   │   ├── screens/
│   │   │   └── student_report_screen.dart
│   │   ├── app_shell.dart
│   │   └── main.dart
│   ├── test/                       # Flutter test suite (133 tests)
│   │   ├── widget_test.dart
│   │   ├── grade_service_test.dart
│   │   ├── grade_calculations_test.dart
│   │   ├── assessment_model_test.dart
│   │   ├── student_model_test.dart
│   │   └── storage_service_test.dart
│   ├── web/
│   └── pubspec.yaml
│
├── Project/
│   └── my-app/                     # Java console application
│       ├── src/
│       │   ├── main/java/com/gradeanalyzer/
│       │   │   ├── controller/     # GradeController
│       │   │   ├── model/          # Student, Assessment
│       │   │   ├── service/        # GradeCalculator, GradeValidator, etc.
│       │   │   ├── view/           # ConsoleView
│       │   │   ├── Main.java
│       │   │   └── InteractiveGradeAnalyzer.java
│       │   └── test/java/com/gradeanalyzer/
│       │       ├── AssessmentTest.java
│       │       ├── StudentTest.java
│       │       ├── GradeCalculatorTest.java
│       │       ├── GradeValidatorTest.java
│       │       ├── GradeAnalysisServiceTest.java
│       │       ├── GradeReportServiceTest.java
│       │       ├── GradeControllerTest.java
│       │       ├── DataPersistenceServiceTest.java
│       │       ├── ConsoleViewTest.java
│       │       └── IntegrationTest.java
│       └── pom.xml
│
├── assets/                         # Project diagrams and images
├── LICENSE
└── README.md
