// lib/features/auth/data/student_service.dart

import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/api_constants.dart';

class StudentService {
  final Dio _dio = DioClient.instance;

  Future<Response> getAdvisors() async {
    return await _dio.get(ApiConstants.advisors); // à définir
  }

  Future<Response> sendAdvisorRequest(int advisorId) async {
    return await _dio.post("/api/users/send-request/$advisorId/");
  }

  Future<Response> getMyAdvisor() async {
    return await _dio.get("/api/users/my-advisor/");
  }
}