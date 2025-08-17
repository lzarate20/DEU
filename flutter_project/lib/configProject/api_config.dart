class ApiConfig {
  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'http://localhost:8080',
  );
}