import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import '../models/post.dart';

class PostEditPage extends StatefulWidget {
  final Post post; // 수정할 포스팅 정보를 받습니다.

  const PostEditPage({Key? key, required this.post}) : super(key: key);

  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 수정할 포스팅의 정보로 텍스트 필드를 초기화합니다.
    _titleController.text = widget.post.title;
    _contentController.text = widget.post.content;
    _tagsController.text = widget.post.tags.join(', ');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> updatePost(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token이 없습니다.');
      return;
    }

    final uri = Uri.parse(
        'http://52.231.106.232:8000/api/post/${widget.post.id}'); // 서버 주소
    var request = http.Request('PUT', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.headers['Content-Type'] = 'application/json';

    // 수정된 데이터 추가
    request.body = jsonEncode({
      'title': _titleController.text,
      'content': _contentController.text,
      'tags': _tagsController.text.split(',').map((tag) => tag.trim()).toList(),
    });

    var response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // 수정 성공 처리
      print('수정 성공');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물이 수정되었습니다.')),
      );
      Navigator.pop(context); // 화면을 종료
    } else {
      // 수정 실패 처리
      print('Fail Response: ${response.statusCode}');
      print('Response Body: $responseString');
      print('수정 실패');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onTagChanged(String value) {
      // 태그를 공백이나 쉼표로 분리
      List<String> tags = value
          .split(RegExp(r'[,\s]+'))
          .where((tag) => tag.isNotEmpty)
          .toList();

      // 태그 개수를 10개로 제한
      if (tags.length > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('태그는 최대 10개까지 입력할 수 있습니다.')),
        );
        // 10개 이상의 태그가 입력되면, 제한된 10개 태그로 입력값을 조정
        _tagsController.text = tags.sublist(0, 10).join(', ');
        _tagsController.selection = TextSelection.fromPosition(
          TextPosition(offset: _tagsController.text.length),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 수정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _titleController,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: '태그 (쉼표(,)로 구분하여 작성)',
                  border: OutlineInputBorder(),
                ),
                onChanged: _onTagChanged,
              ),
              SizedBox(height: 20),
              Text('이미지 또는 동영상은 수정할 수 없습니다.'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFCCFFFF),
              foregroundColor: Color.fromARGB(255, 21, 120, 120),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              '게시물 수정 완료',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              updatePost(context);
            },
          ),
        ),
      ),
    );
  }
}
