import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:today_cute/models/post.dart';
import 'package:today_cute/services/api_service.dart';
import 'package:today_cute/widgets/post_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Post 모델 리스트를 상태로 관리
  List<Post> posts = [];
  bool isSearching = false; // 검색 중 여부를 관리할 상태

  // 검색 결과를 posts 상태로 저장하는 메서드
  void _searchPosts(List<Post> results) {
    setState(() {
      posts = results;
      isSearching = true; // 검색이 수행되었으므로 ChartBoard를 감춤
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFFFFFFFDE),
      child: Column(
        children: [
          InputField(
            onSearch: _searchPosts,
          ),
          isSearching
              ? Expanded(
                  child: PostList(posts: posts), // 검색 결과가 있을 때 리스트를 보여줌
                )
              : const ChartBoard(), // 검색 전에는 ChartBoard를 표시
        ],
      ),
    );
  }
}

// Post 모델 리스트를 보여주는 위젯 예시
// TODO image_body 위젯으로 대체 되어야함
class PostList extends StatelessWidget {
  final List<Post> posts;

  const PostList({super.key, required this.posts});
  @override
  Widget build(BuildContext context) {
    return posts.isEmpty
        ? Center(child: Text('검색결과가 없습니다.'))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostContainer(
                post: post,
                // onDelete: () => _deletePost(post.id), // 삭제 콜백 함수 전달
              );
            },
          );
  }
}

class InputField extends StatefulWidget {
  final Function(List<Post>) onSearch;

  const InputField({super.key, required this.onSearch});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String query = '';
  String sort = ''; // TODO: 정렬 기준 선택 버튼 추가 필요

  final TextEditingController _searchController =
      TextEditingController(); // 검색어를 관리하는 컨트롤러 추가

  // 검색 요청을 수행하는 메서드
  Future<void> _performSearch(String query) async {
    // 실제 검색 요청이나 로직을 구현하는 부분
    print('검색어: $query');
    List<Post> results = await searchPostData(search: query);
    widget.onSearch(results);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFFFFFFFDE),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _searchController, // TextField에 컨트롤러 추가 (검색어 입력 관리)
            onChanged: (text) {
              setState(() {
                query = text;
              });
            },
            onSubmitted: (text) {
              if (text.isNotEmpty) {
                _performSearch(text); // 키보드의 제출 버튼을 눌렀을 때 검색 로직 호출
              }
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
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();

    fetchPopularPosts();
  }

  void _initializeControllersAndAnimations() {
    // 리스트 초기화
    _scrollControllers = [];
    _animationControllers = [];
    _scrollAnimations = [];

    for (int i = 0; i < posts.length; i++) {
      _scrollControllers.add(ScrollController());
      _animationControllers.add(AnimationController(
        vsync: this,
        duration: Duration(seconds: (posts[i].title.length / 6).toInt()),
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

  Future<void> fetchPopularPosts() async {
    final postList =
        await fetchPopularPostData(); // api_service.dart의 fetchPostData 호출
    setState(() {
      posts = postList;
      print('popularPostList:$postList');
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _initializeControllersAndAnimations();
    });
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
    final post = posts[index]; // 수정: 게시글 데이터 사용
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
                    post.title,
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
                  _formatLikes(post.likes),
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
    // 현재 날짜 가져오기
    String formattedDate = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

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
                          '일간 인기순위',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          '$formattedDate 기준',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ...List.generate(
                      posts.length,
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
