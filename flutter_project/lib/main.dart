import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}
