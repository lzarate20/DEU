import 'package:flutter_project/pages/teams/team_list_page.dart';
import 'package:go_router/go_router.dart';

import '../pages/dashboard_page.dart';
import '../pages/error_page.dart';
import '../pages/landing_page.dart';
import '../pages/register.dart';
import '../pages/teams/team_detail_page.dart';
import '../pages/training_detail_page.dart';
import '../pages/trainings/assign_training_page.dart';
import '../pages/trainings/create_training_page.dart';
import '../pages/trainings/trainings_page.dart';
import '../widgets/base_layout.dart';
import 'package:flutter/material.dart';

class NoTransitionPage extends CustomTransitionPage {
  NoTransitionPage({required Widget child})
      : super(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(child: LandingPage()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => NoTransitionPage(child: const RegisterPage()),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BaseLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage(child: const DashboardPage()),
        ),
        GoRoute(
          path: '/trainings',
          pageBuilder: (context, state) => NoTransitionPage(child: const TrainingListPage()),
        ),
        GoRoute(
          path: '/training/new',
          pageBuilder: (context, state) => NoTransitionPage(child: const CreateTrainingPage()),
        ),
        GoRoute(
          path: '/training/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            final training = state.extra as Map<String, dynamic>?;
            return NoTransitionPage(
              child: TrainingDetailPage(
                trainingId: id,
                training: training,
              ),
            );
          },
        ),
        GoRoute(
          path: '/teams',
          pageBuilder: (context, state) => NoTransitionPage(child: const TeamListPage()),
        ),
        GoRoute(
          path: '/team/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            final team = state.extra as Map<String, dynamic>?;
            return NoTransitionPage(
              child: TeamDetailPage(teamId: id, team: team),
            );
          },
        ),
        GoRoute(
          path: '/assign-training/:id',
          pageBuilder: (context, state) {
            final trainingId = int.tryParse(state.pathParameters['id'] ?? '');
            if (trainingId == null) {
              return MaterialPage(child: Scaffold(body: Center(child: Text('Entrenamiento inválido'))));
            }
            final training = state.extra as Map<String, dynamic>?; // extra opcional
            return MaterialPage(
              child: AssignTrainingPage(trainingId: trainingId, training: training),
            );
          },
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      child: BaseLayout(
        child: ErrorPage(error: state.error),
      ),
    );
  },
);