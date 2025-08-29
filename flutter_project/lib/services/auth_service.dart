import 'dart:convert';

import 'package:flutter_project/configProject/api_config.dart';

import 'api_service.dart';
import 'auth_memory.dart';

class AuthService {
  static final client = AuthHttpClient();
  static final host = ApiConfig.host;

  static Future<bool> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userId = data['user']['id'].toString();
      final userType = data['user']['type'].toString();
      AuthMemory.saveToken(token, userId, userType);
      print(await AuthService.getToken().toString());

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    var token = await AuthMemory.getToken();
    return token != null;
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
    return await AuthMemory.getToken();
  }

  static Future<String?> getLoggedUserId() async {
    return await  AuthMemory.getUserId();
  }

  static Future<bool> isTrainer() async {
    return await AuthMemory.getUserType() == "TRAINER";
  }

  static Future<bool> isTrainee() async {
    return await AuthMemory.getUserType() == "TRAINEE";
  }

  static Future<void> logout() async {
    var token = await AuthMemory.getToken();
    if (token != null) {
      await client.post(
        Uri.parse('/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: null,
      );
    }
    AuthMemory.clear();
  }
}
