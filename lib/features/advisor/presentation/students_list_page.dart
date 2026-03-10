// lib/features/advisor/presentation/students_list_page.dart

import 'package:flutter/material.dart';
import '../data/advisor_service.dart';
import '../../chat/presentation/chat_page.dart';

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {

  final AdvisorService _service = AdvisorService();
  List<dynamic> students = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await _service.getMyStudents();

      setState(() {
        students = response.data ?? [];
        loading = false;
      });
    } catch (e) {
      debugPrint("Erreur chargement étudiants: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (students.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Aucun étudiant assigné")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes étudiants"),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {

          final relation = students[index];
          final student = relation['student'];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(student["username"] ?? "Étudiant"),
            subtitle: Text(student["email"] ?? ""),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    relationId: relation['id'],               // 🔹 obligatoire
                    advisorName: student['username'] ?? "Étudiant", // 🔹 obligatoire
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

