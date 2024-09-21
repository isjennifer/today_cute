import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:today_cute/models/comment.dart';
import '../utils/expandable_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CommentDrawer extends StatefulWidget {
  final String postId;

  CommentDrawer({super.key, required this.postId});

  @override
  _CommentDrawerState createState() => _CommentDrawerState();
}

class _CommentDrawerState extends State<CommentDrawer> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final commentList = await fetchCommentData(widget.postId); // 댓글 가져오기 호출
    setState(() {
      comments = commentList;
      print('postList:$commentList');
      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  void dispose() {
    _commentController.dispose(); // 위젯이 사라질 때 컨트롤러 해제
    super.dispose();
  }

  Future<void> _commentPostDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // 모달 밖을 클릭하면 닫힘
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 400,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning),
                  SizedBox(height: 10),
                  Text(
                    '댓글 작성시 깃털이 한개 차감됩니다.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '댓글을 작성하시겠습니까?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _sendPostRequest();
                          Navigator.of(context).pop(); // 모달 창 닫기
                        },
                        child: Text('예'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 모달 창 닫기
                        },
                        child: Text('아니오'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendPostRequest() async {
    // SharedPreferences에서 accessToken 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final commentText = _commentController.text.trim();

    print("댓글 생성 요청 시작 내용:$commentText");
    // 만약 accessToken이 없다면, 예외 처리
    if (accessToken == null) {
      print('Access token이 없습니다.');
      return;
    } else {
      print('Access token: $accessToken'); // 이 부분이 제대로 출력되는지 확인
    }

    final url = Uri.parse(
        'http://52.231.106.232:8000/api/post/${widget.postId}/comment'); // 실제 서버 URL로 변경
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
      } else {
        print('POST 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('댓글 POST 요청 중 오류 발생: $e');
    }
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
            child: comments.isEmpty
                ? Center(
                    child: Text(
                      '아직 댓글이 없습니다.', // 댓글이 없을 때 표시할 메시지
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: comments.length, // comments 리스트의 길이만큼 아이템 생성
                    itemBuilder: (context, index) {
                      final comment =
                          comments[index]; // 각 index에 해당하는 comment 가져오기
                      return CommentContainer(
                          comment: comment); // CommentContainer에 comment 전달
                    },
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
                onPressed: () {
                  _commentPostDialog(context);
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

class CommentContainer extends StatefulWidget {
  final Comment comment; // Comment 객체를 받을 수 있도록 수정

  const CommentContainer(
      {super.key, required this.comment}); // 생성자에서 comment를 받도록 수정

  @override
  _CommentContainerState createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지를 원형으로 만듭니다.
          ClipOval(
            child: Image.asset(
              'assets/cat.png', // TODO:댓글 사용자로 이미지 받아오기
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),
          Container(
            width: maxWidth * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.comment.nickName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // 수정 버튼 클릭 시 동작할 코드
                            },
                            child: Text('수정'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // 패딩 제거
                              minimumSize: Size(0, 0), // 최소 크기 제거
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                              alignment: Alignment.center, // 텍스트 정렬
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 6.0),
                            height: 12.0,
                            width: 1.0,
                            color: Colors.grey, // 가로선 색상
                          ),
                          TextButton(
                            onPressed: () {
                              // 수정 버튼 클릭 시 동작할 코드
                            },
                            child: Text('삭제'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // 패딩 제거
                              minimumSize: Size(0, 0), // 최소 크기 제거
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                              alignment: Alignment.center, // 텍스트 정렬
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    child: ExpandableText(
                  text: widget.comment.content,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
