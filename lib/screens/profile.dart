import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'setting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';
import '../services/api_service.dart';
import '../widgets/post_container.dart';
import '../utils/token_utils.dart';
import 'post_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_edit_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;
  List<Post> upload_posts = [];
  List<Post> liked_posts = [];

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
  String? profile_image_url = '';

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
        profile_image_url = decodedInfo['profile_image_url'];
      } else {
        nick_name = '이름 없음';
        email = '이메일 없음';
        profile_image_url = null;
      }

      print('내 닉네임: $nick_name');
      print('내 이메일: $email');
      print('내 프사: $profile_image_url');
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

      liked_posts =
          postList.where((post) => post.likedUsersId.contains(myId)).toList();
      // print('upload_posts: $upload_posts');
      liked_posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _posts[1] = liked_posts; // 두 번째 탭의 포스팅 목록 업데이트
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

  File? _profileImage;
  bool _isUploading = false; // 업로드 상태 관리

  final ImagePicker _picker = ImagePicker();

  // 이미지 선택 함수
  Future<void> _pickImage(BuildContext context) async {
    try {
      // 갤러리에서 이미지 선택
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // 이미지 크롭 (원형으로)
        File? croppedFile = await _cropImage(pickedFile.path);
        if (croppedFile != null) {
          setState(() {
            _profileImage = croppedFile;
          });

          // 이미지 업로드
          await _uploadImage(croppedFile, context);
        }
      }
    } catch (e) {
      print("이미지 선택 오류: $e");
      // 에러 처리 (예: 사용자에게 알림)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다.')),
      );
    }
  }

  // 이미지 크롭 함수
  Future<File?> _cropImage(String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '이미지 크롭',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '이미지 크롭',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  // 이미지 업로드 함수
  Future<void> _uploadImage(File imageFile, BuildContext context) async {
    setState(() {
      _isUploading = true;
    });

    // 서버 업로드 함수 호출
    await uploadProfileImage(imageFile, context);

    if (mounted) {
      setState(() {
        _isUploading = false;
      });
    }

    if (mounted) {
      await fetchMyInfo();
    }
  }

  // 서버에 이미지 업로드 함수
  Future<void> uploadProfileImage(File imageFile, BuildContext context) async {
    // 서버 엔드포인트 URL (실제 URL로 변경 필요)
    final String uploadUrl =
        'http://52.231.106.232:8000/api/user/profile_image';

    try {
      // HTTP 요청을 위한 MultipartRequest 생성
      var request = http.MultipartRequest('PUT', Uri.parse(uploadUrl));

      // SharedPreferences에서 accessToken 가져오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      request.headers['Authorization'] = 'Bearer $accessToken';

      // 파일을 MultipartFile로 변환
      final mimeTypeData = lookupMimeType(imageFile.path);
      if (mimeTypeData != null) {
        final mimeType = mimeTypeData.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // 서버에서 기대하는 필드명
            imageFile.path,
            filename: basename(imageFile.path),
            contentType: MediaType(mimeType[0], mimeType[1]), // MIME 타입 설정
          ),
        );
      }
      print(imageFile.path);
      // 요청 전송
      var response = await request.send();

      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 이미지가 성공적으로 업로드되었습니다.')),
        );
      } else {
        print('이미지 업로드 실패: ${response.statusCode}');
        print('이미지 업로드 실패: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 이미지 업로드에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('이미지 업로드 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 업로드 중 오류가 발생했습니다.')),
      );
    }
  }

  // 기본 이미지로 설정 함수
  Future<void> _resetImage(BuildContext context) async {
    setState(() {
      _isUploading = true;
    });

    // 서버 업로드 함수 호출
    await resetProfileImage(context);

    if (mounted) {
      setState(() {
        _isUploading = false;
      });
    }

    if (mounted) {
      await fetchMyInfo();
    }
  }

  // 서버에 이미지 업로드 함수
  Future<void> resetProfileImage(BuildContext context) async {
    // 서버 엔드포인트 URL
    final String uploadUrl =
        'http://52.231.106.232:8000/api/user/profile_image';

    try {
      // HTTP 요청을 위한 MultipartRequest 생성
      var request = http.MultipartRequest('PUT', Uri.parse(uploadUrl));

      // SharedPreferences에서 accessToken 가져오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Asset에서 이미지 파일 읽기
      ByteData byteData =
          await rootBundle.load('assets/profile.png'); // 실제 Asset 경로
      List<int> imageData = byteData.buffer.asUint8List();

      // MIME 타입 추출
      final mimeTypeData = lookupMimeType('assets/profile.png') ?? 'image/png';

      // 바이트 데이터를 MultipartFile로 변환 (contentType 생략)
      request.files.add(
        http.MultipartFile.fromBytes(
          'file', // 서버에서 기대하는 필드명
          imageData,
          filename: basename('assets/profile.png'), // 파일 이름 설정
          contentType: null, // contentType 생략
        ),
      );

      // 요청 전송
      var response = await request.send();

      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 이미지가 성공적으로 업로드되었습니다.')),
        );
      } else {
        print('이미지 업로드 실패: ${response.statusCode}');
        print('이미지 업로드 실패: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 이미지 업로드에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('이미지 업로드 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 업로드 중 오류가 발생했습니다.')),
      );
    }
  }

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
                          GestureDetector(
                            onTap: () {
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
                                            title: Text('프로필 사진 수정'),
                                            onTap: () async {
                                              await _pickImage(context);
                                              Navigator.of(context)
                                                  .pop(); // 팝업 닫기
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('기본 이미지로 설정'),
                                            onTap: () async {
                                              await _resetImage(context);
                                              Navigator.of(context)
                                                  .pop(); // 팝업 닫기
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white, // 테두리 배경 색상
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Colors.grey, // 원하는 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  'http://52.231.106.232:8000$profile_image_url',
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                              return PostDetailPage(
                                post: post,
                                myId: myId,
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
