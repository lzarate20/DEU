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
              Text('${e['count']} ${e['units']}'),
            ],
          ),
        );
      },
    );
  }

}

