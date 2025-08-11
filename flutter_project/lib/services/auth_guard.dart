import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          Future.microtask(() {
            context.go('/');
          });
          return const SizedBox();
        }

        return protectedPage;
      },
    );
  }
}