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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 780;

        return Scaffold(
          body: Row(
            children: [
              // Sidebar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isCompact ? 60 : 200, // ancho reducido o normal
                color: Colors.blue.shade700,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.dashboard,
                        size: isCompact ? 30 : 50,
                        color: Colors.white),
                    const SizedBox(height: 20),
                    // Nav buttons
                    _NavButton(
                      icon: Icons.home,
                      label: 'Home',
                      compact: isCompact,
                    ),
                    _NavButton(
                      icon: Icons.person,
                      label: 'Entrenamientos',
                      compact: isCompact,
                    ),
                    _NavButton(
                      icon: Icons.group,
                      label: 'Teams',
                      compact: isCompact,
                    ),
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
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool compact;

  const _NavButton({
    required this.icon,
    required this.label,
    this.compact = false,
    super.key,
  });

  static const Map<String, String> labelToRoute = {
    'Home': '/home',
    'Entrenamientos': '/trainings',
    'Teams': '/teams',
  };

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: compact ? Alignment.center : Alignment.centerLeft,
        minimumSize: Size(double.infinity, 48),
      ),
      onPressed: () {
        final route = labelToRoute[label] ?? '/${label.toLowerCase()}';
        context.go(route);
      },
      child: compact
          ? Icon(icon, color: Colors.white)
          : Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}

