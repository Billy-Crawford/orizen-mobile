// lib/features/student/presentation/student_dashboard.dart

import 'package:flutter/material.dart';
import '../../student/presentation/orientation_history_page.dart';
import '../../student/presentation/orientation_test_page.dart';
import '../data/student_service.dart';
import 'my_advisor_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final StudentService _service = StudentService();
  bool _loading = true;
  Map<String, dynamic>? _myAdvisor;

  @override
  void initState() {
    super.initState();
    _fetchMyAdvisor();
  }

  Future<void> _fetchMyAdvisor() async {
    try {
      final response = await _service.getMyAdvisor();
      setState(() {
        _myAdvisor = response.data;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Erreur fetch my advisor: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================== Orientation ==================
            const Text(
              "Orientation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.school, color: Colors.blue),
                      title: const Text("Commencer le test"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrientationTestPage()),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.blue),
                      title: const Text("Historique"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrientationHistoryPage()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ================== Mon conseiller ==================
            Text(
              "Mon conseiller",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _myAdvisor != null && _myAdvisor!['advisor'] != null
                ? Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.green),
                title: Text(_myAdvisor!['advisor']['username']),
                subtitle: Text(_myAdvisor!['advisor']['email']),
                trailing: const Icon(Icons.chat),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyAdvisorPage(),
                    ),
                  );
                },
              ),
            )
                : const Text(
              "Vous n'avez pas encore de conseiller assigné.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // ================== Raccourcis utiles ==================
            const Text(
              "Raccourcis",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildShortcutCard(Icons.message, "Messages", Colors.orange, () {
                  // TODO: rediriger vers la page messages
                }),
                _buildShortcutCard(Icons.assignment, "Mes cours", Colors.purple, () {
                  // TODO: rediriger vers la page cours
                }),
                _buildShortcutCard(Icons.assignment_turned_in, "Mes candidatures", Colors.teal, () {
                  // TODO: rediriger vers candidatures
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 120,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
