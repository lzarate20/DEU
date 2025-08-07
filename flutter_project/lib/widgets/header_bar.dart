import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/settings.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/notification_icon.dart'; // <-- importar el widget

class HeaderBar extends StatelessWidget {
  final VoidCallback? onLoginPressed;

  const HeaderBar({super.key, this.onLoginPressed});

  Future<void> _handleMenuSelect(BuildContext context, String value) async {
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
        await _logout(context);
        break;
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
          Text(
            'Mi Aplicación',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Cambiar tema',
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: themeProvider.toggleTheme,
              ),

              // 🔔 Campanita de notificaciones
              const NotificationIcon(),

              FutureBuilder<bool>(
                future: AuthService.isLoggedIn(),
                builder: (context, snapshot) {
                  final isLoggedIn = snapshot.data ?? false;

                  if (!isLoggedIn && onLoginPressed != null) {
                    return TextButton(
                      onPressed: onLoginPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Iniciar sesión'),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuSelect(context, value),
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'perfil', child: Text('Perfil')),
                  PopupMenuItem(
                      value: 'configuracion', child: Text('Configuración')),
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




