// lib/features/auth/presentation/my_advisor_page.dart

import 'package:flutter/material.dart';
import '../data/student_service.dart';

class MyAdvisorPage extends StatefulWidget {
  const MyAdvisorPage({super.key});

  @override
  State<MyAdvisorPage> createState() => _MyAdvisorPageState();
}

class _MyAdvisorPageState extends State<MyAdvisorPage> {
  final StudentService _service = StudentService();
  bool _loading = true;
  Map<String, dynamic>? _advisor;

  @override
  void initState() {
    super.initState();
    _fetchMyAdvisor();
  }

  Future<void> _fetchMyAdvisor() async {
    try {
      final response = await _service.getMyAdvisor();
      setState(() {
        _advisor = response.data; // le backend renvoie un objet JSON
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

    if (_advisor == null || _advisor!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Vous n'avez pas encore de conseiller")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mon conseiller")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom: ${_advisor!['username']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Email: ${_advisor!['email']}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Rôle: ${_advisor!['role']}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}


