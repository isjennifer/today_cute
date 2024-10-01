import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmPage extends StatefulWidget {
  final VoidCallback onNewNotification;

  const AlarmPage({super.key, required this.onNewNotification});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<AlarmBoard> _alarms = [];
  bool _hasNewNotification = false; // 새로운 알림이 있는지 여부

  @override
  void initState() {
    super.initState();
  }

  void _clearAllNotifications() {
    setState(() {
      _alarms.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.maxFinite,
      color: Color(0XFFFFFFFDE),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: _clearAllNotifications,
                    icon: Icon(Icons.cancel, size: 18),
                    label: Text('전체 알림 지우기'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 107, 107, 107),
                      backgroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      textStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            // 현재 리스트에 있는 알림들을 화면에 출력
            ..._alarms,
          ],
        ),
      ),
    );
  }
}

class AlarmBoard extends StatelessWidget {
  const AlarmBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 그림자 색상
            spreadRadius: 1, // 그림자 퍼짐 반경
            blurRadius: 10, // 그림자 흐림 정도
            offset: Offset(0, 5), // 그림자 위치 (x축, y축)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/dog.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  Icon(Icons.person),
                  Text('귀여운게 최고야 님이'),
                ]),
                Row(children: [
                  Text('회원님의 게시물을 '),
                  Icon(
                    Icons.favorite,
                    size: 17,
                    color: Colors.pink,
                  ),
                  Text('좋아합니다.'),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
