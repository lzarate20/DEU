import 'dart:convert';

import 'package:flutter_project/services/auth_service.dart';

import '../configProject/api_config.dart';
import '../models/user_config.dart';
import 'api_service.dart';

class ConfigService {
  static final client = AuthHttpClient();
  static final host = ApiConfig.host;

  static Future<UserConfig> getUserConfig() async {
    final userId = await AuthService.getLoggedUserId();

    final url = Uri.parse('$host/config/$userId');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
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
    final userId = await AuthService.getLoggedUserId();
    final url = Uri.parse('$host/config');
    final body = jsonEncode({
      "idUser": userId,
      "theme": theme.toUpperCase(),
      "letterSize": letterSize.toUpperCase(),
    });

    final response = await client.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar configuración');
    }
  }
}
