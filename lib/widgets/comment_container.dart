import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:today_cute/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_cute/utils/expandable_text.dart';

class CommentContainer extends StatefulWidget {
  final Comment comment; // Comment 객체를 받을 수 있도록 수정
  final Function onCommentUpdated; // 부모로부터 콜백 함수를 받음

  const CommentContainer({
    super.key,
    required this.comment,
    required this.onCommentUpdated,
  }); // 생성자에서 comment를 받도록 수정

  @override
  _CommentContainerState createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  bool isExpanded = true;
  bool isEditing = false;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.comment.content);
  }

  Future<void> _sendUpdateRequest(String commentId) async {
    // SharedPreferences에서 accessToken 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final commentText = _commentController.text.trim();

    print("댓글 수정 요청 시작 내용:$commentText");
    // 만약 accessToken이 없다면, 예외 처리
    if (accessToken == null) {
      print('Access token이 없습니다.');
      return;
    } else {
      print('Access token: $accessToken'); // 이 부분이 제대로 출력되는지 확인
    }

    final url = Uri.parse(
        'http://52.231.106.232:8000/api/post/comment/$commentId'); // 실제 서버 URL로 변경
    final body = jsonEncode({
      'content': commentText, // 필요한 데이터로 수정
    });

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
          },
          body: body);
      if (response.statusCode == 200) {
        print('PUT 요청 성공: ${response.body}');
        _commentController.clear(); // 댓글 전송 후 입력란 초기화
        widget.onCommentUpdated(); // 댓글 수정 후 부모에게 알림
      } else {
        print('PUT 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('댓글 수정 요청 중 오류 발생: $e');
    }
  }

  Future<void> _commentUpdateDialog(BuildContext context) async {
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
                    '댓글 수정시 깃털이 한개 차감됩니다.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '댓글을 수정하시겠습니까?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _sendUpdateRequest(widget.comment.id);
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
                              setState(() {
                                isEditing = !isEditing; // 수정 모드 토글
                              });
                            },
                            child: Text(isEditing ? '취소' : '수정'),
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
                isEditing
                    ? Column(
                        children: [
                          TextField(
                            controller: _commentController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await _sendUpdateRequest(widget.comment.id);
                            },
                            child: Text('수정 완료'),
                          ),
                        ],
                      )
                    : ExpandableText(text: widget.comment.content),
                // Container(
                //     child: ExpandableText(
                //   text: widget.comment.content,
                // )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
