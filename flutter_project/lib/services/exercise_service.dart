import 'dart:convert';

import 'package:flutter_project/configProject/api_config.dart';

import 'api_service.dart' show AuthHttpClient;
import 'auth_service.dart';

class ExerciseService {
  final String host = ApiConfig.host;
  static final client = AuthHttpClient();

  Future<List<Map<String, dynamic>>?> fetchExercises() async {
    final url = Uri.parse('$host/exercises');

    try {
      final token = await AuthService.getToken();
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> content = json['content'] ?? [];

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
}
