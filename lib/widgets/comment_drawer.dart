import 'package:flutter/material.dart';
import '../utils/expandable_text.dart';

class CommentDrawer extends StatelessWidget {
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
                        onPressed: () {
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
            child: ListView(
              children: [
                Comment(),
                Comment(),
                Comment(),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextField(
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

class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool isExpanded = false;

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
              'assets/cat.png',
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
                        '아이디',
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
                        text:
                            '이것은 아주아주 긴 댓글입니다라라라라ㅏㄹ라ㅏ랄ㄹㄹㄹdwefwefwe두줄이넘어가면 더보기 접기가 생성된답니다라라라라ㅏ라라라')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
