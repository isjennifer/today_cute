import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

// Fetch posts from API
Future<List<Post>> fetchPostData() async {
  try {
    final response = await http.get(
      Uri.parse('http://52.231.106.232:8000/api/post/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final List<dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    // 'posts' 키가 존재하고 null이 아닐 경우 처리
    final List<dynamic> posts = decodedResponse ?? []; // null인 경우 빈 리스트로 대체
    print('api_service.dart-posts:$posts');
    return posts.map((json) => Post.fromJson(json)).toList();
  } catch (e) {
    print('fetchPostData-Error: $e');
    return []; // Return an empty list on error
  }
}

Future<void> deletePostData(BuildContext context, String postId) async {
  try {
    final response = await http.delete(
      Uri.parse('http://52.231.106.232:8000/api/post/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  } catch (e) {
    print('Error: $e');
    // Show Snackbar with error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

// Fetch user data from API (if needed)
Future<Map<String, dynamic>> fetchId(String id) async {
  try {
    print('fetchId:$id');
    final response = await http.get(
      Uri.parse('http://52.231.106.232:8000/api/user/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // print('Response status: ${response.statusCode}');
    // print('Response headers: ${response.headers}'); // 응답 헤더 확인
    // print('Raw response body: ${response.body}'); // 원시 응답 확인

    // 인코딩 방식 확인 및 한글 응답 처리
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
    print('내정보: $decodedResponse');

    return decodedResponse; // Map으로 반환
  } catch (e) {
    print('fechId-Error: $e');
    return {}; // 빈 Map 반환
  }
}
