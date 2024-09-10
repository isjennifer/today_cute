import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'; // UserApi를 위한 임포트 추가
import 'package:flutter/services.dart';
import 'package:today_cute/widgets/comment_drawer.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _loginWithKakao(BuildContext context) async {
    // 카카오 로그인 구현 예제

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
        await _saveTokenAndNavigate(context, token.accessToken);
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
          await _saveTokenAndNavigate(context, token.accessToken);
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _saveTokenAndNavigate(context, token.accessToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        print(await KakaoSdk.origin);
      }
    }
  }

  // 토큰 저장 후 메인 페이지로 이동
  Future<void> _saveTokenAndNavigate(
      BuildContext context, String kakaoToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // 서버에 토큰 전송 후 엑세스 토큰 받아 저장
      final response = await http.post(
        // Uri.parse('http://10.0.2.2:8000/api/auth/login/kakao'),
        Uri.parse('http://52.231.106.232:8000/api/auth/login/kakao'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'access_token': kakaoToken,
        }),
      );

      // 서버 응답이 성공시
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print('accessToken: ${responseBody['access_token']}');

        await prefs.setString('accessToken', responseBody['access_token']);

        // 로그인 성공 후 메인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageFrame()),
        );
      } else if (response.statusCode == 404) {
        // 비회원의 경우
        _register(context, kakaoToken);
      } else {
        // 서버 응답이 실패 시 응답 본문을 출력
        var responseBody = jsonDecode(response.body);
        print('Failed to authenticate: ${responseBody['detail']}');
        throw Exception(
            '서버에서 로그인 실패. Status code: ${response.statusCode}, Message: ${responseBody['detail']}');
      }
    } catch (error) {
      print('서버로그인 요청 실패 $error');
    }
  }

  // 로그인 시도시 404응답을 받을 경우 회원가입
  Future<void> _register(BuildContext context, String kakaoToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 사용자에게서 받은 닉네임
    // TODO: 이곳에 닉네임을 받을 수 있도록 회원가입 페이지 등을 통해 받아와 주세요
    String nikname = "";

    try {
      // 서버에 토큰 전송 후 엑세스 토큰 받아 저장
      final response = await http.post(
        // Uri.parse('http://10.0.2.2:8000/api/auth/register'),
        Uri.parse('http://52.231.106.232:8000/api/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'access_token': kakaoToken,
          'nick_name': nikname,
        }),
      );

      // 서버 응답이 성공시
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print('access_token: ${responseBody['access_token']}');

        await prefs.setString('accessToken', responseBody['access_token']);

        // 로그인 성공 후 메인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageFrame()),
        );
      } else {
        // 서버 응답이 실패 시 응답 본문을 출력
        var responseBody = jsonDecode(response.body);
        print('Failed to authenticate: ${responseBody['detail']}');
        throw Exception(
            '서버에서 로그인 실패. Status code: ${response.statusCode}, Message: ${responseBody['detail']}');
      }
    } catch (error) {
      print('서버로그인 요청 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width;
    final double maxHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          OverflowBox(
            alignment: Alignment(0, -1.2),
            maxWidth: double.maxFinite,
            child: Image.asset(
              'assets/character_color_big.png',
              width: maxWidth + 200,
              fit: BoxFit.cover,
            ),
          ),
          OverflowBox(
            alignment: Alignment(0, -1.0),
            maxWidth: double.maxFinite,
            child: Image.asset(
              'assets/character_color_big.png',
              width: maxWidth + 200,
              fit: BoxFit.cover,
            ),
          ),
          OverflowBox(
            alignment: Alignment(0, -0.8),
            maxWidth: double.maxFinite,
            child: Image.asset(
              'assets/character_color_big.png',
              width: maxWidth + 200,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment(0, -0.12), // 가로 중앙 정렬
            child: Image.asset(
              'assets/logo_color.png',
              width: 250,
            ),
          ),
          Align(
            alignment: Alignment(0, 0.09),
            child: Material(
              child: InkWell(
                onTap: () {
                  // 버튼이 눌렸을 때 수행할 작업
                  _loginWithKakao(context);
                },
                child: Image.asset(
                  'assets/kakao_login_large_wide.png', // 이미지 경로
                  width: 360, // 이미지 너비
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment(0, 0.2),
              child: Text(
                'Copyright 2024. 리브앤퀘스트 Co. All rights reserved.',
                style:
                    GoogleFonts.ibmPlexSansKr(fontSize: 10, color: Colors.grey),
              )),
          OverflowBox(
            alignment: Alignment(0, 0.8),
            maxWidth: double.maxFinite,
            child: Image.asset(
              'assets/character_color_big.png',
              width: maxWidth + 200,
              fit: BoxFit.cover,
            ),
          ),
          OverflowBox(
            alignment: Alignment(0, 1),
            maxWidth: double.maxFinite,
            child: Image.asset(
              'assets/character_color_big.png',
              width: maxWidth + 200,
              fit: BoxFit.cover,
            ),
          ),
          OverflowBox(
            alignment: Alignment(0, 1.2),
            maxWidth: double.maxFinite,
            child: Image.asset(
              'assets/character_color_big.png',
              width: maxWidth + 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
