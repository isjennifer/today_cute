import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../models/post.dart';
import '../services/api_service.dart';
import '../widgets/post_container.dart';
import '../widgets/post_container.dart';
import '../utils/token_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;
  List<Post> upload_posts = [];

// 각 탭에 대응하는 포스팅 목록
  final List<List<Post>> _posts = [
    [], // 업로드한 게시물 이미지 리스트
    [], // 좋아한 게시물 이미지 리스트
  ];

  int _loadedItemCount = 0;
  final ScrollController _scrollController = ScrollController();
  bool _hasMoreData = true; // 더 불러올 데이터가 있는지 여부
  String myId = '';
  String nick_name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _initializePreferences();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     if (_hasMoreData) {
    //       _loadMoreItems();
    //     }
    //   }
    // });
  }

  Future<void> _initializePreferences() async {
    myId = await getUserIdFromToken();
    setState(() {
      // 토큰의 정보 출력
      print('profile.dart-Decoded Token: $myId');
      // getTokenExpiryDate(token) 호출 필요 없음
    });
    await fetchMyInfo();
  }

  Future<void> fetchMyInfo() async {
    // print('profile.dart-fetchMyInfo전: $myId');
    final decodedInfo = await fetchId(myId);
    // print('profile.dart-fetchMyInfo후: $myId');

    setState(() {
      // 사용자 정보를 myInfo에 저장
      if (decodedInfo.isNotEmpty) {
        nick_name = decodedInfo['nick_name'];
        email = decodedInfo['email'];
      } else {
        nick_name = '이름 없음';
        email = '이메일 없음';
      }

      print('내 닉네임: $nick_name');
      print('내 이메일: $email');
    });
  }

// 내 게시물 로드
  Future<void> fetchPosts() async {
    final postList =
        await fetchPostData(); // api_service.dart의 fetchPostData 호출
    setState(() {
      upload_posts = postList.where((post) => post.userId == myId).toList();
      // print('upload_posts: $upload_posts');
      upload_posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // _posts 리스트를 업데이트
      _posts[0] = upload_posts; // 첫 번째 탭의 포스팅 목록 업데이트
    });
  }

// 추가 이미지를 로드하는 함수
  // void _loadMoreItems() {
  //   setState(() {
  //     int startIndex = _loadedItemCount + 1;
  //     int endIndex = startIndex + 5;

  //     // 서버에서 불러올 수 있는 최대 이미지 개수가 10개인 경우
  //     if (endIndex > 10) {
  //       endIndex = 10;
  //       _hasMoreData = false; // 더 이상 불러올 데이터가 없음을 표시
  //     }

  //     for (int i = startIndex; i <= endIndex; i++) {
  //       _images[_selectedTab].add('assets/uploaded_$i.png');
  //     }

  //     _loadedItemCount += (endIndex - startIndex + 1);

  //     // 만약 모든 데이터를 로드했다면, 더 이상 로드하지 않음
  //     if (_loadedItemCount >= 10) {
  //       _hasMoreData = false;
  //     }
  //   });
  // }

  Future<void> _deletePostDialog(BuildContext context, String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

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
                    '게시물을 삭제하시겠습니까?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          await deletePostData(
                              context, postId, accessToken); // 게시물 삭제
                          await fetchPosts();
                        },
                        child: Text('삭제'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 모달 창 닫기
                        },
                        child: Text('취소'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    List<Post> currentPosts = _posts[_selectedTab];

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
                            nick_name,
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            email,
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
                    itemCount: currentPosts.length,
                    itemBuilder: (context, index) {
                      final post = currentPosts[index];
                      final file = post.files;
                      final fileUrls = file.map((file) => file['url']).toList();

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                    title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '내 게시물',
                                        textAlign:
                                            TextAlign.center, // 텍스트를 가운데 정렬
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: Icon(Icons.edit),
                                                    title: Text('수정'),
                                                    onTap: () async {
                                                      // 수정 기능 구현
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PostEditPage(
                                                                    post:
                                                                        post), // 수정할 post 전달
                                                          ));
                                                      Navigator.of(context)
                                                          .pop(); // 팝업 닫기
                                                      await fetchPosts();
                                                      Navigator.of(context)
                                                          .pop(); // 삭제 후 이전 화면으로 돌아가기
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: Icon(Icons.delete),
                                                    title: Text('삭제'),
                                                    onTap: () async {
                                                      // 삭제 기능 구현
                                                      await _deletePostDialog(
                                                          context, post.id);
                                                      Navigator.of(context)
                                                          .pop(); // 팝업 닫기

                                                      Navigator.of(context)
                                                          .pop(); // 삭제 후 이전 화면으로 돌아가기
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.more_vert),
                                    ),
                                  ],
                                )),
                                body: SingleChildScrollView(
                                  child: Container(
                                    color: Color(0XFFFFFFFDE),
                                    child: PostContainer(
                                      post: post,
                                      // onDelete: () {} // 삭제 콜백 함수 없음
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'http://52.231.106.232:8000${fileUrls[0]}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // if (_loadedItemCount < _images[_selectedTab].length)
                  //   Padding(
                  //     padding: EdgeInsets.all(16.0),
                  //     child: CircularProgressIndicator(),
                  //   ),
                  // if (_loadedItemCount == 0) Text('로드할데이터없음')
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
