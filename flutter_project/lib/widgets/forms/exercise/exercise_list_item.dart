import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseListItem extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onTap;

  const ExerciseListItem({required this.exercise, required this.onTap});

  String _getTypeLabel(String? type) {
    return switch (type) {
      'REPETITION' => 'Repeticiones',
      'TIME' => 'Duración',
      _ => 'Desconocido',
    };
  }

  String _getCategoryLabel(String? category) {
    return switch (category) {
      'WARMUP' => 'Calentamiento',
      'TRAINING' => 'Entrenamiento',
      'RECOVERY' => 'Recuperación',
      _ => 'Desconocida',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exercise['name'] ?? 'Sin nombre',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  if (exercise['video']?['url'] != null)
                    const Icon(Icons.play_circle_fill, color: Colors.green, size: 28),
                ],
              ),
              const SizedBox(height: 4),
              if (exercise['description'] != null)
                Text(
                  exercise['description'],
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 10,
                children: [
                  Chip(
                    label: Text('Tipo: ${_getTypeLabel(exercise['type'])}'),
                    backgroundColor: Colors.blue.shade50,
                  ),
                  Chip(
                    label: Text('Categoría: ${_getCategoryLabel(exercise['category'])}'),
                    backgroundColor: Colors.green.shade50,
                  ),
                  if (exercise['type'] == 'TIME')
                    Chip(
                      label: Text(
                          'Duración: ${exercise['time'] ?? 0} ${exercise['units'] ?? ''}'),
                      backgroundColor: Colors.orange.shade50,
                    ),
                  if (exercise['type'] == 'REPETITION')
                    Chip(
                      label: Text('Cantidad: ${exercise['count'] ?? 0} repeticiones'),
                      backgroundColor: Colors.orange.shade50,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}