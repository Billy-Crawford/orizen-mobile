// lib/features/student/presentation/universities_page.dart

import 'package:flutter/material.dart';

import '../data/univesity_service.dart';
import 'filieres_page.dart';


class UniversitiesPage extends StatefulWidget {
  const UniversitiesPage({super.key});

  @override
  State<UniversitiesPage> createState() => _UniversitiesPageState();
}

class _UniversitiesPageState extends State<UniversitiesPage> {

  List universities = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUniversities();
  }

  void loadUniversities() async {

    final data = await UniversityService.getUniversities();

    setState(() {
      universities = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Universités")),
      body: ListView.builder(
        itemCount: universities.length,
        itemBuilder: (context, index) {

          final uni = universities[index];

          return ListTile(
            title: Text(uni["name"]),
            subtitle: Text(uni["city"] ?? ""),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilieresPage(
                    universityId: uni["id"],
                    universityName: uni["name"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

