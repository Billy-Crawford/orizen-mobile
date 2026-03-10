// lib/features/auth/presentation/my_advisor_page.dart

import 'package:flutter/material.dart';
import '../../chat/presentation/chat_page.dart';
import '../data/student_service.dart';

class MyAdvisorPage extends StatefulWidget {
  const MyAdvisorPage({super.key});

  @override
  State<MyAdvisorPage> createState() => _MyAdvisorPageState();
}

class _MyAdvisorPageState extends State<MyAdvisorPage> {

  final StudentService _service = StudentService();

  bool _loading = true;

  Map<String, dynamic>? _relation;

  @override
  void initState() {
    super.initState();
    _fetchMyAdvisor();
  }

  Future<void> _fetchMyAdvisor() async {

    try {

      final response = await _service.getMyAdvisor();

      setState(() {
        _relation = response.data;
        _loading = false;
      });

    } catch (e) {

      print("Erreur fetch my advisor: $e");

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

    if (_relation == null) {
      return const Scaffold(
        body: Center(
          child: Text("Vous n'avez pas encore de conseiller"),
        ),
      );
    }

    final advisor = _relation!['advisor'];

    return Scaffold(
      appBar: AppBar(title: const Text("Mon conseiller")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GestureDetector(

          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatPage(
                  relationId: _relation!['id'], // ✅ relation id
                  advisorName: advisor['username'],
                ),
              ),
            );
          },

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Nom: ${advisor['username']}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 8),

              Text(
                "Email: ${advisor['email']}",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              const Text(
                "Cliquez sur le conseiller pour ouvrir le chat",
                style: TextStyle(color: Colors.grey),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

