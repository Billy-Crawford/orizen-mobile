// lib/features/student/presentation/my_candidatures_page.dart

import 'package:flutter/material.dart';
import '../data/candidature_service.dart';

class MyCandidaturesPage extends StatefulWidget {
  const MyCandidaturesPage({super.key});

  @override
  State<MyCandidaturesPage> createState() => _MyCandidaturesPageState();
}

class _MyCandidaturesPageState extends State<MyCandidaturesPage> {

  List candidatures = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCandidatures();
  }

  void loadCandidatures() async {

    try {

      final data = await CandidatureService.getMyCandidatures();

      setState(() {
        candidatures = data;
        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

    }
  }

  Color statusColor(String status) {

    switch (status) {
      case "accepted":
        return Colors.green;

      case "rejected":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  String statusLabel(String status) {

    switch (status) {
      case "accepted":
        return "ACCEPTÉE";

      case "rejected":
        return "REFUSÉE";

      default:
        return "EN ATTENTE";
    }
  }

  IconData statusIcon(String status) {

    switch (status) {
      case "accepted":
        return Icons.check_circle;

      case "rejected":
        return Icons.cancel;

      default:
        return Icons.hourglass_bottom;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (candidatures.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Mes candidatures")),
        body: const Center(
          child: Text(
            "Aucune candidature envoyée",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text("Mes candidatures"),
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: candidatures.length,

        itemBuilder: (context, index) {

          final c = candidatures[index];

          final filiere = c["filiere"];
          final university = filiere["university"];

          final filiereName = filiere["name"] ?? "";
          final universityName = university["name"] ?? "";
          final status = c["status"] ?? "pending";
          final date = c["created_at"] ?? "";

          return Container(

            margin: const EdgeInsets.only(bottom: 16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const Icon(Icons.school, color: Colors.blue),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          filiereName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(Icons.account_balance, size: 18),

                      const SizedBox(width: 6),

                      Text(
                        universityName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [

                      const Icon(Icons.calendar_today, size: 18),

                      const SizedBox(width: 6),

                      Text(
                        date,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Container(

                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: statusColor(status),
                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Row(
                          children: [

                            Icon(
                              statusIcon(status),
                              color: Colors.white,
                              size: 18,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              statusLabel(status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

