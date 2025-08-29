import 'package:flutter/material.dart';
import '../selectable_card.dart';

class ExerciseCardWidget extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final bool selected;
  final VoidCallback onTap;

  const ExerciseCardWidget({
    super.key,
    required this.exercise,
    this.selected = false,
    required this.onTap,
  });

  String mapUnitsToSpanish(String? unit) {
    switch (unit) {
      case "SEC":
        return "segundos";
      case "MIN":
        return "minutos";
      case "HOUR":
        return "horas";
      default:
        return unit ?? '';
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case "WARMUP":
        return Icons.local_fire_department;
      case "TRAINING":
        return Icons.sports_gymnastics;
      case "RECOVERY":
        return Icons.self_improvement;
      default:
        return Icons.help_outline;
    }
  }

  IconData _getTypeIcon(String? type) {
    switch (type) {
      case "REPETITION":
        return Icons.repeat;
      case "TIME":
        return Icons.timer;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      selected: selected,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message: exercise['category'] ?? 'Desconocido',
            child: Icon(
              _getCategoryIcon(exercise['category']),
              size: 32,
              color: selected ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise['description'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Tooltip(
                      message: exercise['type'] == "REPETITION"
                          ? 'Repeticiones'
                          : 'Tiempo',
                      child: Icon(
                        _getTypeIcon(exercise['type']),
                        size: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      exercise['type'] == "REPETITION"
                          ? '${exercise['count']} repeticiones'
                          : '${exercise['time']} ${mapUnitsToSpanish(exercise['units'])}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
