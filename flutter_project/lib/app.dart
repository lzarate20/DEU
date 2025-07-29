import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project/pages/landing_page.dart';
import 'package:flutter_project/pages/register.dart';
import 'package:flutter_project/pages/training_detail_page.dart';
import 'package:flutter_project/pages/trainings/trainings_page.dart';
import 'package:flutter_project/widgets/base_layout.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

import 'configProject/global_navigator.dart';
import 'pages/dashboard_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
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
          navigatorKey: navigatorKey,
          routes: {
            '/': (context) =>  LandingPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const BaseLayout(child: DashboardPage()),
            '/trainings': (context) => const BaseLayout(child: TrainingListPage()),
            '/training': (context) {
              final training = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return BaseLayout(child: TrainingDetailPage(training: training));
            },
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
      },
    );
  }
}


