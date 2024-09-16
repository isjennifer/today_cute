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

class Post {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String nickName;
  final List<dynamic> tags;
  final List<dynamic> fileUrls;
  late final PageController pageController;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.nickName,
    required this.tags,
    required this.fileUrls,
  }) {
    pageController = PageController();
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Post(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      nickName: json['nick_name'],
      tags: json['tags'],
      fileUrls: json['file_urls'],
    );
  }
}

class ImageBody extends StatefulWidget {
  const ImageBody({super.key});

  @override
  _ImageBodyState createState() => _ImageBodyState();
}

class _ImageBodyState extends State<ImageBody> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPostData();
  }

  Future<void> fetchPostData() async {
    try {
      final response = await http.get(
        Uri.parse('http://52.231.106.232:8000/api/post/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final List<dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        posts = decodedResponse.map((json) => Post.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return posts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              // print('포스트: ${post.id}');

              return Container(
                  width: double.infinity,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: Stack(children: [
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
                        (post.fileUrls[0].endsWith('jpg') ||
                                post.fileUrls[0].endsWith('jpeg') ||
                                post.fileUrls[0].endsWith('png') ||
                                post.fileUrls[0].endsWith('gif'))
                            ? Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    decoration:
                                        BoxDecoration(color: Colors.black),
                                    width: double.infinity,
                                    height: maxWidth,
                                    child: ClipRect(
                                        child: PageView.builder(
                                      controller: post.pageController,
                                      itemCount: post.fileUrls.length,
                                      itemBuilder: (context, index) {
                                        final url = post.fileUrls[index];
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
                                      count: post.fileUrls.length,
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
                            : VideoBody(fileUrl: post.fileUrls[0]),
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
                                          borderRadius:
                                              BorderRadius.circular(14),
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 10),
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
                        Container(
                          padding: const EdgeInsets.only(
                              left: 25, top: 0, right: 25, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(onPressed: () {}, child: Text('수정')),
                              TextButton(onPressed: () {}, child: Text('삭제')),
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
            });
  }
}
