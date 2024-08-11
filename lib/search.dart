import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0XFFFFFFFDE),
        child: Column(
          children: [
            InputField(),
            ChartBoard(),
          ],
        ));
  }
}

class InputField extends StatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFFFFFFFDE),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (text) {
              setState(() {
                query = text;
              });
            },
            decoration: InputDecoration(
              hintText: '태그 또는 제목 검색',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  'assets/search.png',
                  width: 40,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Search query: $query'), //추후에 삭제 필요
        ],
      ),
    );
  }
}

class ChartBoard extends StatefulWidget {
  const ChartBoard({super.key});

  @override
  _ChartBoardState createState() => _ChartBoardState();
}

class _ChartBoardState extends State<ChartBoard>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  late final Animation<Offset> _scrollAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );

    _scrollAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(1, 0),
    ).animate(_animationController)
      ..addListener(() {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent *
            _scrollAnimation.value.dx);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 250,
        margin: EdgeInsets.fromLTRB(15, 30, 15, 20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Color(0XFFFFFFFDE),
                ),
                Container(
                  width: double.infinity,
                  height: 230,
                  padding: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색 설정
                    borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 설정
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '실시간 인기순위',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            '2024년 10월 20일 14:00 기준',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '1',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          SizedBox(
                            width: 200,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    'This is a very long title that should scroll automatically if it exceeds the width of the screen.',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.favorite_border,
                            size: 15,
                          ),
                          Text(
                            '3,098',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/character_color.png',
                    width: 150,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
