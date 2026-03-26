import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  final bool isLoading;
  final int totalStudents;
  final double averageGrade;
  final int passCount;
  final VoidCallback onCreateStudent;
  final VoidCallback onViewRecords;

  const DashboardContent({
    super.key,
    required this.isLoading,
    required this.totalStudents,
    required this.averageGrade,
    required this.passCount,
    required this.onCreateStudent,
    required this.onViewRecords,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            Row(
              children: [
                Expanded(
                  child: _dashboardStatCard(
                    'Total Students',
                    totalStudents.toString(),
                    Icons.people_alt_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _dashboardStatCard(
                    'Average Grade',
                    '${averageGrade.toStringAsFixed(1)}%',
                    Icons.analytics_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _dashboardStatCard(
                    'Average Passes',
                    passCount.toString(),
                    Icons.check_circle_rounded,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 28),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _dashboardActionCard(
                  title: 'Create Student',
                  subtitle: 'Add a new student and enter assessments.',
                  icon: Icons.person_add_alt_1_rounded,
                  onTap: onCreateStudent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _dashboardActionCard(
                  title: 'View Records',
                  subtitle: 'Browse saved students and open reports.',
                  icon: Icons.folder_shared_rounded,
                  onTap: onViewRecords,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Use the dashboard to create student records, calculate weighted grades, review assessment statistics, and manage saved reports.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
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