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

class _ChartBoardState extends State<ChartBoard> with TickerProviderStateMixin {
  late final List<ScrollController> _scrollControllers;
  late final List<AnimationController> _animationControllers;
  late final List<Animation<Offset>> _scrollAnimations;

  final List<String> titles = [
    '우리집 강아지 너무 귀엽지 않나요 세상사람들 여기와서 모두 보고 가세요',
    '북극 펭귄 뒤뚱뒤뚱 걷는게 너무 귀여움ㅜㅜㅜㅜ',
    '진짜 미쳤습니다 이거 안보면 손해ㅠㅠ',
    '갓 태어난 아기 귀요미ㅠㅠㅠㅠㅠㅠㅠㅠ',
    '강아지 고양이 모음집',
  ];

  final List<int> likes = [30990, 10000, 9999, 1478, 300]; // 좋아요 수

  @override
  void initState() {
    super.initState();

    // 리스트 초기화
    _scrollControllers = [];
    _animationControllers = [];
    _scrollAnimations = [];

    // 컨트롤러 초기화
    for (int i = 0; i < titles.length; i++) {
      _scrollControllers.add(ScrollController());
      _animationControllers.add(AnimationController(
        vsync: this,
        duration: Duration(seconds: 10),
      ));

      _scrollAnimations.add(Tween<Offset>(
        begin: Offset(0, 0), // 처음에는 0, 0으로 설정
        end: Offset(1, 0), // 이후로 오른쪽으로 스크롤
      ).animate(_animationControllers[i])
        ..addListener(() {
          if (mounted) {
            final index =
                _animationControllers.indexOf(_animationControllers[i]);
            if (_scrollControllers[index].hasClients) {
              final position = _scrollControllers[index].position;
              final maxScroll = position.maxScrollExtent;

              // 초기 위치에서 시작하도록 애니메이션 오프셋 조정
              _scrollControllers[index].jumpTo(
                maxScroll * _scrollAnimations[index].value.dx,
              );
            }
          }
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            // mounted 상태 확인
            _animationControllers[i].reset();
            _animationControllers[i].forward();
          }
        }));

      _animationControllers[i].forward();
    }
  }

  @override
  void dispose() {
    // 모든 컨트롤러 해제
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatLikes(int likes) {
    if (likes >= 10000) {
      double roundedLikes = (likes / 1000).roundToDouble() / 10.0;
      return '${roundedLikes.toStringAsFixed(1)}만';
    } else {
      return likes.toString();
    }
  }

  Widget _buildScrollingRow(int index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${index + 1}',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          SizedBox(
            width: 200,
            child: SingleChildScrollView(
              controller: _scrollControllers[index],
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    titles[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.favorite,
                  size: 15,
                  color: Colors.pink,
                ),
                Text(
                  _formatLikes(likes[index]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
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
                height: 240,
                padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    SizedBox(height: 10),
                    ...List.generate(
                      titles.length,
                      (index) => _buildScrollingRow(index),
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
      ),
    );
  }
}







// class _ChartBoardState extends State<ChartBoard>
//     with SingleTickerProviderStateMixin {
//   late final ScrollController _scrollController;
//   late final AnimationController _animationController;
//   late final Animation<Offset> _scrollAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 20),
//     );

//     _scrollAnimation = Tween<Offset>(
//       begin: Offset(-1, 0),
//       end: Offset(1, 0),
//     ).animate(_animationController)
//       ..addListener(() {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent *
//             _scrollAnimation.value.dx);
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _animationController.reset();
//           _animationController.forward();
//         }
//       });
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         height: 250,
//         margin: EdgeInsets.fromLTRB(15, 30, 15, 20),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 20,
//                   color: Color(0XFFFFFFFDE),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 230,
//                   padding: EdgeInsets.only(top: 40),
//                   decoration: BoxDecoration(
//                     color: Colors.white, // 배경색 설정
//                     borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 설정
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             '실시간 인기순위',
//                             style: TextStyle(color: Colors.black, fontSize: 18),
//                           ),
//                           Text(
//                             '2024년 10월 20일 14:00 기준',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             '1',
//                             style: TextStyle(color: Colors.black, fontSize: 18),
//                           ),
//                           SizedBox(
//                             width: 200,
//                             child: SingleChildScrollView(
//                               controller: _scrollController,
//                               scrollDirection: Axis.horizontal,
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     'This is a very long title that should scroll automatically if it exceeds the width of the screen.',
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 15,
//                           ),
//                           Text(
//                             '3,098',
//                           ),
//                         ],
//                       ),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       //   children: [
//                       //     Text(
//                       //       '1',
//                       //       style: TextStyle(color: Colors.black, fontSize: 18),
//                       //     ),
//                       //     SizedBox(
//                       //       width: 200,
//                       //       child: SingleChildScrollView(
//                       //         controller: _scrollController,
//                       //         scrollDirection: Axis.horizontal,
//                       //         child: Row(
//                       //           children: [
//                       //             Text(
//                       //               'This is a very long title that should scroll automatically if it exceeds the width of the screen.',
//                       //               style: TextStyle(fontSize: 20),
//                       //             ),
//                       //           ],
//                       //         ),
//                       //       ),
//                       //     ),
//                       //     Icon(
//                       //       Icons.favorite_border,
//                       //       size: 15,
//                       //     ),
//                       //     Text(
//                       //       '3,098',
//                       //     ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/character_color.png',
//                     width: 150,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
// }
