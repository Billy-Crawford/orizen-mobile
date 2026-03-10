// lib/features/student/presentation/filieres_page.dart

import 'package:flutter/material.dart';
import '../data/candidature_service.dart';
import '../data/univesity_service.dart';

class FilieresPage extends StatefulWidget {

  final int universityId;
  final String universityName;

  const FilieresPage({
    super.key,
    required this.universityId,
    required this.universityName
  });

  @override
  State<FilieresPage> createState() => _FilieresPageState();
}

class _FilieresPageState extends State<FilieresPage> {

  List filieres = [];
  Set<int> myCandidatures = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {

    final filieresData =
    await UniversityService.getFilieres(widget.universityId);

    final myCandidatureIds =
    await CandidatureService.getMyCandidatureFiliereIds();

    setState(() {
      filieres = filieresData;
      myCandidatures = myCandidatureIds;
      loading = false;
    });
  }

  Future<void> apply(int filiereId) async {

    try {

      await CandidatureService.createCandidature(filiereId);

      setState(() {
        myCandidatures.add(filiereId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Candidature envoyée avec succès"),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'envoyer la candidature"),
          backgroundColor: Colors.red,
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.universityName),
      ),

      body: ListView.builder(
        itemCount: filieres.length,
        itemBuilder: (context, index) {

          final filiere = filieres[index];
          final alreadyApplied = myCandidatures.contains(filiere["id"]);

          return Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(

              title: Text(filiere["name"]),
              subtitle: Text(filiere["description"] ?? ""),

              trailing: ElevatedButton(

                onPressed: alreadyApplied
                    ? null
                    : () => apply(filiere["id"]),

                child: Text(
                  alreadyApplied
                      ? "Déjà candidaté"
                      : "Candidater",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

