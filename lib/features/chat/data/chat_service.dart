// lib/features/chat/data/chat_service.dart

import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/token_service.dart';

class ChatService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<void> sendMessage({
    required int userId,
    required String message,
  }) async {

    final token = await TokenService.getAccessToken();

    await _dio.post(
      "/api/users/chat/$userId/send/",
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

