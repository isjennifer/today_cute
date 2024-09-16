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
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final postList =
        await fetchPostData(); // api_service.dart의 fetchPostData 호출
    setState(() {
      posts = postList;
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  Future<void> _deletePost(String postId) async {
    await deletePostData(postId, context);
    fetchPosts(); // 삭제 후 새로고침
  }

  @override
  Widget build(BuildContext context) {
    return posts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostContainer(
                post: post,
                onDelete: () => _deletePost(post.id), // 삭제 콜백 함수 전달
              );
            },
          );
  }
}
