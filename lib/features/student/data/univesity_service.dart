// lib/features/student/data/univesity_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/services/token_service.dart';

class UniversityService {

  static Future<List<dynamic>> getUniversities() async {

    final token = await TokenService.getAccessToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/universities/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur chargement universités");
    }
  }

  static Future<List<dynamic>> getFilieres(int universityId) async {

    final token = await TokenService.getAccessToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/filieres/?university_id=$universityId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur chargement filières");
    }
  }

}

