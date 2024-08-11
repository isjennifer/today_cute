import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Image.asset(
            'assets/logo_char_color.png',
            width: 250,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(
                horizontal: 100, vertical: 20), // 텍스트 주변의 패딩을 추가하여 공간 확보
            decoration: BoxDecoration(
              color: Colors.green, // 배경색 설정
              borderRadius: BorderRadius.circular(40), // 모서리를 둥글게 설정
            ),
            child: Text(
              '네이버 로그인',
              style: TextStyle(
                fontSize: 23,
                color: Colors.white, // 텍스트 색상을 흰색으로 설정
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 100, vertical: 20), // 텍스트 주변의 패딩을 추가하여 공간 확보
            decoration: BoxDecoration(
              color: Colors.yellow, // 배경색 설정
              borderRadius: BorderRadius.circular(40), // 모서리를 둥글게 설정
            ),
            child: Text(
              '카카오 로그인',
              style: TextStyle(
                fontSize: 23,
                color: Colors.black, // 텍스트 색상을 흰색으로 설정
              ),
            ),
          ),
        ],
      ),
    );
  }
}
