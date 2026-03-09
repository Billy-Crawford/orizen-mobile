// lib/features/student/data/orientation_service.dart

import 'package:dio/dio.dart';
import '../../../core/services/token_service.dart';
import '../../../core/constants/api_constants.dart';

class OrientationService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${ApiConstants.baseUrl}/api",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Map<String, dynamic>> startTest() async {
    final token = await TokenService.getAccessToken();

    final res = await _dio.post(
      "/tests/start/",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  Future<List<dynamic>> getQuestions(int testId, int page) async {
    final token = await TokenService.getAccessToken();

    final res = await _dio.get(
      "/tests/$testId/questions/",
      queryParameters: {"page": page},
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  Future<void> sendAnswer(
      int testId,
      int questionId,
      int choiceId,
      ) async {
    final token = await TokenService.getAccessToken();

    await _dio.post(
      "/tests/$testId/answer/",
      data: {
        "question": questionId,
        "selected_choice": choiceId,
      },
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
  }

  Future<Map<String, dynamic>> getResult(int testId) async {
    final token = await TokenService.getAccessToken();

    final res = await _dio.get(
      "/tests/$testId/result/",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  Future<List<dynamic>> getHistory() async {
    final token = await TokenService.getAccessToken();

    final res = await _dio.get(
      "/tests/history/",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }
}

