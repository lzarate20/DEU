import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'configProject/global_router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'DEU app',
          themeMode: themeProvider.currentTheme,
          theme: buildTheme(
            Brightness.light,
            fontSizeFactor: themeProvider.fontSizeFactor,
            fontFamily: themeProvider.fontFamily,
          ),
          darkTheme: buildTheme(
            Brightness.dark,
            fontSizeFactor: themeProvider.fontSizeFactor,
            fontFamily: themeProvider.fontFamily,
          ),
          themeAnimationStyle: AnimationStyle.noAnimation,
          routerConfig: router,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('es', 'ES'),
        );
      },
    );
  }
}



