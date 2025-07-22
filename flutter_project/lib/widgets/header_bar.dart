import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/settings.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';


class HeaderBar extends StatelessWidget {
  final VoidCallback? onLoginPressed;

  const HeaderBar({super.key, this.onLoginPressed, required Future<void> Function(dynamic value) onMenuSelect});

  void _handleMenuSelect(BuildContext context, String value) {
    switch (value) {
      case 'perfil':
        break;
      case 'configuracion':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => const SettingsModalContent(),
        );
        break;
      case 'salir':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mi Aplicación',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Cambiar tema',
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: themeProvider.toggleTheme,
              ),
              TextButton(
                onPressed: onLoginPressed,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('Iniciar sesión'),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuSelect(context, value),
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'perfil', child: Text('Perfil')),
                  PopupMenuItem(value: 'configuracion', child: Text('Configuración')),
                  PopupMenuItem(value: 'salir', child: Text('Salir')),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}



