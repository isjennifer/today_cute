import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/expandable_text.dart';
import 'comment_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'video_body.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../utils/token_utils.dart';
import '../screens/profile.dart';

class PostContainer extends StatefulWidget {
  final Post post;
  // final VoidCallback onDelete; // 콜백 함수 추가

  const PostContainer({
    Key? key,
    required this.post,
    // required this.onDelete, // 콜백 함수 전달
  }) : super(key: key);

  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  String myId = '';

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    myId = await getUserIdFromToken();
    setState(() {
      // 토큰의 정보 출력
      print('Decoded Token: $myId');
      // getTokenExpiryDate(token) 호출 필요 없음
    });
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;
    final file = post.files;
    final fileUrls = file.map((file) => file['url']).toList();
    // print('post_container.dart-post:${post.files}');
    // print('post_container.dart-file:${file.map((file) => file['url'])}');
    // print('post_container.dart-fileUrls:$fileUrls');
    double maxWidth = MediaQuery.of(context).size.width;

    final List<Color> colors = [
      Color(0XFFFFF99CC),
      Color(0XFFFCCFFFF),
      Color(0XFFFFFFF66),
    ];

    Color getRandomColor() {
      Random random = Random();
      return colors[random.nextInt(colors.length)];
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
                        post.title,
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
              (fileUrls[0].endsWith('jpg') ||
                      fileUrls[0].endsWith('jpeg') ||
                      fileUrls[0].endsWith('png') ||
                      fileUrls[0].endsWith('gif'))
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(color: Colors.black),
                          width: double.infinity,
                          height: maxWidth,
                          child: ClipRect(
                              child: PageView.builder(
                            controller: post.pageController,
                            itemCount: fileUrls.length,
                            itemBuilder: (context, index) {
                              final url = fileUrls[index];
                              return Image.network(
                                'http://52.231.106.232:8000$url',
                              );
                            },
                          )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SmoothPageIndicator(
                            controller: post.pageController,
                            count: fileUrls.length,
                            effect: ScrollingDotsEffect(
                              dotHeight: 5.0,
                              dotWidth: 5.0,
                              activeDotColor: Colors.black,
                              dotColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  : VideoBody(fileUrl: fileUrls[0]),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, top: 15, right: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text(post.nickName),
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
                padding: const EdgeInsets.only(
                    left: 25, top: 15, right: 25, bottom: 15),
                child: ExpandableText(
                  text: post.content,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: post.tags[0]
                        .toString()
                        .split(',')
                        .map<Widget>((tag) => Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: getRandomColor(),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '#${tag.trim()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (BuildContext context) {
                          return CommentDrawer();
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 22,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text(
                          '가장 최근 댓글이 나타납니다. 너무 귀요워용 ㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜ',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ))
                      ],
                    )),
              ),
              // myId == post.userId
              //     ? Container(
              //         padding: const EdgeInsets.only(
              //             left: 25, top: 0, right: 25, bottom: 20),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             TextButton(
              //                 onPressed: () {
              //                   // Add functionality for edit
              //                 },
              //                 child: Text('수정')),
              //             TextButton(
              //                 onPressed: () async {
              //                   await _deletePostDialog(context);
              //                 },
              //                 child: Text('삭제')),
              //           ],
              //         ),
              //       )
              //     : SizedBox(height: 10) // 빈 공간을 반환
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
