import 'package:flutter/material.dart';
import 'package:today_cute/models/post.dart';
import 'package:today_cute/screens/post_edit_page.dart';
import 'package:today_cute/widgets/post_container.dart';
import 'package:today_cute/widgets/show_delete_dialog.dart';

class PostDetailPage extends StatelessWidget {
  final Post post; // 클릭된 게시글 정보
  final String myId;

  const PostDetailPage({super.key, required this.post, required this.myId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title, textAlign: TextAlign.center), // 게시글 제목
        actions: [
          myId == post.userId
              ? IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('수정'),
                                onTap: () async {
                                  // 수정 기능 구현
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PostEditPage(
                                          post: post), // 수정할 post 전달
                                    ),
                                  );
                                  Navigator.of(context).pop(); // 팝업 닫기
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('삭제'),
                                onTap: () async {
                                  // 삭제 기능 구현
                                  await showDeletePostDialog(context, post.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert),
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0XFFFFFFFDE),
          child: PostContainer(post: post), // 게시글 정보 표시
        ),
      ),
    );
  }
}
