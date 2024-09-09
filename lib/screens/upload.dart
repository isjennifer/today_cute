import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'post_creation_page.dart';

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
