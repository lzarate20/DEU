import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  final Map<String, dynamic> training;
  final Map<String, dynamic> trainer;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const TrainingCard({
    super.key,
    required this.training,
    required this.trainer,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final name = training['name'] ?? 'Sin nombre';
    final description = training['description'] ?? '';
    final date = training['date'] ?? '';
    final trainingType = training['trainingType'] ?? 'Sin tipo';

    final exercises = training['exercises'];
    final exercisesCount = exercises is List ? exercises.length : 0;

    final trainerName = trainer['name'] ?? 'Desconocido';

    IconData icon;
    Color iconColor;

    switch (trainingType.toUpperCase()) {
      case 'STRENGTH':
        icon = Icons.fitness_center;
        iconColor = Colors.redAccent;
        break;
      case 'SPEED':
        icon = Icons.directions_run;
        iconColor = Colors.blueAccent;
        break;
      case 'DRIBBLING':
        icon = Icons.sports_football;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.fitness_center;
        iconColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(icon, size: 32, color: iconColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.list_alt, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Ejercicios: $exercisesCount'),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 16, color: Colors.grey),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Entrenador: $trainerName'),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
