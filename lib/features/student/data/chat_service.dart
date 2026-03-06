// lib/features/student/data/chat_service.dart

import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/api_constants.dart';

class ChatService {
  final Dio _dio = DioClient.instance;

  Future<Response> getMessages(int relationId) async {
    return _dio.get("${ApiConstants.chatMessages}/$relationId/");
  }

  Future<Response> sendMessage(int relationId, String content) async {
    return _dio.post(
      "${ApiConstants.chatMessages}/$relationId/",
      data: {"content": content},
    );
  }
}

