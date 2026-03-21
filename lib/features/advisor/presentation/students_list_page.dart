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

  List<Map<String, dynamic>> students = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await _service.getMyStudents();

      debugPrint("🔥 RAW DATA => ${response.data}");

      final data = response.data;

      if (data is List) {
        students = data
            .where((e) => e != null && e is Map<String, dynamic>)
            .map<Map<String, dynamic>>((e) => e)
            .toList();
      } else {
        throw Exception("Format API invalide");
      }

      setState(() {
        loading = false;
      });

    } catch (e) {
      debugPrint("❌ ERREUR FETCH STUDENTS: $e");

      setState(() {
        error = "Impossible de charger les étudiants";
        loading = false;
      });
    }
  }

  void openChat(Map<String, dynamic> student) {

    final relationId = student["relation_id"];

    if (relationId == null) {
      debugPrint("⚠️ relation_id manquant pour: $student");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d’ouvrir le chat (relation manquante)"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          relationId: relationId,
          advisorName: student["username"] ?? "Étudiant",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
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

      body: RefreshIndicator(
        onRefresh: fetchStudents,
        child: ListView.builder(
          itemCount: students.length,

          itemBuilder: (context, index) {

            final student = students[index];

            // 🔒 SAFE ACCESS
            final username =
            (student["username"] ?? "Inconnu").toString();

            final email =
            (student["email"] ?? "").toString();

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    username.isNotEmpty
                        ? username[0].toUpperCase()
                        : "?",
                  ),
                ),

                title: Text(username),
                subtitle: Text(email),

                trailing: const Icon(Icons.chat),

                onTap: () => openChat(student),
              ),
            );
          },
        ),
      ),
    );
  }
}
