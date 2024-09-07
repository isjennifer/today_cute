import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:today_cute/screens/alarm.dart';
import 'package:today_cute/screens/upload.dart';
import 'screens/home.dart';
import 'screens/search.dart';
import 'screens/profile.dart';
import 'screens/login.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'fa34c75614ac318d63f7b6cd77ec9dfb',
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FCM 토큰 초기화 및 서버에 전송
  await _initializeFCM();

  // 백그라운드 알림 처리 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> _initializeFCM() async {
  try {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await _sendTokenToServer(fcmToken);
    }
    print(fcmToken);
  } catch (exp) {
    print("FcmToken을 서버에 전송하던 중 예외 발생 $exp");
  }

  // 토큰이 갱신될 때 서버에 새 토큰 전송
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    if (newToken != null) {
      await _sendTokenToServer(newToken);
    }
  });
}

Future<void> _sendTokenToServer(String token) async {
  // TODO: 여기서 토큰을 서버에 전송하는 코드를 작성해야 합니다.
  // 예를 들어, HTTP POST 요청으로 서버에 토큰을 전달합니다.
  print("토큰을 서버에 전송 중: $token");
}

// MyApp 시작 부분

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘의 귀여움',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.ibmPlexSansKrTextTheme(
          Theme.of(context).textTheme, // 기존 테마를 바탕으로 폰트 적용
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      // 3초 후에 AuthCheck으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthCheck()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo_char_color.png',
          width: 220,
        ), // 로고 이미지 경로를 설정
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    // 토큰이 있으면 로그인 상태, 없으면 비로그인 상태
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return PageFrame(); // 로그인 상태
        } else {
          return LoginPage(); // 비로그인 상태
        }
      },
    );
  }
}

class PageFrame extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PageFrame> {
  int _selectedIndex = 0;
  bool _hasNewNotification = false; // 새로운 알림이 있는지 여부

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    UploadPage(),
    AlarmPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        // AlarmPage에 들어가면
        _hasNewNotification = false; // 알림 아이콘 상태 초기화
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // 포그라운드 알림 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _hasNewNotification = true; // 새로운 알림이 도착함
      });

      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> _howToUseFeatherModal(BuildContext context) async {
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
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q. 깃털은 어떻게 얻나요?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('A. 깃털을 얻는 방법은 3가지가 있어요.'),
                  Text('첫번째, 출석체크를 하면 깃털 1개를 얻을 수 있어요.'),
                  Text('두번째, 광고시청을 하면 깃털 1개를 얻을 수 있어요.'),
                  Text('세번째, 게시물을 작성하면 깃털 1개를 얻을 수 있어요.'),
                  SizedBox(height: 20),
                  Text('Q. 깃털은 어디에 사용하나요?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('A. 댓글을 작성하거나, 수정하거나, 삭제할 때마다 1개씩 사용해요.'),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 모달 창 닫기
                      },
                      child: Text('이해했어요!'),
                    ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/logo_color.png',
          width: 150,
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Image.asset(
              'assets/feather.png',
              width: 40,
            ),
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _howToUseFeatherModal(context);
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/feather.png',
                                width: 50,
                              ),
                              Text(
                                '20',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.check),
                                label: Text('출석체크')),
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.video_camera_back),
                                label: Text('광고시청')),
                          ],
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.png',
              width: 50,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/search.png',
              width: 50,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/upload.png',
              width: 50,
            ),
            label: 'upload',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/alarm.png',
              width: 50,
            ),
            label:
                'alarm', // TODO: _hasNewNotification이 true인 경우 알람 이미지 위에 빨간점? 같은 걸로 표시해야함
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/profile.png',
              width: 50,
            ),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        showSelectedLabels: false, // 선택된 아이템의 라벨 숨기기
        showUnselectedLabels: false, // 선택되지 않은 아이템의 라벨 숨기기
      ),
    );
  }
}
