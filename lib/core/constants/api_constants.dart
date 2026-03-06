// lib/core/constants/api_constants.dart

class ApiConstants {
  static const String baseUrl = "http://192.168.1.79:8000";

  static const String register = "/api/users/register/";
  static const String login = "/api/users/login/";
  static const String profile = "/api/users/profile/";

  // Etudiant
  static const String advisors = "/api/users/advisors/";

  // chat
  static const String chatMessages = "/api/users/chat-messages"; // GET / POST
}


