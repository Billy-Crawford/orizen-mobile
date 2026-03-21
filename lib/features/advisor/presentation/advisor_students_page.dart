// lib/features/advisor/presentation/advisor_students_page.dart

import 'package:flutter/material.dart';
import '../../chat/presentation/chat_page.dart';
import '../data/advisor_service.dart';

class AdvisorStudentsPage extends StatefulWidget {
  const AdvisorStudentsPage({super.key});

  @override
  State<AdvisorStudentsPage> createState() => _AdvisorStudentsPageState();
}

class _AdvisorStudentsPageState extends State<AdvisorStudentsPage> {
  final AdvisorService _service = AdvisorService();

  List<Map<String, dynamic>> students = [];
  bool isLoading = true;
  String? errorMessage;

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

      final List<Map<String, dynamic>> safeList = [];

      if (data is List) {
        for (final item in data) {
          if (item == null) continue;

          if (item is Map) {
            final map = Map<String, dynamic>.from(item);

            if (map["username"] != null && map["email"] != null) {
              safeList.add(map);
            } else {
              debugPrint("⚠️ Missing keys: $map");
            }
          } else {
            debugPrint("⚠️ Invalid item type: ${item.runtimeType}");
          }
        }
      } else {
        debugPrint("❌ Unexpected API format: ${data.runtimeType}");
      }

      setState(() {
        students = safeList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ ERROR: $e");

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void goToChat(Map<String, dynamic> student) {
    Navigator.pushNamed(context, "/advisor-chat", arguments: student);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes étudiants")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : students.isEmpty
          ? const Center(child: Text("Aucun étudiant assigné"))
          : ListView.builder(
              itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];

            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(student["username"] ?? "Étudiant"),
              subtitle: Text(student["email"] ?? ""),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      relationId: student['id'], // ⚠️ à adapter selon chat
                      advisorName: student['username'] ?? "Étudiant",
                    ),
                  ),
                );
              },
            );
          }
            ),
    );
  }
}
