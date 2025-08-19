import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/settings.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/notification_icon.dart';

class HeaderBar extends StatelessWidget {
  final VoidCallback? onLoginPressed;

  const HeaderBar({super.key, this.onLoginPressed});

  Future<void> _handleMenuSelect(BuildContext context, String value) async {
    switch (value) {
      case 'perfil':
        context.go('/perfil');
        break;
      case 'configuracion':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          useSafeArea: true,
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
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      child: Row(
        children: [
          const SizedBox(width: 48),

          Expanded(
            child: Semantics(
              header: true, // Marca como <h1>
              child: Text(
                'TeamUp',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Semantics(
            button: true,
            label: 'Cambiar tema',
            child: IconButton(
              tooltip: 'Cambiar tema',
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: themeProvider.toggleTheme,
            ),
          ),


          Semantics(
            button: true,
            label: 'Notificaciones',
            child: const NotificationIcon(),
          ),

          FutureBuilder<bool>(
            future: AuthService.isLoggedIn(),
            builder: (context, snapshot) {
              final isLoggedIn = snapshot.data ?? false;

              if (!isLoggedIn && onLoginPressed != null) {
                return Semantics(
                  button: true,
                  label: 'Iniciar sesión',
                  child: TextButton(
                    onPressed: onLoginPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Iniciar sesión'),
                  ),
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
              PopupMenuItem(value: 'configuracion', child: Text('Configuración')),
              PopupMenuItem(value: 'salir', child: Text('Salir')),
            ],
          ),
        ],
      ),
    );
  }
}

