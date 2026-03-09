// lib/features/student/presentation/orientation_history_page.dart

import 'package:flutter/material.dart';
import '../data/orientation_service.dart';

class OrientationHistoryPage extends StatefulWidget {
  const OrientationHistoryPage({super.key});

  @override
  State<OrientationHistoryPage> createState() => _OrientationHistoryPageState();
}

class _OrientationHistoryPageState extends State<OrientationHistoryPage> {
  final OrientationService _service = OrientationService();

  bool _loading = true;
  List<dynamic> _tests = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    try {
      final response = await _service.getHistory();
      setState(() {
        _tests = response;
        _loading = false;
      });
    } catch (e) {
      print("Erreur historique tests: $e");
      setState(() => _loading = false);
    }
  }

  Widget _buildDetailDialog(Map<String, dynamic> test) {
    final top3 = test['top_3'] ?? [];
    final profile = test['student_profile'] ?? {};
    final interpretation = test['interpretation'] ?? "Pas d'interprétation";

    return AlertDialog(
      title: Text("Détail Test #${test['id']}"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Filière recommandée : ${test['recommended_filiere'] ?? 'N/A'}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Top 3 des filières :",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...top3.map<Widget>((f) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("${f['name']} - ${f['score']} pts"),
              );
            }).toList(),
            const SizedBox(height: 10),
            const Text("Profil RIASEC :", style: TextStyle(fontWeight: FontWeight.bold)),
            ...profile.entries.map<Widget>((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("${e.key}: ${e.value}"),
              );
            }).toList(),
            const SizedBox(height: 10),
            const Text("Interprétation :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(interpretation),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fermer"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historique des tests")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tests.isEmpty
          ? const Center(child: Text("Aucun test réalisé pour le moment"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tests.length,
        itemBuilder: (context, index) {
          final t = _tests[index];
          final date = t['date'] != null
              ? DateTime.parse(t['date']).toLocal()
              : null;
          final score = t['score'] ?? 'N/A';
          final recommendation = t['recommendation'] ?? 'N/A';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Test #${t['id']} - Score: $score"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recommandation : $recommendation"),
                  if (date != null)
                    Text(
                        "Date : ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2,'0')}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_red_eye),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _buildDetailDialog(t),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

