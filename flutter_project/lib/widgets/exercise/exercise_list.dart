import 'package:flutter/cupertino.dart';

import 'exercise_card_widget.dart';

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
        return ExerciseCardWidget(
          exercise: exercises[index],
          selected: index == selectedIndex,
          onTap: () => onSelect(index),
        );
      },
    );
  }
}








