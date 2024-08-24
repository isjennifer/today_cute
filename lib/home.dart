import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0XFFFFFFFDE),
        child: ListView(
          children: [
            ImageBody(),
            VideoBody(),
          ],
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  static const int maxLinesBeforeExpand = 2;

  @override
  Widget build(BuildContext context) {
    final linkText = isExpanded ? ' 접기' : ' 더보기';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: TextStyle(color: Colors.black),
        );

        final linkTextSpan = TextSpan(
          text: linkText,
          style: TextStyle(color: Colors.blue),
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: TextStyle(color: Colors.black),
          ),
          maxLines: maxLinesBeforeExpand,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines && !isExpanded) {
          final pos = textPainter.getPositionForOffset(
            Offset(textPainter.width - linkTextSpan.toPlainText().length * 7,
                textPainter.height),
          );
          final endIndex = pos.offset - linkTextSpan.toPlainText().length;

          final truncatedText = widget.text.substring(0, endIndex) + '...';

          return GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: truncatedText,
                    style: TextStyle(color: Colors.black),
                  ),
                  linkTextSpan,
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: RichText(
            text: TextSpan(
              text: widget.text,
              style: TextStyle(color: Colors.black),
              children: [
                if (isExpanded) linkTextSpan,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageBody extends StatefulWidget {
  const ImageBody({super.key});

  @override
  _ImageBodyState createState() => _ImageBodyState();
}

class _ImageBodyState extends State<ImageBody> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
        child: Stack(children: [
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
                          fontSize: 18, // 텍스트 크기 설정
                        ),
                        overflow: TextOverflow.ellipsis, // 길어지면 ...으로 표시
                        maxLines: 1, // 한 줄로 제한
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: double.infinity,
                height: 340,
                child: ClipRect(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Image.asset(
                        'assets/dog.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/cat.png',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: SmoothPageIndicator(
                  controller: _pageController, // PageView의 controller
                  count: 2, // 이미지 개수에 맞게 설정
                  effect: ExpandingDotsEffect(
                    dotHeight: 5.0,
                    dotWidth: 5.0,
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey,
                  ),
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
                        SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격 추가 (선택 사항)
                        Text('아이디'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                        SizedBox(width: 8), // 아이콘 사이에 간격 추가 (선택 사항)
                        Icon(Icons.bookmark_border),
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
                        scrollDirection: Axis.horizontal, // 가로로 스크롤 가능하게 설정
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                              decoration: BoxDecoration(
                                color: Color(0XFFFFF99CC), // 배경색 설정
                                borderRadius:
                                    BorderRadius.circular(14), // 모서리를 둥글게 설정
                              ),
                              child: Text(
                                '#고양이',
                                style: TextStyle(
                                  color: Colors.black, // 텍스트 색상을 흰색으로 설정
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                              decoration: BoxDecoration(
                                color: Color(0XFFFFFFF66), // 배경색 설정
                                borderRadius:
                                    BorderRadius.circular(14), // 모서리를 둥글게 설정
                              ),
                              child: Text(
                                '#귀욤짤',
                                style: TextStyle(
                                  color: Colors.black, // 텍스트 색상을 흰색으로 설정
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                              decoration: BoxDecoration(
                                color: Color(0XFFFCCFFFF), // 배경색 설정
                                borderRadius:
                                    BorderRadius.circular(14), // 모서리를 둥글게 설정
                              ),
                              child: Text(
                                '#강아지',
                                style: TextStyle(
                                  color: Colors.black, // 텍스트 색상을 흰색으로 설정
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                              decoration: BoxDecoration(
                                color: Color(0XFFFCCFFFF), // 배경색 설정
                                borderRadius:
                                    BorderRadius.circular(14), // 모서리를 둥글게 설정
                              ),
                              child: Text(
                                '#강아지',
                                style: TextStyle(
                                  color: Colors.black, // 텍스트 색상을 흰색으로 설정
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
        ]));
  }
}

class VideoBody extends StatefulWidget {
  const VideoBody({super.key});

  @override
  _VideoBodyState createState() => _VideoBodyState();
}

class _VideoBodyState extends State<VideoBody> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/sample_video.mp4')
      ..initialize().then((_) {
        setState(() {}); // 비디오 초기화 후 화면을 다시 그립니다.
        _videoController.setLooping(true);
        _videoController.play(); // 비디오 자동 재생
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // 메모리 누수를 방지하기 위해 컨트롤러를 해제합니다.
    super.dispose();
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
                          fontSize: 18, // 텍스트 크기 설정
                        ),
                        overflow: TextOverflow.ellipsis, // 길어지면 ...으로 표시
                        maxLines: 1, // 한 줄로 제한
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: double.infinity,
                height: 340,
                child: ClipRect(
                  child: _videoController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        )
                      : Center(child: CircularProgressIndicator()),
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
                        SizedBox(width: 8),
                        Icon(Icons.bookmark_border),
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
