// lib/features/advisor/data/advisor_service.dart

import 'package:dio/dio.dart';
import '../../../core/services/token_service.dart';
import '../../../core/constants/api_constants.dart';

class AdvisorService {
  final Dio _dio = Dio();

  Future<Response> getMyStudents() async {
    final token = await TokenService.getAccessToken();

    return _dio.get(
      "${ApiConstants.baseUrl}/users/my-students/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}