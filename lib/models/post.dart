import 'package:flutter/material.dart';

class Post {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String nickName;
  final List<dynamic> tags;
  final List<dynamic> fileUrls;
  final DateTime createdAt;
  late final PageController pageController;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.nickName,
    required this.tags,
    required this.fileUrls,
    required this.createdAt,
  }) {
    pageController = PageController();
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    print(json);
    return Post(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      nickName: json['nick_name'],
      tags: json['tags'],
      fileUrls: json['file_urls'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
