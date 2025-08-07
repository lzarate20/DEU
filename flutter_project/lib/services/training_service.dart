import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart' show AuthHttpClient;


class TrainingService {
  static const _storage = FlutterSecureStorage();
  final String host;
  static final client = AuthHttpClient();

  TrainingService({this.host = 'localhost:8080'});

  Future<List<Map<String, dynamic>>?> fetchTraining(DateTime date) async {
    final userId = await _storage.read(key: 'user_id');
    final formattedDate = date.toIso8601String().split('T').first;
    final url = Uri.parse('http://$host/user/trainings?id=$userId&date=$formattedDate');

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await client.get(url,
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

  Future<List<Map<String, dynamic>>?> fetchTrainings() async {
    final url = Uri.parse('http://$host/trainings');

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await client.get(url,
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

  Future<bool> createTraining(Map<String, dynamic> trainingData) async {
    final url = Uri.parse('http://$host/training');
    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(trainingData),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al crear entrenamiento: $e');
      return false;
    }
  }

  Future<bool> copyTraining(Map<String, dynamic> originalTraining) async {
    final userId = await _storage.read(key: 'user_id');
    if (userId == null) return false;

    final newTraining = Map<String, dynamic>.from(originalTraining);
    newTraining.remove('id');
    newTraining['trainer'] = {'id': int.parse(userId)};
    newTraining['date'] = DateTime.now().toIso8601String().split('T').first;

    return await createTraining(newTraining);
  }

  Future<bool> removeTraining(String id) async {
    final url = Uri.parse('http://$host/training/$id');

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await client.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Error al eliminar entrenamiento: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de red al eliminar entrenamiento: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> addCommentToTraining({
    required String idTeam,
    required String comment,
  }) async {
    final userId = await _storage.read(key: 'user_id');
    if (userId == null) return null;

    final url = Uri.parse('http://$host/training/comment/$idTeam');

    final Map<String, dynamic> body = {
      'userId': userId,
      'comment': comment,
    };

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> updatedTraining = jsonDecode(response.body);
        return updatedTraining;
      } else {
        print('Error al agregar comentario: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red al agregar comentario: $e');
      return null;
    }
  }

}
