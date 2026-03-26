import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/storage_service.dart';

class StudentsListContent extends StatelessWidget {
  final List<Student> students;
  final Future<void> Function() onRefresh;
  final Function(Student) onViewStudent;

  const StudentsListContent({
    super.key,
    required this.students,
    required this.onRefresh,
    required this.onViewStudent,
  });

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Records',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse saved student records, open full reports, or remove records.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          students.isEmpty
              ? _emptyState()
              : Column(
                  children: students.map((student) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 14,
                            color: Colors.black12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFE8F0FF),
                            child: Icon(Icons.person, color: Color(0xFF1456C1)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${student.id}',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => onViewStudent(student),
                            child: const Text('View'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await storage.deleteStudent(student.id);
                              await onRefresh();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.folder_open_rounded, size: 48, color: Color(0xFF1456C1)),
          SizedBox(height: 16),
          Text(
            'No student records found',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Create a student record first to see it listed here.',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}