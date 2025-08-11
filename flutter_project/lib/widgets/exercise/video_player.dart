import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerArea extends StatefulWidget {
  final String videoUrl;
  final bool showComments;

  const VideoPlayerArea({
    required this.videoUrl,
    required this.showComments,
    super.key,
  });

  @override
  State<VideoPlayerArea> createState() => _VideoPlayerAreaState();
}

class _VideoPlayerAreaState extends State<VideoPlayerArea> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant VideoPlayerArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializePlayer(widget.videoUrl);
    }

    if (widget.showComments) {
      _chewieController?.pause();
    }
  }

  Future<void> _initializePlayer(String url) async {
    final newVideoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await newVideoController.initialize();

    final newChewieController = ChewieController(
      videoPlayerController: newVideoController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        bufferedColor: Colors.grey,
        backgroundColor: Colors.black12,
      ),
      placeholder: Container(color: Colors.black),
    );

    // Luego reemplazamos los actuales
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    setState(() {
      _videoPlayerController = newVideoController;
      _chewieController = newChewieController;
    });
  }



  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null ||
        _videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: Stack(
            children: [
              Chewie(controller: _chewieController!),
              if (widget.showComments)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(color: Colors.transparent),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}




