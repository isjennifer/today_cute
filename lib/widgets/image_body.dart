import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/expandable_text.dart';
import 'comment_drawer.dart';

class ImageBody extends StatefulWidget {
  const ImageBody({super.key});

  @override
  _ImageBodyState createState() => _ImageBodyState();
}

class _ImageBodyState extends State<ImageBody> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '우리집 강쥐 기욥져? 정말정말ㄹ요 너무너무귀여워서 깨물어',
                        style: TextStyle(
                          fontSize: 18, // 텍스트 크기 설정
                        ),
                        overflow: TextOverflow.ellipsis, // 길어지면 ...으로 표시
                        maxLines: 1, // 한 줄로 제한
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(color: Colors.black),
                width: double.infinity,
                height: maxWidth,
                child: ClipRect(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Image.asset(
                        'assets/dog.jpg',
                        // fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/cat.png',
                        // fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: SmoothPageIndicator(
                  controller: _pageController, // PageView의 controller
                  count: 2, // 이미지 개수에 맞게 설정
                  effect: ExpandingDotsEffect(
                    dotHeight: 5.0,
                    dotWidth: 5.0,
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, top: 15, right: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격 추가 (선택 사항)
                        Text('아이디'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, top: 15, right: 25, bottom: 15),
                child: ExpandableText(
                  text:
                      '우리집 강아지 너무 귀엽지ddddd 않나요? 이 강아지는 저와 함께 산책도 하고 놀아주기도 하고 정말 즐거운 시간을 보내고 있어요. 너무 사랑스럽고 귀여워서 하루하루가 정말 행복해요. 강아지가 제 인생에 얼마나 큰 기쁨을 주는지 말로 표현할 수 없어요. 정말 너무너무 귀엽답니다!',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 가로로 스크롤 가능하게 설정
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                        decoration: BoxDecoration(
                          color: Color(0XFFFFF99CC), // 배경색 설정
                          borderRadius:
                              BorderRadius.circular(14), // 모서리를 둥글게 설정
                        ),
                        child: Text(
                          '#고양이',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상을 흰색으로 설정
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                        decoration: BoxDecoration(
                          color: Color(0XFFFFFFF66), // 배경색 설정
                          borderRadius:
                              BorderRadius.circular(14), // 모서리를 둥글게 설정
                        ),
                        child: Text(
                          '#귀욤짤',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상을 흰색으로 설정
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                        decoration: BoxDecoration(
                          color: Color(0XFFFCCFFFF), // 배경색 설정
                          borderRadius:
                              BorderRadius.circular(14), // 모서리를 둥글게 설정
                        ),
                        child: Text(
                          '#강아지지지지지',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상을 흰색으로 설정
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4), // 텍스트 주변의 패딩을 추가하여 공간 확보
                        decoration: BoxDecoration(
                          color: Color(0XFFFCCFFFF), // 배경색 설정
                          borderRadius:
                              BorderRadius.circular(14), // 모서리를 둥글게 설정
                        ),
                        child: Text(
                          '#강아지지지지지지지',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상을 흰색으로 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false, // 서랍이 화면의 대부분을 차지하게 함
                        builder: (BuildContext context) {
                          return CommentDrawer(); // CommentDrawer 위젯을 사용하여 서랍 표시
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 22,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text(
                          '가장 최근 댓글이 나타납니다. 너무 귀요워용 ㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜ',
                          overflow: TextOverflow.ellipsis, // 길어지면 ...으로 표시
                          maxLines: 1,
                        ))
                      ],
                    )),
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/character_color.png',
                  width: 150,
                ),
              ],
            ),
          ),
        ]));
  }
}
