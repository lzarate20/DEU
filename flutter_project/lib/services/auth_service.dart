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
      final expiration = data['expirationDate'];
      AuthMemory.saveToken(token, userId, userType,expiration);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isSessionValid() async {
    final token = await AuthMemory.getToken();
    final expirationStr = await AuthMemory.getTokenExpiration();
    if (token == null || expirationStr == null) return false;

    final expiration = DateTime.parse(expirationStr);
    return DateTime.now().isBefore(expiration);
  }

  static Future<bool> isLoggedInAndValid() async {
    final loggedIn = await isLoggedIn();
    final valid = await isSessionValid();
    return loggedIn && valid;
  }

  static Future<void> checkAndLogoutIfExpired() async {
    final valid = await isSessionValid();
    if (!valid) {
      await logout();
    }
    AuthMemory.clear();
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

  static Future<void> logout({bool notifyServer = true}) async {
    var token = await AuthMemory.getToken();

    if (token != null && notifyServer) {
      try {
        await client.post(
          Uri.parse('$host/logout'),
          headers: {'Content-Type': 'application/json'},
          body: null,
        );
      } catch (_) {

      }
    }

    AuthMemory.clear();
  }

  static Future<bool> isSessionActiveOnServer() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await client.get(
        Uri.parse('$host/session'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isLoggedInAndSessionValid() async {
    final loggedIn = await isLoggedIn();
    final localValid = await isSessionValid();
    final serverValid = await isSessionActiveOnServer();

    return loggedIn && localValid && serverValid;
  }
}
