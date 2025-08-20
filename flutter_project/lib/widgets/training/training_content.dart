import 'package:flutter/cupertino.dart';

import '../exercise/exercise_list.dart';
import '../exercise/video_player.dart';

class TrainingContent extends StatelessWidget {
  final List<dynamic> exercises;
  final int selectedIndex;
  final String videoUrl;
  final ValueChanged<int> onExerciseSelected;

  const TrainingContent({
    super.key,
    required this.exercises,
    required this.selectedIndex,
    required this.videoUrl,
    required this.onExerciseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ExerciseList(
            exercises: exercises,
            selectedIndex: selectedIndex,
            onSelect: onExerciseSelected,
          ),
        ),
        Expanded(
          flex: 3,
          child: VideoPlayerArea(
            videoUrl: videoUrl,
            showComments: false,
          ),
        ),
      ],
    );
  }
}