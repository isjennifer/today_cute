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
  // 현재 선택된 탭을 저장할 변수
  int _selectedTab = 0;

  // 각 탭에 대응하는 이미지 목록
  final List<List<String>> _images = [
    List.generate(30, (index) => 'assets/uploaded_$index.png'), // 업로드한 게시물 이미지
    List.generate(30, (index) => 'assets/liked_$index.jpg'), // 좋아한 게시물 이미지
    List.generate(30, (index) => 'assets/saved_$index.jpg'), // 저장한 게시물 이미지
  ];

  // 현재 로드된 이미지 개수
  int _loadedItemCount = 9;

  // 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // 스크롤이 최하단에 도달했을 때 더 많은 아이템을 로드
        _loadMoreItems();
      }
    });
  }

  void _loadMoreItems() {
    setState(() {
      // 이미지를 9개씩 추가 로드
      if (_loadedItemCount + 9 <= _images[_selectedTab].length) {
        _loadedItemCount += 9;
      } else {
        _loadedItemCount = _images[_selectedTab].length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 700.0, // 최소 높이를 100으로 설정
          ),
          child: Container(
            height: double.maxFinite, // 전체 높이를 지정합니다. 필요에 따라 조정하세요.
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
                Positioned(
                  top: 550,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTab = 0; // 업로드한 게시물 탭 선택
                                      _loadedItemCount =
                                          9; // 탭 변경 시 초기 로드 아이템 수 리셋
                                    });
                                  },
                                  child: Icon(
                                    Icons.collections,
                                    color: _selectedTab == 0
                                        ? Colors.black
                                        : Colors.grey,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTab = 1; // 좋아한 게시물 탭 선택
                                      _loadedItemCount =
                                          9; // 탭 변경 시 초기 로드 아이템 수 리셋
                                    });
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: _selectedTab == 1
                                        ? Colors.black
                                        : Colors.grey,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTab = 2; // 저장한 게시물 탭 선택
                                      _loadedItemCount =
                                          9; // 탭 변경 시 초기 로드 아이템 수 리셋
                                    });
                                  },
                                  child: Icon(
                                    Icons.bookmark,
                                    color: _selectedTab == 2
                                        ? Colors.black
                                        : Colors.grey,
                                  )),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                          ),
                          itemCount: _loadedItemCount,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(_images[_selectedTab][index]),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
