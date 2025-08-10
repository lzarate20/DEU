import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart' show AuthHttpClient;

class UserService {
  static const _storage = FlutterSecureStorage();
  final String host;
  static final client = AuthHttpClient();

  UserService({this.host = 'localhost:8080'});

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final url = Uri.parse('http://$host/users');

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        print('Error al obtener usuarios: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error de red al obtener usuarios: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final token = await _storage.read(key: 'jwt_token');

    if (token == null) {
      print('No se encontró el token JWT');
      return [];
    }

    final url = Uri.parse('http://$host/user/notifications');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      print('Error al obtener notificaciones: ${response.statusCode}');
      return [];
    }
  }

  Future<bool> markNotificationsViewed() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return false;

    final url = Uri.parse('http://$host/user/notifications/viewed'); // endpoint que maneja el POST

    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

}
