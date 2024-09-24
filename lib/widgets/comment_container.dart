import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:today_cute/models/comment.dart';
import '../utils/expandable_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

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
  bool isEditing = false;
  late TextEditingController _commentController;
  bool isUpdating = false; // 업데이트 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.comment.content);
  }

  @override
  void didUpdateWidget(covariant CommentContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comment.content != widget.comment.content) {
      _commentController.text = widget.comment.content;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendUpdateRequest(String commentId) async {
    setState(() {
      isUpdating = true;
    });

    // SharedPreferences에서 accessToken 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final commentText = _commentController.text.trim();

    print("댓글 수정 요청 시작 내용:$commentText");
    // 만약 accessToken이 없다면, 예외 처리
    if (accessToken == null) {
      print('Access token이 없습니다.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 정보가 없습니다.')),
      );
      setState(() {
        isUpdating = false;
      });
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
        // 댓글 수정 성공 시, 편집 모드 종료 및 부모에게 알림
        setState(() {
          isEditing = false;
        });
        widget.onCommentUpdated(); // 댓글 수정 후 부모에게 알림
        Flushbar(
          message: '댓글이 성공적으로 수정되었습니다.',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
        )..show(context);
      } else if (response.statusCode == 400) {
        print('PUT 요청 실패: ${response.statusCode}');
        Flushbar(
          message: '사용 가능한 깃털이 없습니다. 수정이 취소됩니다.',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
        )..show(context);
        setState(() {
          isEditing = false;
        });
        // 추가적인 에러 처리 (예: 깃털이 0개일 경우 에러 메시지 출력)
      } else {
        print('PUT 요청 실패: ${response.statusCode}');
        Flushbar(
          message: '댓글 수정에 실패했습니다.',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
        )..show(context);
        setState(() {
          isEditing = false;
        });
      }
    } catch (e) {
      print('댓글 수정 요청 중 오류 발생: $e');
      Flushbar(
        message: '오류가 발생했습니다. 다시 시도해주세요.',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.black,
      )..show(context);
    } finally {
      setState(() {
        isUpdating = false;
      });
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
                          setState(() {
                            isEditing = !isEditing; // 수정 모드 토글
                          });

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
              'assets/cat.png', // TODO: 댓글 사용자로 이미지 받아오기
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _commentUpdateDialog(context);
                            },
                            child: Text(isEditing ? '' : '수정'),
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
                SizedBox(height: isEditing ? 0 : 10),
                isEditing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 22, // TextField 높이 조정
                              child: TextField(
                                controller: _commentController,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14, // 원하는 폰트 크기로 조정
                                ),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 2, bottom: 17),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey, // 언더라인 색상 설정
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          isUpdating
                              ? SizedBox(
                                  width: 28,
                                  height: 28,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    await _sendUpdateRequest(widget.comment.id);
                                  },
                                  child: Icon(
                                    Icons.send,
                                    size: 16,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(), // 버튼을 원형으로 만듦
                                    minimumSize: Size(28, 28),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                        ],
                      )
                    : ExpandableText(text: widget.comment.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
