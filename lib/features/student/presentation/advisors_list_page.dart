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
  Set<int> _requestedAdvisors = {}; // IDs conseillers déjà demandés

  @override
  void initState() {
    super.initState();
    _fetchAdvisors();
  }

  Future<void> _fetchAdvisors() async {
    try {
      final response = await _service.getAdvisors();
      final advisorsData = response.data ?? [];

      // récupérer les relations existantes pour savoir si on a déjà envoyé une demande
      final myAdvisorResponse = await _service.getMyAdvisor();
      final myAdvisor = myAdvisorResponse.data;

      setState(() {
        _advisors = advisorsData.where((advisor) {
          // ne pas afficher le conseiller déjà accepté
          if (myAdvisor != null && myAdvisor["id"] == advisor["id"]) {
            return false;
          }
          return true;
        }).toList();

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

  Future<void> _sendRequest(int advisorId) async {
    try {
      await _service.sendAdvisorRequest(advisorId);

      setState(() {
        _requestedAdvisors.add(advisorId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Demande envoyée avec succès"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Erreur envoi demande: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'envoyer la demande"),
          backgroundColor: Colors.red,
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

    if (_advisors.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Aucun conseiller disponible")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mes conseillers")),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _advisors.length,
        itemBuilder: (context, index) {
          final advisor = _advisors[index];
          final alreadyRequested = _requestedAdvisors.contains(advisor["id"]);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(advisor["username"] ?? "Nom inconnu"),
              subtitle: Text(advisor["email"] ?? ""),
              trailing: ElevatedButton(
                onPressed: alreadyRequested
                    ? null
                    : () => _sendRequest(advisor["id"]),
                child: Text(alreadyRequested ? "Déjà demandé" : "Demande"),
              ),
              // Retiré l'onTap : pas de chat possible ici
            ),
          );
        },
      ),
    );
  }
}

