// lib/config/app_config.dart

class AppConfig {
  static const String baseUrl = "http://192.168.1.79:8000";

  static const String loginUrl = "$baseUrl/api/users/login/";
  static const String registerUrl = "$baseUrl/api/users/register/";
}