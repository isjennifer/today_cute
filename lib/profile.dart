import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1000, // 전체 높이를 지정합니다. 필요에 따라 조정하세요.
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(0, 160),
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  maxWidth: double.infinity,
                  child: Container(
                    width: 600,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color(0XFF99FFCC),
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(500, 300),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 60),
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  maxWidth: double.infinity,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/dog.jpg',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '임현주',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        'hyeonjoo@naver.com',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 340),
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
              Positioned(
                top: 600,
                left: 0,
                right: 0,
                child: Container(
                    width: double.infinity,
                    height: 1500,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '업로드한 게시물',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                '전체보기',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                          ),
                          itemCount: 6, // 2x3 그리드이므로 총 6개의 아이템
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/dog.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
