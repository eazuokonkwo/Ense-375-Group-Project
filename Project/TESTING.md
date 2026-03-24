# TESTING.md

## Overview
This document summarizes the testing approach used for the Student Grade Analyzer.  
The project emphasizes systematic validation through unit testing, integration testing, and black-box testing techniques, as required in ENSE 375. :contentReference[oaicite:2]{index=2}

## Function Chosen for White-Box Testing
The function selected for path testing and data flow testing is:

`calculateFinalGrade(List<Assessment> assessments)`

This function was chosen because it contains:
- input validation
- branching paths
- weighted calculation logic
- exception handling

## 1. Path Testing

### Independent Paths
P1: Assessment list is empty → exception thrown  
P2: Score is invalid → exception thrown  
P3: Weight is invalid → exception thrown  
P4: Total weight is not 100 → exception thrown  
P5: All inputs valid → final grade returned  

### Example Path Test Cases
- Empty list
- Score = -5
- Weight = 150
- Total weights = 80
- Valid list = returns correct weighted grade

## 2. Data Flow Testing

### Key Variables
- `assessments`
- `finalGrade`
- `score`
- `weight`

### Data Flow Focus
- variable definition
- variable usage
- computation updates
- output return

Example:
- `finalGrade` is initialized to 0
- updated inside loop
- returned after loop completes

## 3. Boundary Value Testing

### Grade Boundaries
- -1
- 0
- 1
- 49.99
- 50
- 50.01
- 99.99
- 100
- 101

### Weight Boundaries
- 0
- 1
- 99
- 100
- 101

## 4. Equivalence Class Testing

### Valid Classes
- scores from 0 to 100
- weights greater than 0 and less than or equal to 100
- total weights equal to 100
- non-empty assessment list

### Invalid Classes
- score < 0
- score > 100
- weight <= 0
- weight > 100
- total weight != 100
- empty assessment list

## 5. Decision Table Testing

| Condition | Result |
|---|---|
| Empty assessment list | Reject |
| Invalid score | Reject |
| Invalid weight | Reject |
| Weight total not 100 | Reject |
| All valid inputs | Accept and calculate |

## 6. State Transition Testing

### States
Input Entered → Validation → Calculation → Result Displayed

### Invalid Transition
Input Entered → Result Displayed  
This is prevented because validation must occur before calculation.

## 7. Use Case Testing

### Use Case: Calculate Student Final Grade
1. User enters assessment scores and weights
2. System validates scores
3. System validates weights
4. System checks total weight = 100
5. System calculates final grade
6. System displays final grade, letter grade, and standing

### Expected Outcome
The correct final grade is displayed if all inputs are valid.

## 8. Integration Testing
Integration testing was performed between:
- model and service layer
- service and controller layer
- controller and view layer

## 9. Tools Used
- JUnit 5
- Maven
- Manual console execution