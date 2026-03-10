// lib/features/chat/data/chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/token_service.dart';

class ChatService {

  static Future<List<dynamic>> getMessages(int relationId) async {

    final token = await TokenService.getAccessToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/users/chat/$relationId/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception("Erreur récupération messages : ${response.body}");
    }
  }

  static Future<void> sendMessage(
      int relationId,
      String content,
      ) async {

    final token = await TokenService.getAccessToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/users/chat/$relationId/send/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": content
      }),
    );

    if (response.statusCode != 201) {

      throw Exception("Erreur envoi message : ${response.body}");
    }
  }
}


