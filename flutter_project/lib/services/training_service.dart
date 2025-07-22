import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class TrainingService {
  static const _storage = FlutterSecureStorage();
  final String host;

  TrainingService({this.host = 'localhost:8080'});

  Future<List<Map<String, dynamic>>?> fetchTraining(DateTime date) async {
    final userId = await _storage.read(key: 'user_id');
    final formattedDate = date.toIso8601String().split('T').first;
    final url = Uri.parse('http://$host/user/trainings?id=$userId&date=$formattedDate');

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await http.get(url,
        headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => item as Map<String, dynamic>)
            .toList();
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
