import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project/pages/landing_page.dart';
import 'package:flutter_project/pages/register.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

import 'pages/dashboard_page.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
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
      navigatorKey: _navigatorKey,

      routes: {
        '/': (context) => const LandingPage(),
        '/home': (context) => const DashboardPage(),
        '/register': (context) => const RegisterPage()
      },
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
  }
}

