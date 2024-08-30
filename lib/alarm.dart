import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<AlarmBoard> _alarms = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    // 로컬 알림 초기화
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 주기적으로 알림을 추가하는 타이머 설정
    Timer.periodic(Duration(seconds: 5), (timer) {
      // 서버에서 알림이 도착한 것처럼 새로운 알람 추가
      setState(() {
        _alarms.add(AlarmBoard());
        _showNotification(); // 알람 추가 시 로컬 알림 표시
      });
    });
  }

  // 로컬 알림을 표시하는 함수
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      // 'your channel description' 제거
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      '새 알림',
      '새로운 알람이 도착했습니다.',
      platformChannelSpecifics,
      payload: 'item x',
    );
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
