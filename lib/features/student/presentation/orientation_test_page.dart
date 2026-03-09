// lib/features/student/presentation/orientation_test_page.dart

// lib/features/student/presentation/orientation_test_page.dart

import 'package:flutter/material.dart';
import '../data/orientation_service.dart';

class OrientationTestPage extends StatefulWidget {
  const OrientationTestPage({super.key});

  @override
  State<OrientationTestPage> createState() => _OrientationTestPageState();
}

class _OrientationTestPageState extends State<OrientationTestPage> {
  final OrientationService _service = OrientationService();

  bool _loading = true;
  bool _finished = false;
  int _testId = 0;
  int _currentPage = 1;

  List<dynamic> _questions = [];
  Map<int, int> _answers = {};

  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _startTest();
  }

  Future<void> _startTest() async {
    try {
      final data = await _service.startTest();

      if (data["can_take_test"] == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"])),
          );
        }

        Navigator.pop(context);
        return;
      }

      setState(() {
        _testId = data["session_id"];
      });

      await _loadQuestions();
    } catch (e) {
      print("Erreur start test: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _loadQuestions() async {
    setState(() => _loading = true);

    try {
      final questions = await _service.getQuestions(_testId, _currentPage);

      if (questions.isEmpty) {
        await _loadResult();
        return;
      }

      setState(() {
        _questions = questions;
        _loading = false;
      });
    } catch (e) {
      print("Erreur load questions: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _loadResult() async {
    setState(() => _loading = true);

    try {
      final data = await _service.getResult(_testId);

      setState(() {
        _result = data;
        _finished = true;
        _loading = false;
      });
    } catch (e) {
      print("Erreur load result: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _submitAnswer(int questionId, int choiceId) async {
    try {
      await _service.sendAnswer(_testId, questionId, choiceId);
      _answers[questionId] = choiceId;
    } catch (e) {
      print("Erreur submit answer: $e");
    }
  }

  void _nextPage() {
    if (_questions.any((q) => !_answers.containsKey(q["id"]))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Veuillez répondre à toutes les questions avant de continuer."),
        ),
      );
      return;
    }

    _currentPage += 1;
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_finished && _result != null) {
      final recommended = _result!["recommended_filiere"];
      final interpretation = _result!["interpretation"];
      final profile = _result!["student_profile"] ?? {};
      final top3 = _result!["top_3"] ?? [];

      return Scaffold(
        appBar: AppBar(title: const Text("Résultat du test")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                "Filière recommandée",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                recommended ?? "Non disponible",
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),

              const SizedBox(height: 25),

              const Text(
                "Top 3 des filières",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ...top3.map<Widget>((f) {
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(f["name"].toString()),
                  trailing: Text("${f["score"]} pts"),
                );
              }).toList(),

              const SizedBox(height: 25),

              const Text(
                "Profil RIASEC",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ...profile.entries.map<Widget>((e) {
                return ListTile(
                  title: Text(e.key.toString()),
                  trailing: Text(e.value.toString()),
                );
              }).toList(),

              const SizedBox(height: 25),

              const Text(
                "Interprétation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                interpretation ?? "",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Retour au tableau de bord"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Test d'orientation")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._questions.map((q) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q["text"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    ...q["choices"].map<Widget>((c) {
                      final selected = _answers[q["id"]] == c["id"];

                      return ListTile(
                        title: Text(c["text"]),
                        leading: Radio<int>(
                          value: c["id"],
                          groupValue: _answers[q["id"]],
                          onChanged: (value) {
                            setState(() {
                              _answers[q["id"]] = value!;
                            });

                            _submitAnswer(q["id"], value!);
                          },
                        ),
                        tileColor:
                        selected ? Colors.green.withOpacity(0.2) : null,
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _nextPage,
            child: const Text("Suivant"),
          ),
        ],
      ),
    );
  }
}



