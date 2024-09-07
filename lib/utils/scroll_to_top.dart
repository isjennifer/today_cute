import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController; // 외부에서 스크롤 컨트롤러를 전달 받음

  const ScrollToTopButton({required this.scrollController, Key? key})
      : super(key: key);

  @override
  _ScrollToTopButtonState createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();

    // 스크롤 컨트롤러 리스너 추가
    widget.scrollController.addListener(() {
      // 스크롤이 맨 아래에 있는지 확인
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0.0, // 맨 위로 스크롤
      duration: Duration(seconds: 1), // 애니메이션 시간
      curve: Curves.easeInOut, // 애니메이션 곡선
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showScrollToTopButton
        ? Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            ),
          )
        : SizedBox(); // 버튼이 없을 때는 빈 공간
  }
}
