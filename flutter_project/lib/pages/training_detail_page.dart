import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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

  @override
  void initState() {
    super.initState();

    exercises = widget.training['exercises'] ?? [];

    final firstVideoId = extractVideoId(exercises[0]['url'] ?? '');


    _ytController = YoutubePlayerController(
    params: const YoutubePlayerParams(
    showControls: true,
    showFullscreenButton: true,
        strictRelatedVideos: true));
    if(!firstVideoId.isEmpty) {
      _ytController.cueVideoById(videoId: firstVideoId);
      setState(() {
        _selectedIndex = 0;
      });

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
      });
    }
  }

  String extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    if (uri.host.contains('youtube.com')) {
      if (uri.pathSegments.contains('embed')) {
        return uri.pathSegments.last;
      }
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final training = widget.training;
    final comments = training['comments'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(training['name'] ?? 'Detalle')),
      body: Row(
        children: [
          // ────── LISTA DE EJERCICIOS ──────
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final e = exercises[index];
                return Card(
                  color: index == _selectedIndex ? Colors.blue.shade50 : null,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(e['name'] ?? ''),
                    subtitle: Text(e['description'] ?? ''),
                    trailing: Text('${e['count']} ${e['units']}'),
                    onTap: () => _onExerciseSelected(index),
                  ),
                );
              },
            ),
          ),

          // ────── VIDEO + DETALLE ──────
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(controller: _ytController),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    training['description'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text('Comentarios:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final c = comments[index];
                        return ListTile(
                          leading: const Icon(Icons.comment),
                          title: Text(c['idUser']['name'] ?? ''),
                          subtitle: Text(c['comment'] ?? ''),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


