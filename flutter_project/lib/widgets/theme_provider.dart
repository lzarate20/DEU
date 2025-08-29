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

  void reset() {
    isDarkMode = false;
    fontSizeFactor = 1.0;
    fontFamily = 'Roboto';
    notifyListeners();
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



TextTheme applyFontSizeFactor(TextTheme base, double factor) {
  return TextTheme(
    // Títulos principales (grandes)
    displayLarge: _scale(base.displayLarge, 32 * factor, FontWeight.bold),
    displayMedium: _scale(base.displayMedium, 28 * factor, FontWeight.bold),
    displaySmall: _scale(base.displaySmall, 24 * factor, FontWeight.bold),

    // Encabezados / Secciones
    headlineLarge: _scale(base.headlineLarge, 22 * factor, FontWeight.w600),
    headlineMedium: _scale(base.headlineMedium, 20 * factor, FontWeight.w600),
    headlineSmall: _scale(base.headlineSmall, 18 * factor, FontWeight.w600),

    // Títulos dentro del contenido
    titleLarge: _scale(base.titleLarge, 18 * factor, FontWeight.bold),
    titleMedium: _scale(base.titleMedium, 16 * factor, FontWeight.w600),
    titleSmall: _scale(base.titleSmall, 14 * factor, FontWeight.w600),

    // Texto de cuerpo
    bodyLarge: _scale(base.bodyLarge, 16 * factor, FontWeight.normal),
    bodyMedium: _scale(base.bodyMedium, 14 * factor, FontWeight.normal),
    bodySmall: _scale(base.bodySmall, 12 * factor, FontWeight.normal),

    // Labels / botones
    labelLarge: _scale(base.labelLarge, 14 * factor, FontWeight.w600),
    labelMedium: _scale(base.labelMedium, 12 * factor, FontWeight.w500),
    labelSmall: _scale(base.labelSmall, 11 * factor, FontWeight.w400),
  );
}

TextStyle? _scale(TextStyle? style, double size, FontWeight weight) {
  return style?.copyWith(fontSize: size, fontWeight: weight) ??
      TextStyle(fontSize: size, fontWeight: weight);
}



