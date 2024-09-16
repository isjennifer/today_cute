import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/expandable_text.dart';

class VideoBody extends StatefulWidget {
  final String fileUrl;

  const VideoBody({Key? key, required this.fileUrl}) : super(key: key);

  @override
  _VideoBodyState createState() => _VideoBodyState();
}

class _VideoBodyState extends State<VideoBody> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse('http://52.231.106.232:8000${widget.fileUrl}'))
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
      }).catchError((error) {
        print('Error initializing video player: $error');
      });

    _videoController.addListener(() {
      if (_videoController.value.isInitialized) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  String _getRemainingTime() {
    final duration = _videoController.value.duration;
    final position = _videoController.value.position;
    final remaining = duration - position;
    final minutes =
        remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          VisibilityDetector(
            key: Key('video-player'),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction > 0.5 &&
                  !_videoController.value.isPlaying) {
                _videoController.play();
              } else if (info.visibleFraction <= 0.5 &&
                  _videoController.value.isPlaying) {
                _videoController.pause();
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(color: Colors.black),
              width: double.infinity,
              height: 600,
              child: ClipRect(
                child: _videoController.value.isInitialized
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          if (_videoController.value.isInitialized)
            Positioned(
              bottom: 25,
              right: 20,
              child: Text(
                _getRemainingTime(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 1.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
