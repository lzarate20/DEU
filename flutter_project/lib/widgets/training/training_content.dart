import 'package:flutter/material.dart';

import '../exercise/exercise_carousel.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isSmallScreen = screenWidth < 1000;

    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VideoPlayerArea(videoUrl: videoUrl, showComments: false),
          const SizedBox(height: 16),
          ExerciseCarousel(
            exercises: exercises,
            selectedIndex: selectedIndex,
            onSelect: onExerciseSelected,
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: VideoPlayerArea(videoUrl: videoUrl, showComments: false),
          ),
        ],
      );
    }
  }
}
