import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _apiUrl = 'http://localhost:8080/api/auth';
  static final client = AuthHttpClient();

  static Future<bool> login(String email, String password) async {
    final response = await client.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userId = data['user']['id'].toString();

      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'user_id', value: userId);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }

  static Future<bool> register(Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse('http://localhost:8080/api/auth/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_id');
  }
}
