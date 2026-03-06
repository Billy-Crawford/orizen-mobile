// lib/core/services/token_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _roleKey = "user_role";
  static const _userIdKey = "user_id"; // <- nouvel ajout

  static Future<void> saveTokens({
    required String access,
    String? refresh,
    required String role,
    required int userId, // <- nouvel ajout
  }) async {
    await _storage.write(key: _accessKey, value: access);

    if (refresh != null) {
      await _storage.write(key: _refreshKey, value: refresh);
    }

    await _storage.write(key: _roleKey, value: role);
    await _storage.write(key: _userIdKey, value: userId.toString()); // <- stocker l'ID
  }

  static Future<String?> getAccessToken() {
    return _storage.read(key: _accessKey);
  }

  static Future<String?> getRole() {
    return _storage.read(key: _roleKey);
  }

  // 🔹 obtenir l'ID de l'utilisateur connecté
  static Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    if (value == null) return null;
    return int.tryParse(value);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _userIdKey); // <- supprimer aussi l'ID
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}

