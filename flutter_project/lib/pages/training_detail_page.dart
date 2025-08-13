import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/training_service.dart';
import '../widgets/exercise/comment_panel.dart';
import 'package:flutter/material.dart';
import '../widgets/exercise/comment_toggle.dart';
import '../widgets/exercise/exercise_list.dart';
import '../widgets/exercise/training_actions.dart';
import '../widgets/exercise/video_player.dart';
import '../services/training_service.dart';

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
  Map<String, dynamic>? training;
  List<dynamic> exercises = [];
  int _selectedIndex = 0;
  bool _showComments = false;
  String videoUrl = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.training != null) {
      _initWithData(widget.training!);
    } else {
      _fetchTraining();
    }
  }

  void _initWithData(Map<String, dynamic> data) {
    training = data;
    exercises = data['exercises'] ?? [];
    videoUrl = exercises.isNotEmpty ? exercises[0]['url'] ?? '' : '';
    _loading = false;
  }

  Future<void> _fetchTraining() async {
    try {
      final fetched = await TrainingService().fetchTrainingById(widget.trainingId);
      if (mounted) {
        setState(() {
          if (fetched != null) {
            _initWithData(fetched);
          } else {
            _loading = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar: $e')),
      );
    }
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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (training == null) {
      return const Scaffold(
        body: Center(child: Text('Entrenamiento no encontrado')),
      );
    }

    final comments = training!['comments'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(training!['name'] ?? 'Detalle'),
        actions: [
          TrainingActions(
            training: training!,
            onCopied: () {},
            onAssign: () {
              context.go(
                '/assign-training/${training?['id']}',
                extra: training,
              );
            },
            onDeleted: () {
              context.go('/trainings');
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
                  idTeam: training!['id'],
                  comment: text,
                );

                if (updated != null) {
                  setState(() {
                    _initWithData(updated);
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
