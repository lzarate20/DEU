import 'package:flutter/material.dart';

import '../configProject/NoTransitionBuilder.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  double fontSizeFactor = 1.0;
  String fontFamily = 'Roboto';

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setFontSizeFactor(double factor) {
    fontSizeFactor = factor;
    notifyListeners();
  }

  void setFontFamily(String family) {
    fontFamily = family;
    notifyListeners();
  }
}


ThemeData buildTheme(
    Brightness brightness, {
      required double fontSizeFactor,
      required String fontFamily,
    }) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlue,
    brightness: brightness,
  );

  // Construimos un TextTheme base y luego aplicamos tamaño y familia
  final baseTextTheme = brightness == Brightness.dark
      ? Typography.whiteMountainView
      : Typography.blackMountainView;

  final textTheme = baseTextTheme.apply(
    fontSizeFactor: fontSizeFactor,
    fontFamily: fontFamily,
  );

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: textTheme,
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: NoTransitionsBuilder(),
        TargetPlatform.iOS: NoTransitionsBuilder(),
        TargetPlatform.macOS: NoTransitionsBuilder(),
        TargetPlatform.linux: NoTransitionsBuilder(),
        TargetPlatform.windows: NoTransitionsBuilder(),
      },
    ),
  );
}