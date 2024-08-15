import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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

  Future getImages() async {
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostCreationPage(images: _images),
        ),
      );
    } else {
      // 사진 선택이 취소되었을 경우 (pickedFiles가 null이거나 비어 있을 때)
      // 네비게이션을 작동시키지 않음.
    }
  }

  Future getVideo(ImageSource source) async {
    final pickedFile = await picker.pickVideo(source: source);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      }
    });
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
                  onPressed: getImages,
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
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _images.add(File(pickedFile.path));
                      });
                    }
                  },
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

  const PostCreationPage({Key? key, required this.images}) : super(key: key);

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _images = widget.images;
  }

  Future addMoreImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
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
                    labelText: '태그 (#으로 구분하여 작성)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
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
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50), // 버튼의 최소 크기 지정 (가로 150, 세로 50)
                    backgroundColor: Colors.white, // 버튼의 배경색 (예: 파란색)
                    foregroundColor: Color.fromARGB(255, 21, 120, 120),
                    // 버튼의 텍스트 색상 (예: 흰색)
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // 버튼 내부의 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // 버튼의 둥근 테두리
                    ),
                  ),
                  onPressed: addMoreImages,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                        ),
                        Text('이미지 추가')
                      ]),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: SizedBox(
          width: double.infinity, // 가로 크기를 화면의 너비로 설정
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFCCFFFF), // 버튼의 배경색 (예: 파란색)
              foregroundColor:
                  Color.fromARGB(255, 21, 120, 120), // 버튼의 텍스트 색상 (예: 흰색)
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15), // 버튼 내부의 패딩
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // 버튼의 둥근 테두리
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
        )));
  }
}
