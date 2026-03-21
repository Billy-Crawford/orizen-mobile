// lib/features/advisor/data/advisor_service.dart

import 'package:dio/dio.dart';
import '../../../core/services/token_service.dart';
import '../../../core/constants/api_constants.dart';

class AdvisorService {
  final Dio _dio = Dio();

  /// 🔐 Header commun
  Future<Options> _getOptions() async {
    final token = await TokenService.getAccessToken();

    return Options(
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }

  /// 👨‍🎓 Récupérer mes étudiants
  Future<Response> getMyStudents() async {
    return _dio.get(
      "${ApiConstants.baseUrl}/api/users/my-students/",
      options: await _getOptions(),
    );
  }

  /// 💬 Récupérer messages avec un étudiant
  Future<Response> getMessages(int studentId) async {
    return _dio.get(
      "${ApiConstants.baseUrl}/api/users/chat/$studentId/",
      options: await _getOptions(),
    );
  }

  /// ✉️ Envoyer message
  Future<Response> sendMessage(int studentId, String message) async {
    return _dio.post(
      "${ApiConstants.baseUrl}/api/users/chat/$studentId/send/",
      data: {
        "message": message,
      },
      options: await _getOptions(),
    );
  }

  /// 🔔 Notifications
  Future<Response> getNotifications() async {
    return _dio.get(
      "${ApiConstants.baseUrl}/api/notifications/",
      options: await _getOptions(),
    );
  }

  /// 🤝 Demandes de mentorat
  Future<Response> getAdvisorRequests() async {
    return _dio.get(
      "${ApiConstants.baseUrl}/api/users/advisor-requests/",
      options: await _getOptions(),
    );
  }

  /// ✅ Répondre à une demande (accept / reject)
  Future<Response> respondToRequest(int requestId, String action) async {
    return _dio.post(
      "${ApiConstants.baseUrl}/api/users/review-request/$requestId/",
      data: {
        "action": action,
      },
      options: await _getOptions(),
    );
  }
}
