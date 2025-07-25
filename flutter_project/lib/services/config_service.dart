import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_config.dart';
import 'api_service.dart';


class ConfigService {
  static const _storage = FlutterSecureStorage();
  static const _apiUrl = 'http://localhost:8080/config';
  static final client = AuthHttpClient();

  static Future<UserConfig> getUserConfig() async {
    final token = await _storage.read(key: 'jwt_token');
    final userId = await _storage.read(key: 'user_id');

    final url = Uri.parse('$_apiUrl/$userId');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return UserConfig.fromJson(json);
    } else {
      throw Exception('Error al obtener configuración: ${response.statusCode}');
    }
  }

  static Future<void> saveUserConfig({
    required String theme,
    required String letterSize,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    final userId = await _storage.read(key: 'user_id');
    final url = Uri.parse(_apiUrl);
    final body = jsonEncode({
      "idUser": userId,
      "theme": theme.toUpperCase(),
      "letterSize": letterSize.toUpperCase(),
    });

    final response = await client.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar configuración');
    }
  }

}

