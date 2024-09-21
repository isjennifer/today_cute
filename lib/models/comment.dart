import 'package:flutter/material.dart';

class Comment {
  final String id;
  final String userId;
  final String content;
  final String nickName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.nickName,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    print('comment.dart-comment:$json');
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      nickName: json['nick_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
