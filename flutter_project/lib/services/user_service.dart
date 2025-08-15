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

  Future<Map<String, dynamic>?> fetchUser(String id) async {
    final url = Uri.parse('http://$host/users/$id');

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
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return userData;
      } else {
        print('Error al obtener usuario: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red al obtener usuario: $e');
      return null;
    }
  }

  Future<bool> updateUser({
    required String? name,
    required String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    final url = Uri.parse('http://$host/user');

    try {
      final token = await _storage.read(key: 'jwt_token');

      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (currentPassword != null) body['currentPassword'] = currentPassword;
      if (newPassword != null) body['newPassword'] = newPassword;

      final response = await client.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al actualizar usuario: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de red al actualizar usuario: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserTeams(String userId) async {
    final url = Uri.parse('http://$host/user/$userId/teams');

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
        print('Error al obtener equipos del usuario: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error de red al obtener equipos del usuario: $e');
      return [];
    }
  }

  Future<bool> assignTrainingToUsers(int trainingId, List<int> userIds) async {
    final url = Uri.parse('http://$host/user/training/$trainingId');

    try {
      final token = await _storage.read(key: 'jwt_token');

      final body = {
        "users": userIds,
      };

      final response = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Entrenamiento asignado correctamente');
        return true;
      } else {
        print('Error al asignar entrenamiento: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de red al asignar entrenamiento: $e');
      return false;
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
