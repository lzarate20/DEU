import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart' show AuthHttpClient;

class TeamService {
  static const _storage = FlutterSecureStorage();
  final String host;
  static final client = AuthHttpClient();

  TeamService({this.host = 'localhost:8080'});

  Future<List<Map<String, dynamic>>?> fetchTeams() async {
    final url = Uri.parse('http://$host/teams');

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

  Future<Map<String, dynamic>?> fetchTeamById(String id) async {
    final url = Uri.parse('http://$host/teams/$id');
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

}
