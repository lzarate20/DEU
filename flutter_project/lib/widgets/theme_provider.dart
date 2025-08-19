import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configProject/NoTransitionBuilder.dart';
import '../models/user_config.dart';
import '../services/config_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  double fontSizeFactor = 1.0;
  String fontFamily = 'Roboto';

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;


  double get navSizeFactor => 1.0 + (fontSizeFactor - 1.0) * 0.4;

  Color get textColor => isDarkMode ? Colors.white : Colors.black;


  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
    _saveConfig();
  }

  void setFontSizeFactor(double factor) {
    fontSizeFactor = factor;
    notifyListeners();
    _saveConfig();
  }

  void setFontFamily(String family) {
    fontFamily = family;
    notifyListeners();
  }

  Future<void> _saveConfig() async {
    try {
      final theme = isDarkMode ? 'NIGHT' : 'DAY';
      final size = _mapFontSizeToLabel(fontSizeFactor);

      await ConfigService.saveUserConfig(
        theme: theme,
        letterSize: size,
      );
    } catch (e) {
      debugPrint("Error guardando config: $e");
    }
  }

  String _mapFontSizeToLabel(double factor) {
    if (factor <= 0.8) return 'SMALL';
    if (factor >= 1.7) return 'LARGE';
    return 'MEDIUM';
  }

  Future<void> initFromConfig(UserConfig config) async {
    isDarkMode = config.theme == ThemeType.dark;
    fontSizeFactor = _mapLetterSizeToFactor(config.letterSize);
    debugPrint('Init desde backend: $isDarkMode, $fontSizeFactor');
    fontFamily = 'Roboto';
    notifyListeners();
  }

  double _mapLetterSizeToFactor(LetterSize size) {
    switch (size) {
      case LetterSize.small:
        return 0.8;
      case LetterSize.medium:
        return 1.0;
      case LetterSize.large:
        return 1.7;
    }
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


