// lib/features/student/presentation/advisors_list_page.dart

import 'package:flutter/material.dart';
import '../../auth/data/student_service.dart';

class AdvisorsListPage extends StatefulWidget {
  const AdvisorsListPage({super.key});

  @override
  State<AdvisorsListPage> createState() => _AdvisorsListPageState();
}

class _AdvisorsListPageState extends State<AdvisorsListPage> {
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
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _advisors.length,
      itemBuilder: (context, index) {
        final advisor = _advisors[index];
        return Card(
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
    );
  }
}