import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0, -200),
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
        Transform.translate(
          offset: Offset(0, -100),
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
        Transform.translate(
          offset: Offset(0, 0),
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
        Transform.translate(
          offset: Offset(0, -90),
          child: Align(
            alignment: Alignment.center, // 가로 중앙 정렬
            child: Image.asset(
              'assets/logo_color.png',
              width: 250,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, -10),
          child: Align(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 100, vertical: 20), // 텍스트 주변의 패딩을 추가하여 공간 확보
              decoration: BoxDecoration(
                color: Colors.green, // 배경색 설정
                borderRadius: BorderRadius.circular(40), // 모서리를 둥글게 설정
              ),
              child: Text(
                '네이버 로그인',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // 텍스트 색상을 흰색으로 설정
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, 70),
          child: Align(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 100, vertical: 20), // 텍스트 주변의 패딩을 추가하여 공간 확보
              decoration: BoxDecoration(
                color: Colors.yellow, // 배경색 설정
                borderRadius: BorderRadius.circular(40), // 모서리를 둥글게 설정
              ),
              child: Text(
                '카카오 로그인',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black, // 텍스트 색상을 흰색으로 설정
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, 450),
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
        Transform.translate(
          offset: Offset(0, 550),
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
        Transform.translate(
          offset: Offset(0, 650),
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
    );
  }
}
