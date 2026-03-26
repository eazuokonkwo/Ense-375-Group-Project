import 'package:flutter/material.dart';
import 'app_shell.dart';

void main() {
  runApp(const StudentGradeAnalyserApp());
}

class StudentGradeAnalyserApp extends StatelessWidget {
  const StudentGradeAnalyserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Grade Analyser',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1456C1),
        ),
        fontFamily: 'Roboto',
      ),
      home: const AppShell(),
    );
  }
}