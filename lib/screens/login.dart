import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'; // UserApi를 위한 임포트 추가
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _loginWithKakao() async {
    // 카카오 로그인 구현 예제

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

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
          offset: Offset(0, -60),
          child: Align(
            alignment: Alignment.center, // 가로 중앙 정렬
            child: Image.asset(
              'assets/logo_color.png',
              width: 250,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, 30),
          child: Align(
            child: Material(
              child: InkWell(
                onTap: () {
                  // 버튼이 눌렸을 때 수행할 작업
                  _loginWithKakao();
                },
                child: Image.asset(
                  'assets/kakao_login_large_wide.png', // 이미지 경로
                  width: 360, // 이미지 너비
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, 80),
          child: Align(
              child: Text(
            'Copyright 2024. 리브앤퀘스트 Co. All rights reserved.',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          )),
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
