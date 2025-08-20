import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/training_service.dart';
import '../widgets/exercise/comment_toggle.dart';
import '../widgets/training/comments_overlay.dart';
import '../widgets/training/training_content.dart';
import '../widgets/training/training_detail_appbar.dart';
import '../widgets/training/training_detail_controller.dart';

class TrainingDetailPage extends StatefulWidget {
  final String trainingId;
  final Map<String, dynamic>? training;

  const TrainingDetailPage({
    required this.trainingId,
    this.training,
    super.key,
  });

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  int _selectedIndex = 0;
  bool _showComments = false;
  String videoUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TrainingDetailController>()
          .loadTraining(widget.trainingId, initial: widget.training);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrainingDetailController>();

    if (controller.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.training == null) {
      return const Scaffold(body: Center(child: Text('Entrenamiento no encontrado')));
    }

    final training = controller.training!;
    final exercises = controller.exercises;

    if (videoUrl.isEmpty && exercises.isNotEmpty) {
      videoUrl = exercises[0]['url'] ?? '';
    }

    final comments = training['comments'] ?? [];

    return Scaffold(
      appBar: TrainingDetailAppBar(training: training),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TrainingContent(
                  exercises: exercises,
                  selectedIndex: _selectedIndex,
                  videoUrl: videoUrl,
                  onExerciseSelected: (i) {
                    setState(() {
                      videoUrl = exercises[i]['url'] ?? '';
                      _selectedIndex = i;
                      _showComments = false;
                    });
                  },
                ),
              ),
              CommentToggleBar(
                showComments: _showComments,
                onTap: () => setState(() => _showComments = !_showComments),
              ),
            ],
          ),
          if (_showComments)
            CommentsOverlay(
              comments: comments,
              onClose: () => setState(() => _showComments = false),
              onSendComment: (text) async {
                final updated = await TrainingService().addCommentToTraining(
                  idTeam: training['id'],
                  comment: text,
                );
                if (updated != null) {
                  controller.loadTraining(widget.trainingId, initial: updated);
                }
                return updated;
              },
            ),
        ],
      ),
    );
  }
}


