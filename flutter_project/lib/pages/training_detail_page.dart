import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../widgets/exercise/comment_panel.dart';
import '../widgets/exercise/comment_toggle.dart';
import '../widgets/exercise/exercise_list.dart';
import '../widgets/exercise/video_player.dart';

class TrainingDetailPage extends StatefulWidget {
  final Map<String, dynamic> training;

  const TrainingDetailPage({required this.training, super.key});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  late List<dynamic> exercises;
  late YoutubePlayerController _ytController;
  int _selectedIndex = 0;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    exercises = widget.training['exercises'] ?? [];
    final firstVideoId = extractVideoId(exercises[0]['url'] ?? '');
    _ytController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
    if (firstVideoId.isNotEmpty) {
      _ytController.cueVideoById(videoId: firstVideoId);
    }
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  void _onExerciseSelected(int index) {
    final videoId = extractVideoId(exercises[index]['url'] ?? '');
    if (videoId.isNotEmpty) {
      _ytController.cueVideoById(videoId: videoId);
      setState(() {
        _selectedIndex = index;
        _showComments = false;
      });
    }
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
      if (_showComments) _ytController.pauseVideo();
    });
  }

  void _closeComments() {
    setState(() {
      _showComments = false;
    });
  }

  String extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    if (uri.host.contains('youtube.com')) {
      if (uri.pathSegments.contains('embed')) return uri.pathSegments.last;
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.training['comments'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training['name'] ?? 'Detalle'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ExerciseList(
                      exercises: exercises,
                      selectedIndex: _selectedIndex,
                      onSelect: _onExerciseSelected,
                    ),
                    VideoPlayerArea(
                      controller: _ytController,
                      showComments: _showComments,
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
              comments: comments,
              onClose: _closeComments,
            ),
          ],
        ],
      ),
    );
  }
}



