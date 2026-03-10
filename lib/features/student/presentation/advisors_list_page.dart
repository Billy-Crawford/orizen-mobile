// lib/features/student/presentation/advisors_list_page.dart

import 'package:flutter/material.dart';
import '../../auth/data/student_service.dart';
import '../../chat/presentation/chat_page.dart';

class AdvisorsListPage extends StatefulWidget {
  const AdvisorsListPage({super.key});

  @override
  State<AdvisorsListPage> createState() => _AdvisorsListPageState();
}

class _AdvisorsListPageState extends State<AdvisorsListPage> {
  final StudentService _service = StudentService();

  bool _loading = true;
  List<dynamic> _relations = [];

  @override
  void initState() {
    super.initState();
    _fetchAdvisors();
  }

  Future<void> _fetchAdvisors() async {
    try {
      final response = await _service.getAdvisors();

      setState(() {
        _relations = response.data ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint("Erreur fetch advisors: $e");

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de récupérer les conseillers"),
        ),
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

    if (_relations.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Aucun conseiller trouvé")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mes conseillers")),

      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _relations.length,
        itemBuilder: (context, index) {

          final relation = _relations[index];
          final advisor = relation['advisor'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),

            child: ListTile(
              title: Text(advisor['username'] ?? "Nom inconnu"),
              subtitle: Text(advisor['email'] ?? ""),

              trailing: const Icon(Icons.chat),

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      relationId: relation['id'], // ✅ ID RELATION
                      advisorName: advisor['username'] ?? "Conseiller",
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

