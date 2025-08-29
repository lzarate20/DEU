import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get host {
    if (kReleaseMode) {
      return '/api';
    } else {
      return 'http://localhost:8080/api';
    }
  }
}