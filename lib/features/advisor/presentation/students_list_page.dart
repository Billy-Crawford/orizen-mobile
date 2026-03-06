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
        students = response.data;
        loading = false;
      });
    } catch (e) {
      print("Erreur chargement étudiants: $e");
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes étudiants"),
      ),

      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {

          final student = students[index];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(student["username"]),
            subtitle: Text(student["email"] ?? ""),

            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    userId: student["id"],
                    username: student["username"],
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