// lib/features/student/presentation/student_dashboard.dart

import 'package:flutter/material.dart';
import '../data/student_service.dart';
import 'my_advisor_page.dart'; // 🔹 importer la page

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
          // 🔹 Bouton pour voir mon conseiller
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
      body: ListView.builder(
        itemCount: _advisors.length,
        itemBuilder: (context, index) {
          final advisor = _advisors[index];
          return ListTile(
            title: Text(advisor['username']),
            subtitle: Text(advisor['email']),
            trailing: ElevatedButton(
              child: const Text("Demande"),
              onPressed: () => _sendRequest(advisor['id']),
            ),
          );
        },
      ),
    );
  }
}

