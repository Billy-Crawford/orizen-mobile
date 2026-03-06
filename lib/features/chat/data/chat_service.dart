// lib/features/chat/data/chat_service.dart

import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/token_service.dart';

class ChatService {

  final Dio _dio = Dio();

  Future<Response> getMessages(int userId) async {

    final token = await TokenService.getAccessToken();

    return _dio.get(
      "${ApiConstants.baseUrl}/users/chat/$userId/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }

  Future<Response> sendMessage(int userId, String message) async {

    final token = await TokenService.getAccessToken();

    return _dio.post(
      "${ApiConstants.baseUrl}/users/chat/$userId/send/",
      data: {
        "message": message,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}

