import 'package:flutter_project/services/auth_memory.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:http/http.dart' as http;

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
      await AuthService.logout(notifyServer: false);
      router.go('/');
      AuthMemory.clear();
    }

    return response;
  }
}
