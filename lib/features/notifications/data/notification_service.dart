// lib/features/notifications/data/notification_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/services/token_service.dart';

class NotificationService {

  static Future<List> getNotifications() async {

    final token = await TokenService.getAccessToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/notifications/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Erreur chargement notifications");
  }

  static Future<void> markAsRead(int id) async {

    final token = await TokenService.getAccessToken();

    await http.patch(
      Uri.parse("${ApiConstants.baseUrl}/api/notifications/$id/read/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );
  }
}

