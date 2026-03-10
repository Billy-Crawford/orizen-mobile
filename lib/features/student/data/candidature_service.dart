// lib/features/student/data/candidature_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/services/token_service.dart';

class CandidatureService {

  static Future<List<dynamic>> getMyCandidatures() async {

    final token = await TokenService.getAccessToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/candidatures/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur chargement candidatures");
    }
  }

  static Future<void> createCandidature(int filiereId) async {

    final token = await TokenService.getAccessToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/candidatures/create/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "filiere": filiereId
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur création candidature");
    }
  }

  // 🔵 récupère les filières déjà candidées
  static Future<Set<int>> getMyCandidatureFiliereIds() async {

    final list = await getMyCandidatures();

    final ids = <int>{};

    for (var c in list) {
      ids.add(c["filiere"]["id"]);
    }

    return ids;
  }
}

