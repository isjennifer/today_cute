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

void main() {
  runApp(const MyApp());
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
      home: PageFrame(),
    );
  }
}

class PageFrame extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PageFrame> {
  int _selectedIndex = 0;

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
            label: 'alarm',
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
