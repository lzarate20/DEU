import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'header_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
    switch (value) {
      case 'perfil':
        Navigator.pushNamed(context, '/perfil');
        break;
      case 'configuracion':
        Navigator.pushNamed(context, '/configuracion');
        break;
      case 'salir':
        await _logout(context);
        break;
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _handleLogin(BuildContext context) {
    Navigator.of(context).pushNamed('/login');
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
                _NavButton(icon: Icons.person, label: 'Perfil'),
                _NavButton(icon: Icons.settings, label: 'Configuración'),
              ],
            ),
          ),
          // Contenido
          Expanded(
            child: Column(
              children: [
                HeaderBar(
                  onMenuSelect: (value) => _handleMenuSelection(context, value),
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

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/${label.toLowerCase()}');
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
    );
  }
}
