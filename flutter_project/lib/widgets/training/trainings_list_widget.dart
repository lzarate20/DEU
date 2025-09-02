import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/training/training_icon.dart';
import 'package:go_router/go_router.dart';

class TrainingsList extends StatelessWidget {
  final List<Map<String, dynamic>> trainings;
  final VoidCallback? onBeforeNavigate;

  const TrainingsList({
    super.key,
    required this.trainings,
    this.onBeforeNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (trainings.isEmpty) {
      return Center(
        child: Text(
          'No hay entrenamientos disponibles',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        final training = trainings[index];

        return Semantics(
          container: true,
          button: true,
          label: 'Entrenamiento ${training['name'] ?? 'sin nombre'}. '
              'Descripción: ${training['description'] ?? 'sin descripción'}. '
              '${training['exercises'] != null ? (training['exercises'] as List).length : 0} ejercicios.',
          hint: 'Toca para ver el detalle del entrenamiento.',
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                hoverColor: Colors.grey.withOpacity(0.1),
                onTap: () {
                  onBeforeNavigate?.call();
                  context.go('/training/${training['id']}', extra: training);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        getTrainingIcon(training['trainingType'] ?? ''),
                        color: getTrainingIconColor(training['trainingType'] ?? ''),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              training['name'] ?? '',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              training['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.list_alt, size: 16, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            training['exercises'] != null
                                ? '${(training['exercises'] as List).length}'
                                : '0',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
