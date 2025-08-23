import 'package:flutter/material.dart';
import '../selectable_card.dart';

class ExerciseList extends StatelessWidget {
  final List<dynamic> exercises;
  final int selectedIndex;
  final void Function(int) onSelect;

  const ExerciseList({
    required this.exercises,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
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
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final e = exercises[index];
        final selected = index == selectedIndex;

        return SelectableCard(
          selected: selected,
          onTap: () => onSelect(index),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono de categoría con tooltip
              Tooltip(
                message: e['category'] ?? 'Desconocido',
                child: Icon(
                  _getCategoryIcon(e['category']),
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
                      e['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e['description'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Tooltip(
                          message: e['type'] == "REPETITION"
                              ? 'Repeticiones'
                              : 'Tiempo',
                          child: Icon(
                            _getTypeIcon(e['type']),
                            size: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          e['type'] == "REPETITION"
                              ? '${e['count']} repeticiones'
                              : '${e['time']} ${mapUnitsToSpanish(e['units'])}',
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
      },
    );
  }
}







