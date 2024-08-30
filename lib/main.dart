import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:today_cute/alarm.dart';
import 'package:today_cute/upload.dart';
import 'home.dart';
import 'search.dart';
import 'login.dart';
import 'upload.dart';
import 'alarm.dart';
import 'profile.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'dart:async';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'c1798f129d4667f86161e6c3916a5d3b',
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
      // 3초 후에 PageFrame으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PageFrame()),
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
      if (index == 3) { // AlarmPage에 들어가면
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/logo_color.png',
            width: 150,
          )),
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
            label: 'alarm', // TODO: _hasNewNotification이 true인 경우 알람 이미지 위에 빨간점? 같은 걸로 표시해야함 
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
