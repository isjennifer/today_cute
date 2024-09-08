import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<File> _images = [];
  File? _video;
  final picker = ImagePicker();

  Future getImages(ImageSource source) async {
    if (source == ImageSource.camera) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _images = [File(pickedFile.path)];
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCreationPage(images: _images),
          ),
        );
      }
    } else {
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.length <= 5 && pickedFiles.isNotEmpty) {
        setState(() {
          _images = pickedFiles.map((file) => File(file.path)).toList();
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCreationPage(images: _images),
          ),
        );
      } else if (pickedFiles.length > 5 && pickedFiles.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지는 최대 5개까지 선택할 수 있습니다.')),
        );
      }
    }
  }

  Future getVideo(ImageSource source) async {
    final pickedFile = await picker.pickVideo(source: source);

    if (pickedFile != null) {
      // 동영상 플레이어 컨트롤러로 길이를 확인합니다.
      final videoPlayerController =
          VideoPlayerController.file(File(pickedFile.path));
      await videoPlayerController.initialize();

      final videoDuration = videoPlayerController.value.duration;

      // 동영상 길이가 1분 이내인지 확인합니다.
      if (videoDuration.inMinutes < 1) {
        setState(() {
          _video = File(pickedFile.path);
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCreationPage(
              images: _images, // images 인자를 전달합니다.
              video: _video, // 선택적으로 video 인자를 전달합니다.
            ),
          ),
        );
      } else {
        // 동영상이 1분 이상일 경우 경고 메시지를 띄웁니다.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('동영상 길이는 1분 이내여야 합니다.')),
        );
      }

      // 리소스 해제
      videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFCCFFFF), // 버튼의 배경색 (예: 파란색)
                    foregroundColor:
                        Color.fromARGB(255, 21, 120, 120), // 버튼의 텍스트 색상 (예: 흰색)
                    // 버튼 내부의 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // 버튼의 둥근 테두리
                    ),
                  ),
                  child: Text('갤러리에서 이미지 선택'),
                  onPressed: () => getImages(ImageSource.gallery),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFCCFFFF), // 버튼의 배경색 (예: 파란색)
                    foregroundColor:
                        Color.fromARGB(255, 21, 120, 120), // 버튼의 텍스트 색상 (예: 흰색)
                    // 버튼 내부의 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // 버튼의 둥근 테두리
                    ),
                  ),
                  child: Text('갤러리에서 동영상 선택'),
                  onPressed: () => getVideo(ImageSource.gallery),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFCCFFFF), // 버튼의 배경색 (예: 파란색)
                    foregroundColor:
                        Color.fromARGB(255, 21, 120, 120), // 버튼의 텍스트 색상 (예: 흰색)
                    // 버튼 내부의 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // 버튼의 둥근 테두리
                    ),
                  ),
                  child: Text('카메라로 사진 촬영'),
                  onPressed: () => getImages(ImageSource.camera),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFCCFFFF), // 버튼의 배경색 (예: 파란색)
                    foregroundColor:
                        Color.fromARGB(255, 21, 120, 120), // 버튼의 텍스트 색상 (예: 흰색)
                    // 버튼 내부의 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // 버튼의 둥근 테두리
                    ),
                  ),
                  child: Text('카메라로 동영상 촬영'),
                  onPressed: () => getVideo(ImageSource.camera),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

  void _onTagChanged(String value) {
    // 태그를 공백이나 쉼표로 분리
    List<String> tags =
        value.split(RegExp(r'[,\s]+')).where((tag) => tag.isNotEmpty).toList();

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

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              // 업로드 로직 추가
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('게시물이 업로드되었습니다.')),
              );
              Navigator.pop(context);
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
