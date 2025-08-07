import 'package:flutter/material.dart';
import '../services/training_service.dart';
import '../widgets/exercise/comment_panel.dart';
import '../widgets/exercise/comment_toggle.dart';
import '../widgets/exercise/exercise_list.dart';
import '../widgets/exercise/training_actions.dart';
import '../widgets/exercise/video_player.dart';

class TrainingDetailPage extends StatefulWidget {
  final Map<String, dynamic> training;

  const TrainingDetailPage({required this.training, super.key});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  late Map<String, dynamic> training;
  late List<dynamic> exercises;
  int _selectedIndex = 0;
  bool _showComments = false;
  late String videoUrl;

  @override
  void initState() {
    super.initState();
    training = widget.training;
    exercises = training['exercises'] ?? [];
    videoUrl = exercises.isNotEmpty ? exercises[0]['url'] ?? '' : '';
  }

  void _onExerciseSelected(int index) {
    setState(() {
      videoUrl = exercises[index]['url'] ?? '';
      _selectedIndex = index;
      _showComments = false;
    });
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  void _closeComments() {
    setState(() {
      _showComments = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final comments = training['comments'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(training['name'] ?? 'Detalle'),
        actions: [
          TrainingActions(
            training: training,
            onCopied: () {},
            onEdited: () {
              Navigator.pushNamed(context, '/edit_training', arguments: training);
            },
            onDeleted: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ExerciseList(
                        exercises: exercises,
                        selectedIndex: _selectedIndex,
                        onSelect: _onExerciseSelected,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: VideoPlayerArea(
                        videoUrl: videoUrl,
                        showComments: _showComments,
                      ),
                    ),
                  ],
                ),
              ),
              CommentToggleBar(
                showComments: _showComments,
                onTap: _toggleComments,
              ),
            ],
          ),
          if (_showComments) ...[
            ModalBarrier(
              color: Colors.black54,
              dismissible: true,
              onDismiss: _closeComments,
            ),
            CommentsPanel(
              initialComments: comments,
              onClose: _closeComments,
              onSendComment: (text) async {
                final updated = await TrainingService().addCommentToTraining(
                  idTeam: training['id'],
                  comment: text,
                );

                if (updated != null) {
                  setState(() {
                    training = updated;
                    exercises = training['exercises'] ?? [];
                  });
                }

                return updated;
              },
            ),
          ],
        ],
      ),
    );
  }
}




