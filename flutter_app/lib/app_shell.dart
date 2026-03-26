import 'package:flutter/material.dart';
import 'models/student.dart';
import 'models/assessment.dart';
import 'services/storage_service.dart';
import 'screens/student_report_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final StorageService _storageService = StorageService();

  int _selectedIndex = 0;
  bool _isLoading = true;
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    final students = await _storageService.getStudents();

    if (!mounted) return;

    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  Future<void> _saveStudent(Student student) async {
    await _storageService.saveStudent(student);
    await _loadStudents();

    if (!mounted) return;

    setState(() {
      _selectedIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student saved successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteStudent(String id) async {
    await _storageService.deleteStudent(id);
    await _loadStudents();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  int get totalStudents => _students.length;

  double get averageGrade {
    if (_students.isEmpty) return 0;
    final total = _students.fold<double>(
      0,
      (sum, student) => sum + _calculateFinalGrade(student),
    );
    return total / _students.length;
  }

  int get passCount =>
      _students.where((student) => _calculateFinalGrade(student) >= 50).length;

  double get passRate {
    if (_students.isEmpty) return 0;
    return (passCount / _students.length) * 100;
  }

  double _calculateFinalGrade(Student student) {
    if (student.assessments.isEmpty) return 0;

    double weightedTotal = 0;
    double totalWeight = 0;

    for (final assessment in student.assessments) {
      weightedTotal += assessment.score * (assessment.weight / 100);
      totalWeight += assessment.weight;
    }

    if (totalWeight == 0) return 0;

    return weightedTotal;
  }

  void _goToDashboard() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _goToAddStudent() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _goToRecords() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardContent(
        isLoading: _isLoading,
        totalStudents: totalStudents,
        averageGrade: averageGrade,
        passCount: passCount,
        passRate: passRate,
        onCreateStudent: _goToAddStudent,
        onViewRecords: _goToRecords,
        onRefresh: _loadStudents,
      ),
      AddStudentPage(
        onSave: _saveStudent,
        onCancel: _goToDashboard,
      ),
      RecordsPage(
        isLoading: _isLoading,
        students: _students,
        calculateFinalGrade: _calculateFinalGrade,
        onDelete: _deleteStudent,
      ),
      ReportsPage(
        students: _students,
        calculateFinalGrade: _calculateFinalGrade,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddStudent,
        backgroundColor: const Color(0xFF1456C1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) {
                    return FadeTransition(
                        opacity: animation,
                        child: child,
                    );
                    },
                    layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                        alignment: Alignment.topLeft,
                        children: [
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                        ],
                    );
                    },
                    child: SizedBox.expand(
                    key: ValueKey(_selectedIndex),
                        child: Container(
                            color: const Color(0xFFF5F7FB),
                            alignment: Alignment.topLeft,
                            child: pages[_selectedIndex],
                        ),
                    ),
                ),
            ),      
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 270,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1456C1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Student Grade Analyser',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _navItem(index: 0, icon: Icons.dashboard_rounded, label: 'Dashboard'),
          _navItem(
            index: 1,
            icon: Icons.person_add_alt_1_rounded,
            label: 'Add Student',
          ),
          _navItem(
            index: 2,
            icon: Icons.folder_shared_rounded,
            label: 'Records',
          ),
          _navItem(index: 3, icon: Icons.bar_chart_rounded, label: 'Reports'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olly Ogana',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Project Owner',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? const Color(0xFF1456C1) : Colors.white70,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? const Color(0xFF1456C1) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final bool isLoading;
  final int totalStudents;
  final double averageGrade;
  final int passCount;
  final double passRate;
  final VoidCallback onCreateStudent;
  final VoidCallback onViewRecords;
  final Future<void> Function() onRefresh;

  const DashboardContent({
    super.key,
    required this.isLoading,
    required this.totalStudents,
    required this.averageGrade,
    required this.passCount,
    required this.passRate,
    required this.onCreateStudent,
    required this.onViewRecords,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage student records, calculate grades, and review reports from one place.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: 240,
                    child: _dashboardStatCard(
                      'Total Students',
                      totalStudents.toString(),
                      Icons.people_alt_rounded,
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: _dashboardStatCard(
                      'Average Grade',
                      '${averageGrade.toStringAsFixed(1)}%',
                      Icons.analytics_rounded,
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: _dashboardStatCard(
                      'Students Passed',
                      passCount.toString(),
                      Icons.check_circle_rounded,
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: _dashboardStatCard(
                      'Pass Rate',
                      '${passRate.toStringAsFixed(1)}%',
                      Icons.trending_up_rounded,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _dashboardActionCard(
                    title: 'Create Student',
                    subtitle: 'Add a student and assessment scores.',
                    icon: Icons.person_add_alt_1_rounded,
                    onTap: onCreateStudent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _dashboardActionCard(
                    title: 'View Records',
                    subtitle: 'Browse saved student records.',
                    icon: Icons.folder_shared_rounded,
                    onTap: onViewRecords,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentPage extends StatefulWidget {
  final Future<void> Function(Student student) onSave;
  final VoidCallback onCancel;

  const AddStudentPage({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final List<_AssessmentInputRow> _assessmentRows = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _addAssessmentRow(name: 'Assignment', weight: '30');
    _addAssessmentRow(name: 'Midterm', weight: '30');
    _addAssessmentRow(name: 'Final Exam', weight: '40');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    for (final row in _assessmentRows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addAssessmentRow({String name = '', String weight = ''}) {
    setState(() {
      _assessmentRows.add(
        _AssessmentInputRow(
          nameController: TextEditingController(text: name),
          scoreController: TextEditingController(),
          weightController: TextEditingController(text: weight),
        ),
      );
    });
  }

  void _removeAssessmentRow(int index) {
    if (_assessmentRows.length == 1) return;
    setState(() {
      _assessmentRows[index].dispose();
      _assessmentRows.removeAt(index);
    });
  }

  double _toDouble(String value) => double.tryParse(value.trim()) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final assessments = _assessmentRows.map((row) {
      return Assessment(
        name: row.nameController.text.trim(),
        score: _toDouble(row.scoreController.text),
        weight: _toDouble(row.weightController.text),
      );
    }).toList();

    final student = Student(
      id: _studentIdController.text.trim().isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : _studentIdController.text.trim(),
      name: _nameController.text.trim(),
      assessments: assessments,
    );

    await widget.onSave(student);

    if (!mounted) return;

    _nameController.clear();
    _studentIdController.clear();

    for (final row in _assessmentRows) {
      row.dispose();
    }
    _assessmentRows.clear();

    setState(() {
      _isSaving = false;
      _addAssessmentRow(name: 'Assignment', weight: '30');
      _addAssessmentRow(name: 'Midterm', weight: '30');
      _addAssessmentRow(name: 'Final Exam', weight: '40');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              color: Colors.black12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Student',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter student details and add as many assessments as needed.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _formField(
                      controller: _nameController,
                      label: 'Student Name',
                      hint: 'Enter full name',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _formField(
                      controller: _studentIdController,
                      label: 'Student ID',
                      hint: 'Enter ID',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Assessments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _addAssessmentRow(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Assessment'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(_assessmentRows.length, (index) {
                final row = _assessmentRows[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _assessmentRow(
                    index: index,
                    row: row,
                    canRemove: _assessmentRows.length > 1,
                    onRemove: () => _removeAssessmentRow(index),
                  ),
                );
              }),
              const SizedBox(height: 28),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _isSaving ? null : widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1456C1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isSaving ? 'Saving...' : 'Save Student'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _assessmentRow({
    required int index,
    required _AssessmentInputRow row,
    required bool canRemove,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Assessment ${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _formField(
                  controller: row.nameController,
                  label: 'Assessment Name',
                  hint: 'Quiz, Project, Final...',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _formField(
                  controller: row.scoreController,
                  label: 'Score',
                  hint: '0 - 100',
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _formField(
                  controller: row.weightController,
                  label: 'Weight %',
                  hint: 'e.g. 25',
                  isNumber: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1456C1), width: 1.4),
        ),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return 'Required';

        if (isNumber) {
          final number = double.tryParse(text);
          if (number == null) return 'Enter a valid number';
          if (number < 0 || number > 100) return 'Must be 0 - 100';
        }

        return null;
      },
    );
  }
}

class _AssessmentInputRow {
  final TextEditingController nameController;
  final TextEditingController scoreController;
  final TextEditingController weightController;

  _AssessmentInputRow({
    required this.nameController,
    required this.scoreController,
    required this.weightController,
  });

  void dispose() {
    nameController.dispose();
    scoreController.dispose();
    weightController.dispose();
  }
}

class RecordsPage extends StatelessWidget {
  final bool isLoading;
  final List<Student> students;
  final double Function(Student) calculateFinalGrade;
  final Future<void> Function(String id) onDelete;

  const RecordsPage({
    super.key,
    required this.isLoading,
    required this.students,
    required this.calculateFinalGrade,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              color: Colors.black12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            : students.isEmpty
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Records',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No student records available yet.',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Records',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...students.map(
                        (student) => Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: ExpansionTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(student.name),
                            subtitle: Text(
                              'ID: ${student.id}\nFinal Grade: ${calculateFinalGrade(student).toStringAsFixed(1)}%',
                            ),
                            childrenPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              ...student.assessments.map(
                                (assessment) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          assessment.name,
                                          style: const TextStyle(
                                            color: Color(0xFF374151),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Score: ${assessment.score.toStringAsFixed(1)}',
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Weight: ${assessment.weight.toStringAsFixed(1)}%',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => Scaffold(
                                            backgroundColor:
                                                const Color(0xFFF5F7FB),
                                            appBar: AppBar(
                                              title: const Text('Student Report'),
                                            ),
                                            body: StudentReportContent(
                                              student: student,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.visibility_outlined),
                                    label: const Text('Open Report'),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded),
                                    onPressed: () => onDelete(student.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  final List<Student> students;
  final double Function(Student) calculateFinalGrade;

  const ReportsPage({
    super.key,
    required this.students,
    required this.calculateFinalGrade,
  });

  @override
  Widget build(BuildContext context) {
    final passed = students.where((s) => calculateFinalGrade(s) >= 50).length;
    final failed = students.where((s) => calculateFinalGrade(s) < 50).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              color: Colors.black12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Records: ${students.length}\nPassed: $passed\nFailed: $failed',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            ...students.map(
              (student) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(student.name),
                  subtitle: Text(
                    'Final Grade: ${calculateFinalGrade(student).toStringAsFixed(1)}%',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          backgroundColor: const Color(0xFFF5F7FB),
                          appBar: AppBar(
                            title: const Text('Student Report'),
                          ),
                          body: StudentReportContent(student: student),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dashboardStatCard(String title, String value, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1456C1), Color(0xFF3D8BFF)],
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          blurRadius: 16,
          color: Colors.black12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _dashboardActionCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(24),
    onTap: onTap,
    child: Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE8F0FF),
            child: Icon(
              icon,
              color: const Color(0xFF1456C1),
              size: 26,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}