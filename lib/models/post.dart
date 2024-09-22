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
  final int likes;
  final List<dynamic> likedUsersId;
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
    this.likes = 0, // 기본값을 0으로 설정
    required this.likedUsersId,
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
      likes: json.containsKey('likes_count')
          ? json['likes_count']
          : 0, // 좋아요 필드가 있을 때만 값을 사용, 없으면 0
      likedUsersId: json['liked_users_id'],
    );
  }
}
