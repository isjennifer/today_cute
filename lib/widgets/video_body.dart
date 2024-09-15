import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/expandable_text.dart';

class VideoBody extends StatefulWidget {
  const VideoBody({super.key});

  @override
  _VideoBodyState createState() => _VideoBodyState();
}

class _VideoBodyState extends State<VideoBody> {
  late VideoPlayerController _videoController;
  bool _isVideoVisible = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/sample_video.mp4')
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
    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '우리집 강아지 자랑좀 할게여라라라라라라ㅏ라랄라ㅏㄹㄹㄹ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
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
                                    aspectRatio:
                                        _videoController.value.aspectRatio,
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
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text('아이디'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: ExpandableText(
                  text:
                      '우리집 강아지 너무 귀엽지ddddd 않나요? 이 강아지는 저와 함께 산책도 하고 놀아주기도 하고 정말 즐거운 시간을 보내고 있어요. 너무 사랑스럽고 귀여워서 하루하루가 정말 행복해요. 강아지가 제 인생에 얼마나 큰 기쁨을 주는지 말로 표현할 수 없어요. 정말 너무너무 귀엽답니다!',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '2024년 10월 20일',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      width: 250,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0XFFFFF99CC),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '#고양이',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0XFFFFFFF66),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '#귀욤짤',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0XFFFCCFFFF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '#강아지',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0XFFFCCFFFF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '#강아지',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/character_color.png',
                  width: 150,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
