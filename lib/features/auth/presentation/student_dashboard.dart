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
  List<dynamic> _advisors = [];

  @override
  void initState() {
    super.initState();
    _fetchAdvisors();
  }

  Future<void> _fetchAdvisors() async {
    try {
      final response = await _service.getAdvisors();
      setState(() {
        _advisors = response.data;
        _loading = false;
      });
    } catch (e) {
      print("Erreur fetch advisors: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _sendRequest(int advisorId) async {
    try {
      final response = await _service.sendAdvisorRequest(advisorId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'] ?? 'Demande envoyée')),
      );
    } catch (e) {
      print("Erreur send request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'envoi")),
      );
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
        title: const Text("Tableau de bord étudiant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Mon conseiller",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyAdvisorPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================== Test d'orientation ==================
            const Text(
              "Orientation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrientationTestPage()),
                      );
                    },
                    child: const Text("Commencer le test"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrientationHistoryPage()),
                      );
                    },
                    child: const Text("Voir l'historique"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ================== Liste des conseillers ==================
            const Text(
              "Liste des conseillers disponibles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _advisors.length,
              itemBuilder: (context, index) {
                final advisor = _advisors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(advisor['username']),
                    subtitle: Text(advisor['email']),
                    trailing: ElevatedButton(
                      child: const Text("Demande"),
                      onPressed: () => _sendRequest(advisor['id']),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

