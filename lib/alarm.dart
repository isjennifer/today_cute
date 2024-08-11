import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Color(0XFFFFFFFDE),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 18,
                  ),
                  Text(
                    '전체 알림 지우기',
                  ),
                ],
              ),
            ),
            AlarmBoard(),
            AlarmBoard(),
          ],
        ));
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Icon(Icons.person),
                Text('귀여운게 최고야 님이'),
              ]),
              Row(children: [
                Text('당신의 게시물을 '),
                Icon(
                  Icons.favorite,
                  size: 17,
                  color: Colors.pink,
                ),
                Text('좋아합니다.'),
              ]),
            ],
          ),
          Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
