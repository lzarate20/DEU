import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../exercise/training_actions.dart';

class TrainingDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> training;

  const TrainingDetailAppBar({super.key, required this.training});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Semantics(
        header: true,
        label: training['name'] ?? 'Detalle del entrenamiento',
        child: Text(
          training['name'] ?? 'Detalle',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        TrainingActions(
          training: training,
          onCopied: () {},
          onAssign: () {
            context.go('/assign-training/${training['id']}', extra: training);
          },
          onDeleted: () {
            context.go('/trainings');
          },
        ),
      ],
    );
  }
}
