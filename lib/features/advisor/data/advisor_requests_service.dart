// lib/features/advisor/data/advisor_requests_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/token_service.dart';

class AdvisorRequestsService {

  static Future<List<dynamic>> getRequests() async {

    final token = await TokenService.getAccessToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/users/advisor-requests/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {

      final decoded = jsonDecode(response.body);

      if (decoded is List) return decoded;

      return [];

    } else {
      throw Exception("Erreur chargement demandes");
    }
  }

  static Future<void> reviewRequest(int id, String action) async {

    final token = await TokenService.getAccessToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/users/review-request/$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "action": action, // "accept" ou "reject"
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur action demande");
    }
  }
}

