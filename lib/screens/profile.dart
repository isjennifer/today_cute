import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setting.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;

// 각 탭에 대응하는 이미지 목록
  final List<List<String>> _images = [
    [], // 업로드한 게시물 이미지 리스트
    [], // 좋아한 게시물 이미지 리스트
  ];

  int _loadedItemCount = 0;
  final ScrollController _scrollController = ScrollController();
  bool _hasMoreData = true; // 더 불러올 데이터가 있는지 여부

  @override
  void initState() {
    super.initState();
    _initializeImages(); // 초기 이미지를 로드합니다.

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_hasMoreData) {
          _loadMoreItems();
        }
      }
    });
  }

// 초기 이미지를 로드하는 함수 (서버에서 10개 이미지를 가져오는 시뮬레이션)
  void _initializeImages() {
    setState(() {
      // 여기서 서버에서 이미지를 불러오는 API 호출을 시뮬레이션합니다.
      List<String> initialImages = [
        'assets/uploaded_1.png',
        'assets/uploaded_2.png',
        'assets/uploaded_3.png',
        'assets/uploaded_4.png',
        'assets/uploaded_5.png',
        'assets/uploaded_6.png',
        'assets/uploaded_7.png',
        'assets/uploaded_8.png',
        'assets/uploaded_9.png',
        'assets/uploaded_10.png',
      ];

      _images[_selectedTab].addAll(initialImages);

      if (_images[_selectedTab].length >= 10) {
        _hasMoreData = false; // 불러올 데이터가 더 이상 없음
      }

      _loadedItemCount = _images[_selectedTab].length;
    });
  }

// 추가 이미지를 로드하는 함수
  void _loadMoreItems() {
    setState(() {
      int startIndex = _loadedItemCount + 1;
      int endIndex = startIndex + 5;

      // 서버에서 불러올 수 있는 최대 이미지 개수가 10개인 경우
      if (endIndex > 10) {
        endIndex = 10;
        _hasMoreData = false; // 더 이상 불러올 데이터가 없음을 표시
      }

      for (int i = startIndex; i <= endIndex; i++) {
        _images[_selectedTab].add('assets/uploaded_$i.png');
      }

      _loadedItemCount += (endIndex - startIndex + 1);

      // 만약 모든 데이터를 로드했다면, 더 이상 로드하지 않음
      if (_loadedItemCount >= 10) {
        _hasMoreData = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              height: 550,
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0, 0),
                    child: OverflowBox(
                      alignment: Alignment.topRight,
                      maxWidth: double.infinity,
                      child: Container(
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingPage()),
                                );
                              },
                              icon: Icon(
                                Icons.settings,
                                color: Colors.grey,
                                size: 30,
                              )),
                        ]),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 160),
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      maxWidth: double.infinity,
                      child: Container(
                        width: 600,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color(0XFF99FFCC),
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(500, 300),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 60),
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      maxWidth: double.infinity,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/dog.jpg',
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            '임현주',
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            'hyeonjoo@naver.com',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 340),
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      maxWidth: double.infinity,
                      child: Image.asset(
                        'assets/character_color_big.png',
                        width: 650,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth / 2 - 1,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedTab = 0;
                                });
                              },
                              child: _selectedTab == 0
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.collections),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '내 게시물',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    )
                                  : Icon(
                                      Icons.collections,
                                      color: Colors.grey,
                                    )),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey, // 가로선 색상
                        ),
                        Container(
                          width: screenWidth / 2,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedTab = 1;
                                });
                              },
                              child: _selectedTab == 1
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.favorite),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('좋아한 게시물',
                                            style: TextStyle(fontSize: 18))
                                      ],
                                    )
                                  : Icon(
                                      Icons.favorite,
                                      color: Colors.grey,
                                    )),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: _loadedItemCount,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_images[_selectedTab][index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  if (_loadedItemCount < _images[_selectedTab].length)
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (_loadedItemCount == 0) Text('로드할데이터없음')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
