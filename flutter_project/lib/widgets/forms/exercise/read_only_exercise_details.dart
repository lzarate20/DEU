import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadOnlyExerciseDetails extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const ReadOnlyExerciseDetails({Key? key, required this.exercise})
      : super(key: key);

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

  Widget _buildReadOnlyRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = exercise['video']?['url'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReadOnlyRow(context, 'Nombre', exercise['name'] ?? ''),
            _buildReadOnlyRow(context, 'Descripción', exercise['description'] ?? ''),
            _buildReadOnlyRow(context, 'Tipo', _getTypeLabel(exercise['type'])),
            _buildReadOnlyRow(
                context, 'Categoría', _getCategoryLabel(exercise['category'])),
            if (exercise['type'] == 'TIME')
              _buildReadOnlyRow(context, 'Duración',
                  '${exercise['time'] ?? 0} ${exercise['units'] ?? ''}'),
            if (exercise['type'] == 'REPETITION')
              _buildReadOnlyRow(
                  context, 'Cantidad', '${exercise['count'] ?? 0} repeticiones'),
            if (videoUrl != null && videoUrl.toString().isNotEmpty)
              _buildReadOnlyRow(context, 'URL del video', videoUrl),
          ],
        ),
      ),
    );
  }
}