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
  bool _finished = false; // pour savoir si le test est terminé
  int _testId = 0;
  int _currentPage = 1;
  List<dynamic> _questions = [];
  Map<int, int> _answers = {}; // questionId -> choiceId
  Map<String, dynamic>? _result; // résultat final du test

  @override
  void initState() {
    super.initState();
    _startTest();
  }

  Future<void> _startTest() async {
    try {
      final data = await _service.startTest();
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

      // si aucune question n'est renvoyée -> fin du test
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
    // vérifier que toutes les questions ont été répondues
    if (_questions.any((q) => !_answers.containsKey(q["id"]))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez répondre à toutes les questions avant de continuer.")),
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

    // si test terminé -> afficher résultat
    if (_finished && _result != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Résultat du test")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Score: ${_result!['score'] ?? 'N/A'}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text("Recommandation: ${_result!['recommendation'] ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        tileColor: selected ? Colors.green.withOpacity(0.2) : null,
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

