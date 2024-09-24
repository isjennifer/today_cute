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
import 'package:mime/mime.dart'; // for detecting file type
import '../main.dart';

class PostCreationPage extends StatefulWidget {
  final List<File> images;
  final File? video;

  const PostCreationPage({Key? key, required this.images, this.video})
      : super(key: key);

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  List<File> _images = [];
  File? _video;
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _images = widget.images;
    _video = widget.video;

    if (_video != null) {
      _videoController = VideoPlayerController.file(_video!)..setLooping(true);
      _initializeVideoPlayerFuture = _videoController!.initialize();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  // Future<void> addMoreImages() async {
  //   final picker = ImagePicker();
  //   final pickedFiles = await picker.pickMultiImage();

  //   if (pickedFiles != null) {
  //     setState(() {
  //       _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
  //     });
  //   }
  // }

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  Future<void> uploadPost(BuildContext context) async {
    // SharedPreferences에서 accessToken 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    // 만약 accessToken이 없다면, 예외 처리
    if (accessToken == null) {
      print('Access token이 없습니다.');
      return;
    } else {
      print('Access token: $accessToken'); // 이 부분이 제대로 출력되는지 확인
    }

    // 제목, 내용, 태그 검증
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목을 입력하세요.')),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('내용을 입력하세요.')),
      );
      return;
    }

    if (_tagsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('태그를 입력하세요.')),
      );
      return;
    }

    final uri = Uri.parse('http://52.231.106.232:8000/api/post/'); // 서버 주소

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';

    // 제목, 내용, 태그 추가
    request.fields['title'] = _titleController.text;
    request.fields['content'] = _contentController.text;
    request.fields['tags'] = _tagsController.text;

    // 이미지 파일 추가
    for (var image in _images) {
      final mimeTypeData = lookupMimeType(image.path);
      if (mimeTypeData != null) {
        final mimeType = mimeTypeData.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'files', // 서버에서 기대하는 필드명
            image.path,
            filename: basename(image.path),
            contentType: MediaType(mimeType[0], mimeType[1]), // MIME 타입 설정
          ),
        );
      }
    }

    // 동영상 파일 추가 (선택적)
    if (_video != null) {
      final mimeTypeData = lookupMimeType(_video!.path);
      if (mimeTypeData != null) {
        final mimeType = mimeTypeData.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'files', // 서버에서 기대하는 필드명
            _video!.path,
            filename: basename(_video!.path),
            contentType: MediaType(mimeType[0], mimeType[1]), // MIME 타입 설정
          ),
        );
      }
    }

    // 요청 전송
    var response = await request.send();

    // 응답을 문자열로 변환하여 확인
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // 업로드 성공 처리
      print('업로드 성공');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물이 업로드되었습니다.')),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('깃털을 한개 얻었습니다.')),
      );
      // 업로드 성공 후 피드 페이지로 이동 (수정 필요)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthCheck()),
          (Route<dynamic> route) => false);
    } else {
      // 업로드 실패 처리
      print('Fail Response: $responseString');
      print('업로드 실패');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드에 실패했습니다. 다시 시도해주세요.')),
      );
      // 업로드 실패 시 화면을 종료
      Navigator.pop(context);
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
        title: Text('게시물 작성'),
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
              SizedBox(height: 10),
              if (_video == null) // 동영상이 없는 경우에만 이미지 그리드 및 추가 버튼 표시
                Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => removeImage(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    // TextButton(
                    //   style: ElevatedButton.styleFrom(
                    //     minimumSize: Size(200, 50),
                    //     backgroundColor: Colors.white,
                    //     foregroundColor: Color.fromARGB(255, 21, 120, 120),
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(50),
                    //     ),
                    //   ),
                    //   onPressed: addMoreImages,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [Icon(Icons.add, size: 18), Text('이미지 추가')],
                    //   ),
                    // ),
                  ],
                ),
              if (_video != null) // 동영상이 있는 경우 동영상 미리보기 및 클릭 시 재생/일시정지
                Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '동영상 미리보기 (터치하여 재생) :',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return GestureDetector(
                            onTap: _toggleVideoPlayback, // 동영상 클릭 시 재생/일시정지
                            child: AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              SizedBox(height: 20),
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
              '게시물 업로드',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () async {
              // 업로드 로직 추가
              uploadPost(context);
            },
          ),
        ),
      ),
    );
  }
}

// 동영상 재생을 위한 위젯 추가
class VideoPlayerWidget extends StatefulWidget {
  final File video;

  const VideoPlayerWidget({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
