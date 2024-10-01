import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:today_cute/config.dart';
import 'package:today_cute/models/comment.dart';
import '../utils/expandable_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'comment_container.dart';

class CommentDrawer extends StatefulWidget {
  final String postId;

  CommentDrawer({super.key, required this.postId});

  @override
  _CommentDrawerState createState() => _CommentDrawerState();
}

class _CommentDrawerState extends State<CommentDrawer> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];
  bool isLoading = false; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    setState(() {
      isLoading = true;
    });
    try {
      final commentList = await fetchCommentData(widget.postId); // 댓글 가져오기 호출
      setState(() {
        comments = commentList;
        print('postList:$commentList');
        comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } catch (e) {
      print('댓글 가져오기 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 가져오는 중 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose(); // 위젯이 사라질 때 컨트롤러 해제
    super.dispose();
  }

  Future<void> _sendPostRequest() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 내용을 입력해주세요.')),
      );
      return;
    }

    // SharedPreferences에서 accessToken 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    print("댓글 생성 요청 시작 내용:$commentText");
    // 만약 accessToken이 없다면, 예외 처리
    if (accessToken == null) {
      print('Access token이 없습니다.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    } else {
      print('Access token: $accessToken'); // 이 부분이 제대로 출력되는지 확인
    }

    final url = Uri.parse(
        '$apiUrl/api/post/${widget.postId}/comment'); // 실제 서버 URL로 변경
    final body = jsonEncode({
      'content': commentText, // 필요한 데이터로 수정
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
          },
          body: body);
      if (response.statusCode == 200) {
        print('POST 요청 성공: ${response.body}');
        _commentController.clear(); // 댓글 전송 후 입력란 초기화
        await fetchComments();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글이 성공적으로 작성되었습니다.')),
        );
      } else {
        print('POST 요청 실패: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 작성에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('댓글 POST 요청 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  // 댓글이 수정되었을 때 호출될 함수
  void _onCommentUpdated() {
    // 댓글 수정 후 게시글 리스트를 다시 패치
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 20.0,
        right: 20.0,
        bottom: 50.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 내용에 맞게 서랍의 높이를 조절
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : comments.isEmpty
                    ? Center(
                        child: Text(
                          '아직 댓글이 없습니다.', // 댓글이 없을 때 표시할 메시지
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchComments,
                        child: ListView.builder(
                          itemCount:
                              comments.length, // comments 리스트의 길이만큼 아이템 생성
                          itemBuilder: (context, index) {
                            final comment =
                                comments[index]; // 각 index에 해당하는 comment 가져오기
                            return CommentContainer(
                                comment: comment,
                                onCommentUpdated:
                                    _onCommentUpdated); // CommentContainer에 comment 전달
                          },
                        ),
                      ),
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: ' 댓글을 입력하세요...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
                  await _sendPostRequest();
                },
                child: Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), // 버튼을 원형으로 만듦
                  padding: EdgeInsets.all(12.0), // 버튼 크기 조정
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
