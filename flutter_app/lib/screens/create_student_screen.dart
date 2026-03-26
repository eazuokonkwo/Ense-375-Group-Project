import 'package:flutter/material.dart';
import '../models/assessment.dart';
import '../models/student.dart';
import '../services/grade_service.dart';
import '../services/storage_service.dart';

class CreateStudentContent extends StatefulWidget {
  final Function(Student) onSaved;

  const CreateStudentContent({super.key, required this.onSaved});

  @override
  State<CreateStudentContent> createState() => _CreateStudentContentState();
}

class _CreateStudentContentState extends State<CreateStudentContent> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _storage = StorageService();
  final List<_AssessmentFormRow> _rows = [_AssessmentFormRow()];

  void _addAssessment() {
    setState(() => _rows.add(_AssessmentFormRow()));
  }

  Future<void> _calculateAndSave() async {
    try {
      final assessments = _rows.map((row) {
        return Assessment(
          name: row.nameController.text,
          score: double.parse(row.scoreController.text),
          weight: double.parse(row.weightController.text),
        );
      }).toList();

      GradeService.validateStudent(
        _idController.text,
        _nameController.text,
        assessments,
      );

      final student = Student(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        assessments: assessments,
      );

      await _storage.saveStudent(student);
      widget.onSaved(student);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Student Record',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter student details and assessment information to calculate and save a report.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          _card(
            child: Row(
              children: [
                Expanded(child: _field(_idController, 'Student ID')),
                const SizedBox(width: 16),
                Expanded(child: _field(_nameController, 'Student Name')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assessments',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                ..._rows.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _field(
                            row.nameController,
                            'Assessment ${index + 1}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            row.scoreController,
                            'Score',
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            row.weightController,
                            'Weight %',
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _addAssessment,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Assessment'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _calculateAndSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1456C1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Calculate & Save',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(22),
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
      child: child,
    );
  }

  Widget _field(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8FAFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _AssessmentFormRow {
  final nameController = TextEditingController();
  final scoreController = TextEditingController();
  final weightController = TextEditingController();
}