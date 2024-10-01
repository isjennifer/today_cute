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
import 'post_container.dart';

class ImageBody extends StatefulWidget {
  const ImageBody({super.key});

  @override
  _ImageBodyState createState() => _ImageBodyState();
}

class _ImageBodyState extends State<ImageBody> {
  late ScrollController _scrollController;
  List<Post> posts = [];
  final int _maxLength = 10;

  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    final postList =
        await fetchPostData(); // api_service.dart의 fetchPostData 호출
    setState(() {
      posts = postList;
      print('postList:$postList');
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
    setState(() {
      isLoading = false;
      page = page + 1;
      hasMore = posts.length < _maxLength;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        if (hasMore) {
          fetchPosts();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return posts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: posts.length * (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: FittedBox(child: CircularProgressIndicator()),
                );
              }
              final post = posts[index];
              return PostContainer(
                post: post,
              );
            },
          );
  }
}
