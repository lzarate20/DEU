import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
      _selectedIndex = 0;
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
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text(training['name'] ?? 'Detalle')),
            IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
            if (training['own'] == true)
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Lista de ejercicios
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final e = exercises[index];
                          return GestureDetector(
                            onTap: () => _onExerciseSelected(index),
                            child: Card(
                              color: index == _selectedIndex ? Colors.blue.shade50 : null,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(e['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text('${e['count']} ${e['units']}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Video
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(controller: _ytController),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showComments = !_showComments),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.comment),
                      const SizedBox(width: 8),
                      const Text('Comentarios', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Icon(_showComments ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
              )
            ],
          ),
          // Comentarios superpuestos
          if (_showComments)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Material(
                elevation: 8,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: Colors.blueGrey.shade700,
                      child: Row(
                        children: [
                          const Text('Comentarios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() => _showComments = false),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: comments.map<Widget>((c) {
                          return ListTile(
                            leading: const Icon(Icons.comment),
                            title: Text(c['idUser']['name'] ?? ''),
                            subtitle: Text(c['comment'] ?? ''),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Agregar comentario...',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.send),
                        ),
                        onSubmitted: (text) {
                          // lógica de envío
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}



