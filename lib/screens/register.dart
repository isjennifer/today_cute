import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  final String kakaoToken;

  const RegisterPage({super.key, required this.kakaoToken});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    // 반드시 dispose에서 controller를 해제해야 함
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context, String kakaoToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String nickname = _nicknameController.text;

    if (nickname.isEmpty) {
      // 닉네임이 비어 있을 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("닉네임을 입력해주세요."),
      ));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://52.231.106.232:8000/api/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'access_token': kakaoToken,
          'nick_name': nickname,
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        await prefs.setString('accessToken', responseBody['access_token']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthCheck()),
        );
      } else {
        var responseBody = jsonDecode(response.body);

        print("로그인 실패: ${responseBody['detail']}");
      }
    } catch (error) {
      print("서버 요청 실패: $error");
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
            alignment: Alignment(0, -0.2), // 가로 중앙 정렬
            child: Image.asset(
              'assets/logo_color.png',
              width: 250,
            ),
          ),
          Align(
              alignment: Alignment(0, -0.02),
              child: Text(
                '사용하실 닉네임을 정해주세요!',
                style: GoogleFonts.ibmPlexSansKr(
                    fontSize: 18, color: Colors.black),
              )),
          Align(
              alignment: Alignment(0, 0.15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Material(
                      child: TextField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          hintText: "닉네임은 8자 이내여야 합니다.",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                        maxLength: 8,
                      ),
                    )),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _register(context, widget.kakaoToken);
                      },
                      child: Icon(Icons.arrow_forward),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // 버튼을 원형으로 만듦
                        padding: EdgeInsets.all(12.0), // 버튼 크기 조정
                      ),
                    ),
                  ],
                ),
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
