import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainerCard extends StatelessWidget {
  final dynamic trainer;

  const TrainerCard({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Entrenador",
              style: theme.textTheme.titleMedium,
            ),
            const Divider(thickness: 2, height: 20),
            if (trainer != null)
              ListTile(
                leading: const Icon(Icons.sports),
                title: Text(
                  trainer['name'] ?? 'Desconocido',
                  style: theme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  trainer['email'] ?? '',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              Text(
                "No se encontró entrenador asignado.",
                style: theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
