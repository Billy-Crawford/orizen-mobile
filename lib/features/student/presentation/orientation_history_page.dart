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
        _tests = response; // backend renvoie directement la liste
        _loading = false;
      });
    } catch (e) {
      print("Erreur historique tests: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historique des tests")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tests.isEmpty
          ? const Center(
        child: Text("Aucun test réalisé pour le moment"),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tests.length,
        itemBuilder: (context, index) {
          final t = _tests[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Test #${t['id']} - Score: ${t['score'] ?? 'N/A'}"),
              subtitle: Text("Recommandation : ${t['recommendation'] ?? 'N/A'}"),
              trailing: IconButton(
                icon: const Icon(Icons.remove_red_eye),
                onPressed: () {
                  // Ici on pourrait afficher le détail du test ou les réponses
                  // Par exemple : un dialogue avec la liste des questions/réponses
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Détail Test #${t['id']}"),
                      content: Text(
                        t['details'] != null
                            ? t['details'].toString()
                            : "Pas de détails disponibles",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Fermer"),
                        ),
                      ],
                    ),
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

