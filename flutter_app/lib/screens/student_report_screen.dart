import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/grade_service.dart';

class StudentReportContent extends StatelessWidget {
  final Student student;
  const StudentReportContent({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final finalGrade = GradeService.calculateFinalGrade(student.assessments);
    final letterGrade = GradeService.getLetterGrade(finalGrade);
    final standing = GradeService.getStanding(finalGrade);
    final average = GradeService.getAverageScore(student.assessments);
    final highest = GradeService.getHighestScore(student.assessments);
    final lowest = GradeService.getLowestScore(student.assessments);
    final feedback = GradeService.getFeedback(finalGrade);

    final standingColor =
        standing == 'Pass' ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final gradeColor = _gradeColor(finalGrade);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Performance Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A modern summary of academic performance, results, and assessment breakdown.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 1100;

                  if (!isWide) {
                    return Column(
                      children: [
                        _profileCard(
                          student,
                          standing,
                          standingColor,
                          average,
                          finalGrade,
                        ),
                        const SizedBox(height: 20),
                        _statsAndSnapshot(
                          finalGrade: finalGrade,
                          letterGrade: letterGrade,
                          standing: standing,
                          gradeColor: gradeColor,
                          standingColor: standingColor,
                          average: average,
                          highest: highest,
                          lowest: lowest,
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: _profileCard(
                          student,
                          standing,
                          standingColor,
                          average,
                          finalGrade,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _statsAndSnapshot(
                          finalGrade: finalGrade,
                          letterGrade: letterGrade,
                          standing: standing,
                          gradeColor: gradeColor,
                          standingColor: standingColor,
                          average: average,
                          highest: highest,
                          lowest: lowest,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              _sectionCard(
                title: 'Assessment Breakdown',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${student.assessments.length} item${student.assessments.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: Color(0xFF1456C1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                child: _assessmentTable(student),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return Column(
                      children: [
                        _sectionCard(
                          title: 'Feedback',
                          child: _feedbackCard(feedback, finalGrade),
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Quick Summary',
                          child: _quickSummary(
                            student: student,
                            average: average,
                            finalGrade: finalGrade,
                            letterGrade: letterGrade,
                            standing: standing,
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _sectionCard(
                          title: 'Feedback',
                          child: _feedbackCard(feedback, finalGrade),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _sectionCard(
                          title: 'Quick Summary',
                          child: _quickSummary(
                            student: student,
                            average: average,
                            finalGrade: finalGrade,
                            letterGrade: letterGrade,
                            standing: standing,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsAndSnapshot({
    required double finalGrade,
    required String letterGrade,
    required String standing,
    required Color gradeColor,
    required Color standingColor,
    required double average,
    required double highest,
    required double lowest,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                'Final Grade',
                '${finalGrade.toStringAsFixed(2)}%',
                Icons.analytics_rounded,
                gradeColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _statCard(
                'Letter Grade',
                letterGrade,
                Icons.school_rounded,
                gradeColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _statCard(
                'Standing',
                standing,
                Icons.verified_rounded,
                standingColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _miniStatCard(
                'Average Score',
                average.toStringAsFixed(2),
                Icons.bar_chart_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _miniStatCard(
                'Highest Score',
                highest.toStringAsFixed(2),
                Icons.arrow_upward_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _miniStatCard(
                'Lowest Score',
                lowest.toStringAsFixed(2),
                Icons.arrow_downward_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _performanceCard(
          finalGrade: finalGrade,
          standing: standing,
          standingColor: standingColor,
        ),
      ],
    );
  }

  Widget _assessmentTable(Student student) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Assessment',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Score',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Weight',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Contribution',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...student.assessments.asMap().entries.map((entry) {
          final index = entry.key;
          final a = entry.value;
          final contribution = a.score * (a.weight / 100);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: index.isEven ? Colors.white : const Color(0xFFFBFCFE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Color(0x08000000),
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFFE8F0FF),
                        child: Text(
                          a.name.isNotEmpty ? a.name[0].toUpperCase() : 'A',
                          style: const TextStyle(
                            color: Color(0xFF1456C1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          a.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _tableBadge(
                    '${a.score.toStringAsFixed(0)}%',
                    const Color(0xFFE8F0FF),
                    const Color(0xFF1456C1),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _tableBadge(
                    '${a.weight.toStringAsFixed(0)}%',
                    const Color(0xFFEEF2FF),
                    const Color(0xFF4338CA),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${contribution.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: (a.score.clamp(0, 100)) / 100,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _gradeColor(a.score),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Weighted contribution',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _feedbackCard(String feedback, double finalGrade) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1456C1), Color(0xFF3D8BFF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Insight',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            finalGrade >= 70
                ? 'Keep maintaining this performance.'
                : 'Focus on improving weaker assessments.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickSummary({
    required Student student,
    required double average,
    required double finalGrade,
    required String letterGrade,
    required String standing,
  }) {
    return Column(
      children: [
        _summaryRow('Student', student.name),
        const SizedBox(height: 12),
        _summaryRow('ID', student.id),
        const SizedBox(height: 12),
        _summaryRow('Assessments', '${student.assessments.length}'),
        const SizedBox(height: 12),
        _summaryRow('Average', '${average.toStringAsFixed(1)}%'),
        const SizedBox(height: 12),
        _summaryRow('Final Grade', '${finalGrade.toStringAsFixed(1)}%'),
        const SizedBox(height: 12),
        _summaryRow('Letter Grade', letterGrade),
        const SizedBox(height: 12),
        _summaryRow('Standing', standing),
      ],
    );
  }

  Color _gradeColor(double grade) {
    if (grade >= 80) return const Color(0xFF16A34A);
    if (grade >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
  }

  Widget _profileCard(
    Student student,
    String standing,
    Color standingColor,
    double average,
    double finalGrade,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFE8F0FF),
            child: Icon(Icons.person, size: 42, color: Color(0xFF1456C1)),
          ),
          const SizedBox(height: 16),
          Text(
            student.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Student ID: ${student.id}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: standingColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              standing,
              style: TextStyle(
                color: standingColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          _profileInfoRow('Assessments', '${student.assessments.length}'),
          _profileInfoRow('Average', '${average.toStringAsFixed(1)}%'),
          _profileInfoRow('Final Grade', '${finalGrade.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _profileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
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
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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

  Widget _miniStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8F0FF),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF1456C1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _performanceCard({
    required double finalGrade,
    required String standing,
    required Color standingColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Snapshot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (finalGrade.clamp(0, 100)) / 100,
              minHeight: 12,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(standingColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${finalGrade.toStringAsFixed(1)}% overall performance',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            standing == 'Pass'
                ? 'The student is currently meeting the minimum academic requirement.'
                : 'The student is currently below the passing threshold and needs support.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _assessmentBadge(String text, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _tableBadge(String text, Color background, Color foreground) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}