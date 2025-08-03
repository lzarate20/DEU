import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../configProject/global_config.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401 || response.statusCode == 403) {
      await _storage.delete(key: 'jwt_token');
      await _storage.delete(key: 'user_id');

      final navigator = navigatorKey.currentState;
      if (navigator != null) {
        navigator.pushNamedAndRemoveUntil('/', (route) => false);
      }
    }

    return response;
  }
}
