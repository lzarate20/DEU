import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/evaluation.dart';
import '../../services/evaluation_service.dart';
import '../exercise/training_actions.dart';

class TrainingDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> training;

  const TrainingDetailAppBar({super.key, required this.training});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: FutureBuilder<EvaluationDTO?>(
              future: EvaluationService().getAverageEvaluation(
                  int.tryParse(training['id'].toString()) ?? 0),
              builder: (context, snapshot) {
                final score = (snapshot.hasData && snapshot.data != null)
                    ? snapshot.data!.score
                    : null;

                return Row(
                  children: [
                    Semantics(
                      header: true,
                      label: training['name'] ?? 'Detalle del entrenamiento',
                      child: Text(
                        training['name'] ?? 'Detalle',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (score != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(score.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
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

