// lib/core/api/dio_client.dart

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../services/token_service.dart';

class DioClient {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static Dio get instance {

    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          // ❗ Ne pas envoyer le token pour login et register
          if (options.path == ApiConstants.login ||
              options.path == ApiConstants.register) {
            return handler.next(options);
          }

          final token = await TokenService.getAccessToken();

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );

    return _dio;
  }
}

