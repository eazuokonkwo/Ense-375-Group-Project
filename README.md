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

## Repository Structure

```text
Ense-375-Group-Project/
│
├── flutter_app/                 # Flutter web app version
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
│   ├── web/
│   ├── pubspec.yaml
│   └── ...
│
└── console_app/ or existing console files   # Console-based project version
