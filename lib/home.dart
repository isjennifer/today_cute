import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0XFFFFFFFDE),
        child: ListView(
          children: [
            HomeBody(),
            HomeBody(),
            HomeBody(),
            HomeBody(),
            HomeBody(),
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 530,
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Color(0XFFFFFFFDE),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '우리집 강아지 자랑좀 할게여라라라라라라ㅏ라랄라ㅏㄹㄹㄹ',
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: double.infinity,
                  height: 340,
                  child: ClipRect(
                    child: Image.asset(
                      'assets/dog.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
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
                          SizedBox(width: 8), // 아이콘 사이에 간격 추가 (선택 사항)
                          Icon(Icons.bookmark_border),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 25, top: 5, right: 25, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '2024년 10월 20일',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        width: 250,
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
                                  '#강아지',
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
                                  '#강아지',
                                  style: TextStyle(
                                    color: Colors.black, // 텍스트 색상을 흰색으로 설정
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
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
          ],
        ));
  }
}
