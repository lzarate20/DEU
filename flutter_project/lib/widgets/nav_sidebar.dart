import 'package:flutter/material.dart';

class NavSidebar extends StatelessWidget {
  const NavSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blue.shade700,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.dashboard, size: 50, color: Colors.white),
          const SizedBox(height: 20),
          _NavButton(icon: Icons.home, label: 'Home'),
          _NavButton(icon: Icons.person, label: 'Perfil'),
          _NavButton(icon: Icons.settings, label: 'Configuración'),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        print('Navegaste a $label');
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
    );
  }
}
