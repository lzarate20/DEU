import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final e = exercises[index];
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Card(
            color: index == selectedIndex ? Colors.blue.shade50 : null,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(e['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${e['count']} ${e['units']}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

