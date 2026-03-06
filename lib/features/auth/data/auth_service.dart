// lib/features/auth/data/auth_service.dart

import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<Response> register({
    required String username,
    required String email,
    required String password,
    required String password2,
  }) async {
    return await _dio.post(
      ApiConstants.register,
      data: {
        "username": username,
        "email": email,
        "password": password,
        "password2": password2,
      },
    );
  }

  Future<Response> login({
    required String username,
    required String password,
  }) async {
    return await _dio.post(
      ApiConstants.login,
      data: {
        "username": username,
        "password": password,
      },
    );
  }

  Future<Response> getProfile() async {
    return await _dio.get(ApiConstants.profile);
  }
}

