import 'dart:convert';

import 'package:flutter_project/configProject/api_config.dart';

import '../models/evaluation.dart';
import 'api_service.dart' show AuthHttpClient;
import 'auth_service.dart';

class EvaluationService {
  final String host = ApiConfig.host;
  static final client = AuthHttpClient();

  Future<EvaluationDTO?> postEvaluation(EvaluationDTO evaluation) async {
    final url = Uri.parse('$host/evaluation');

    try {
      final token = await AuthService.getToken();
      final response = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(evaluation.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return EvaluationDTO(
          userId: json['userId'],
          trainingId: json['trainingId'],
          score: (json['score'] as num).toDouble(),
        );
      } else {
        print('Error POST /evaluation: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red POST /evaluation: $e');
      return null;
    }
  }

  Future<EvaluationDTO?> getMyEvaluation(int trainingId) async {
    final url = Uri.parse('$host/evaluation/$trainingId');

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
        return EvaluationDTO(
          userId: json['userId'],
          trainingId: json['trainingId'],
          score: (json['score'] as num).toDouble(),
        );
      } else if (response.statusCode == 404) {
        return null;
      } else {
        print('Error GET /evaluation/$trainingId: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red GET /evaluation/$trainingId: $e');
      return null;
    }
  }

  Future<EvaluationDTO?> getUserEvaluation({
    required int userId,
    required int trainingId,
  }) async {
    final url = Uri.parse('$host/evaluation').replace(
      queryParameters: {
        'userId': userId.toString(),
        'trainingId': trainingId.toString(),
      },
    );

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
        return EvaluationDTO(
          userId: json['userId'],
          trainingId: json['trainingId'],
          score: (json['score'] as num).toDouble(),
        );
      } else if (response.statusCode == 404) {
        return null;
      } else {
        print(
          'Error GET /evaluation?userId=$userId&trainingId=$trainingId: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print(
        'Error de red GET /evaluation?userId=$userId&trainingId=$trainingId: $e',
      );
      return null;
    }
  }

  Future<EvaluationDTO?> getAverageEvaluation(int trainingId) async {
    final url = Uri.parse('$host/evaluations/$trainingId');

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
        return EvaluationDTO(
          userId: json['userId'],
          trainingId: json['trainingId'],
          score: (json['score'] as num).toDouble(),
        );
      } else {
        print('Error GET /evaluations/$trainingId: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red GET /evaluations/$trainingId: $e');
      return null;
    }
  }
}
