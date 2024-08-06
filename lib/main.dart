import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // IBM Plex Sans KR 폰트를 전역적으로 설정
          textTheme: GoogleFonts.ibmPlexSansKrTextTheme(
            Theme.of(context).textTheme, // 기존 테마를 바탕으로 폰트 적용
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Image.asset(
                'assets/logo_color.png',
                width: 150,
              ) // title: Text(
              //   '오늘의 귀여움',
              //   style: GoogleFonts.jua(
              //       color: Color.fromARGB(255, 94, 68, 45),
              //       fontWeight: FontWeight.w500,
              //       fontSize: 25),
              // ),
              ),
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
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/home.png',
                  width: 50,
                ),
                Image.asset(
                  'assets/search.png',
                  width: 50,
                ),
                Image.asset(
                  'assets/upload.png',
                  width: 50,
                ),
                Image.asset(
                  'assets/alarm.png',
                  width: 50,
                ),
                Image.asset(
                  'assets/profile.png',
                  width: 50,
                ),
              ],
            ),
          ),
        ));
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 550,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '우리집 강아지 자랑좀 할게여',
                      style: TextStyle(
                        fontSize: 18, // 텍스트 크기 설정
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: double.infinity,
                    height: 340,
                    child: ClipRect(
                      child: Image.asset(
                        'assets/dog.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 5, right: 20, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '2024년 8월 20일',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8,
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
                                horizontal: 8,
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
                                horizontal: 8,
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
