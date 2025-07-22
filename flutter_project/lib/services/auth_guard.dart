import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthGuard extends StatelessWidget {
  final Widget protectedPage;

  const AuthGuard({super.key, required this.protectedPage});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;

        if (token == null) {
          // Si no hay token, redirigimos al inicio
          Future.microtask(() {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
          });
          return const SizedBox(); // evitar mostrar pantalla protegida
        }

        return protectedPage; // Hay sesión, mostrar la página protegida
      },
    );
  }
}