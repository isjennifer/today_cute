import 'package:flutter/material.dart';

class Post {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String nickName;
  final List<dynamic> tags;
  final List<dynamic> files;
  final DateTime createdAt;
  late final PageController pageController;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.nickName,
    required this.tags,
    required this.files,
    required this.createdAt,
  }) {
    pageController = PageController();
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    print('post.dart-post:$json');
    return Post(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      nickName: json['nick_name'],
      tags: json['tags'],
      files: json['files'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
