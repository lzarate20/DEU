import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../configProject/global_config.dart';
import '../configProject/global_router.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await AuthService.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401 || response.statusCode == 403) {
      await AuthService.logout();

      final navigator = navigatorKey.currentState;
      if (navigator != null) {
        router.go('/');
      }
    }

    return response;
  }
}
