// lib/features/advisor/presentation/advisor_requests_page.dart

import 'package:flutter/material.dart';
import '../data/advisor_requests_service.dart';

class AdvisorRequestsPage extends StatefulWidget {
  const AdvisorRequestsPage({super.key});

  @override
  State<AdvisorRequestsPage> createState() => _AdvisorRequestsPageState();
}

class _AdvisorRequestsPageState extends State<AdvisorRequestsPage> {

  List<dynamic> requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {

    setState(() => loading = true);

    try {

      final data = await AdvisorRequestsService.getRequests();

      setState(() {
        requests = data;
        loading = false;
      });

    } catch (e) {

      debugPrint("❌ LOAD ERROR: $e");

      setState(() {
        requests = [];
        loading = false;
      });
    }
  }

  void handleAction(int id, String action) async {

    try {

      await AdvisorRequestsService.reviewRequest(id, action);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Demande ${action == "accept" ? "acceptée" : "refusée"}")),
      );

      loadRequests(); // refresh

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'action")),
      );
    }
  }

  Widget buildRequest(dynamic req) {

    if (req == null) return const SizedBox();

    final student = req["student"] ?? {};
    final id = req["id"];

    final username = student["username"] ?? "Unknown";
    final email = student["email"] ?? "";

    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(username),
        subtitle: Text(email),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => handleAction(id, "accept"),
            ),

            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => handleAction(id, "reject"),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demandes des étudiants"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text("Aucune demande"))
          : ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return buildRequest(requests[index]);
        },
      ),
    );
  }
}

