import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/services/config_service.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  final isAuthenticated = await AuthService.isLoggedIn();
  if (isAuthenticated) {
    final config = await ConfigService.getUserConfig();
    debugPrint('Init desde backend: ${config.theme}, ${config.letterSize}');
    await themeProvider.initFromConfig(config);
  }
  runApp(
    ChangeNotifierProvider.value(value: themeProvider, child: MyApp()),
  );
}
