import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _logoutDialog(BuildContext context) async {
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
                    '로그아웃 하시겠습니까?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          logout(context); // 모달 창 닫기
                        },
                        child: Text('로그아웃'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  '닉네임 수정',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5, color: Colors.grey), // 가로선 추가
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  _logoutDialog(context);
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5, color: Colors.grey), // 가로선 추가
        ],
      ),
    );
  }
}
