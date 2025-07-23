import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final baseTextTheme = brightness == Brightness.dark
      ? ThemeData.dark().textTheme
      : ThemeData.light().textTheme;

  final googleFontTheme = GoogleFonts.getTextTheme(fontFamily, baseTextTheme);

  final textTheme = applyFontSizeFactor(googleFontTheme, fontSizeFactor);

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

TextTheme applyFontSizeFactor(TextTheme textTheme, double factor) {
  return TextTheme(
    displayLarge: _scale(textTheme.displayLarge, factor),
    displayMedium: _scale(textTheme.displayMedium, factor),
    displaySmall: _scale(textTheme.displaySmall, factor),
    headlineLarge: _scale(textTheme.headlineLarge, factor),
    headlineMedium: _scale(textTheme.headlineMedium, factor),
    headlineSmall: _scale(textTheme.headlineSmall, factor),
    titleLarge: _scale(textTheme.titleLarge, factor),
    titleMedium: _scale(textTheme.titleMedium, factor),
    titleSmall: _scale(textTheme.titleSmall, factor),
    bodyLarge: _scale(textTheme.bodyLarge, factor),
    bodyMedium: _scale(textTheme.bodyMedium, factor),
    bodySmall: _scale(textTheme.bodySmall, factor),
    labelLarge: _scale(textTheme.labelLarge, factor),
    labelMedium: _scale(textTheme.labelMedium, factor),
    labelSmall: _scale(textTheme.labelSmall, factor),
  );
}

TextStyle? _scale(TextStyle? style, double factor) {
  if (style == null) return null;

  final fontSize = style.fontSize ?? 16.0;

  return style.copyWith(fontSize: fontSize * factor);
}


