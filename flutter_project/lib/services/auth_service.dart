import 'dart:convert';

import 'package:flutter_project/configProject/api_config.dart';

import 'api_service.dart';
import 'auth_memory.dart';

class AuthService {
  static final client = AuthHttpClient();
  static final host = ApiConfig.host;

  static Future<bool> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$host/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userId = data['user']['id'].toString();
      final userType = data['user']['type'].toString();

      AuthMemory.saveToken(token, userId, userType);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    return AuthMemory.token != null;
  }

  static Future<bool> register(Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse('$host/auth/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<String?> getToken() async {
    return AuthMemory.token;
  }

  static Future<String?> getLoggedUserId() async {
    return AuthMemory.userId;
  }

  static Future<bool> isTrainer() async {
    return AuthMemory.userType == "TRAINER";
  }

  static Future<bool> isTrainee() async {
    return AuthMemory.userType == "TRAINEE";
  }

  static Future<void> logout() async {
    AuthMemory.clear();
  }
}
