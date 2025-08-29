import 'package:flutter/cupertino.dart';
import 'exercise_card_widget.dart';

class ExerciseCarousel extends StatelessWidget {
  final List<dynamic> exercises;
  final int selectedIndex;
  final void Function(int) onSelect;

  const ExerciseCarousel({
    required this.exercises,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 250,
              child: ExerciseCardWidget(
                exercise: exercises[index],
                selected: index == selectedIndex,
                onTap: () => onSelect(index),
              ),
            ),
          );
        },
      ),
    );
  }
}

