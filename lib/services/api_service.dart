import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:today_cute/config.dart';
import 'dart:convert';
import '../models/post.dart';
import '../models/comment.dart';

// Fetch posts from API
Future<List<Post>> fetchPostData() async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/post/'),
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

// Fetch posts from API
Future<List<Post>> searchPostData(
    {String? search, String sortBy = 'created_at'}) async {
  try {
    // 쿼리 파라미터를 포함한 URI 생성
    final uri = Uri.http('52.231.106.232:8000', '/api/post/search', {
      'search': search ?? '', // 검색어가 없으면 빈 값 전달
      'sort_by': sortBy, // 정렬 기준 (created_at 또는 likes)
    });

    final response = await http.get(
      uri,
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

Future<void> deletePostData(
    BuildContext context, String postId, String? token) async {
  print('deletePostData: $token');
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/post/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Authorization 헤더 추가
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물이 삭제되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('게시물 삭제 실패')));
      print('게시물 삭제 실패 ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
    // Show Snackbar with error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

Future<void> PutPostData(
    BuildContext context, String postId, String? token) async {
  print('deletePostData: $token');
  try {
    final response = await http.put(
      Uri.parse('$apiUrl/post/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Authorization 헤더 추가
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물이 수정되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('게시물 수정 실패')));
      print('게시물 수정 실패 ${response.body}');
    }
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
      Uri.parse('$apiUrl/user/$id'),
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

// Fetch comments from API
Future<List<Comment>> fetchCommentData(String postId) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/post/$postId/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final List<dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    // 'comments' 키가 존재하고 null이 아닐 경우 처리
    final List<dynamic> comments = decodedResponse ?? []; // null인 경우 빈 리스트로 대체
    print('api_service.dart-comments:$comments');
    return comments.map((json) => Comment.fromJson(json)).toList();
  } catch (e) {
    print('fetchCommentData-Error: $e');
    return []; // Return an empty list on error
  }
}

// Fetch comments from API
Future<List<Post>> fetchPopularPostData() async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/post/popular'),
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

Future<void> likePost(
    BuildContext context, String postId, String? token) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/post/$postId/like'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // 좋아요 성공 처리
      print('좋아요 성공');
    } else {
      // 오류 처리
      print('좋아요 실패 ${response.body}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('좋아요 실패')));
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

Future<void> createFCMTokenData(
    BuildContext context, String accessToken, String fcmToken) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/fcmtoken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{
        'fcm_token': fcmToken, // FCM 토큰을 JSON으로 보냄
      }),
    );
    if (response.statusCode == 200) {
      // FCM 토큰 생성 성공 처리
      print('FCM 토큰 생성 성공');
    } else {
      // 오류 처리
      print('FCM 토큰 생성 실패 ${response.body}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('FCM 토큰 생성 실패')));
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}
