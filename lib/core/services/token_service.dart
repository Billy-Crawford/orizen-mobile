// lib/core/services/token_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _roleKey = "user_role";

  static Future<void> saveTokens({
    required String access,
    String? refresh,
    required String role,
  }) async {
    await _storage.write(key: _accessKey, value: access);

    if (refresh != null) {
      await _storage.write(key: _refreshKey, value: refresh);
    }

    await _storage.write(key: _roleKey, value: role);
  }

  static Future<String?> getAccessToken() {
    return _storage.read(key: _accessKey);
  }

  static Future<String?> getRole() {
    return _storage.read(key: _roleKey);
  }

  // 🔹 supprimer uniquement les tokens
  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _roleKey);
  }

  // 🔹 supprimer tout le stockage
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}

