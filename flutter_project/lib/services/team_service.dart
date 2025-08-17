import 'dart:convert';
import 'package:flutter_project/configProject/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart' show AuthHttpClient;

class TeamService {
  static const _storage = FlutterSecureStorage();
  final String host = ApiConfig.host;
  static final client = AuthHttpClient();

  Future<List<Map<String, dynamic>>?> fetchTeams() async {
    final url = Uri.parse('$host/teams');

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
        final json = jsonDecode(response.body);

        final List<dynamic> content = json is List ? json : (json['content'] ?? []);

        return content.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print('Error: ${response.statusCode}');
        return List.empty();
      }
    } catch (e) {
      print('Error de red: $e');
      return List.empty();
    }
  }

  Future<List<Map<String, dynamic>>?> fetchMyTeams() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final userId = await _storage.read(key: 'user_id');

      if (token == null || userId == null) {
        return null;
      }

      final url = Uri.parse('$host/user/$userId/teams');

      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> content =
        json is List ? json : (json['content'] ?? []);
        return content.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchTeamById(String id) async {
    final url = Uri.parse('$host/teams/$id');
    final token = await _storage.read(key: 'jwt_token');
    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> createTeam(String name) async {
    final url = Uri.parse('$host/team');
    final token = await _storage.read(key: 'jwt_token');

    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception('Error al crear el equipo: ${response.statusCode}');
    }
  }

  Future<bool> addUserToTeam(String teamId, String userId) async {
    final url = Uri.parse('$host/teams/$teamId/user/$userId');
    final token = await _storage.read(key: 'jwt_token');

    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

}
