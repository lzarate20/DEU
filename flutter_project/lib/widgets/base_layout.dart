import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../configProject/global_router.dart';
import '../services/auth_service.dart';
import 'header_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  void _handleLogin(BuildContext context) {
    router.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.blue.shade700,
            child: Column(
              children: const [
                SizedBox(height: 40),
                Icon(Icons.dashboard, size: 50, color: Colors.white),
                SizedBox(height: 20),
                _NavButton(icon: Icons.home, label: 'Home'),
                _NavButton(icon: Icons.person, label: 'Entrenamientos'),
                _NavButton(icon: Icons.group , label: 'Teams'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                HeaderBar(
                  onLoginPressed: () => _handleLogin(context),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavButton({required this.icon, required this.label, super.key});

  static const Map<String, String> labelToRoute = {
    'Home': '/home',
    'Entrenamientos': '/trainings',
    'Teams': '/teams'
  };

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        final route = labelToRoute[label] ?? '/${label.toLowerCase()}';
        context.go(route);
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
    );
  }
}
