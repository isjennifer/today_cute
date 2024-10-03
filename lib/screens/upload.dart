import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
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
  final _flutterFFmpeg = FlutterFFmpeg();

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
    try {
      final pickedFile = await picker.pickVideo(source: source);

      if (pickedFile != null) {
        File? videoFile = File(pickedFile.path);

        // MOV 파일을 선택했을 경우 MP4로 변환
        if (videoFile.path.endsWith('.mov')) {
          videoFile = await _convertMovToMp4(videoFile) ?? videoFile;
        }

        // 동영상 플레이어 컨트롤러로 길이를 확인합니다.
        final videoPlayerController = VideoPlayerController.file(videoFile);
        await videoPlayerController.initialize();

        final videoDuration = videoPlayerController.value.duration;

        // 동영상 길이가 1분 이내인지 확인합니다.
        if (videoDuration.inMinutes < 1) {
          setState(() {
            _video = videoFile;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostCreationPage(
                images: [], // images 인자로는 빈값 전달.
                video: _video, // video 인자를 전달합니다.
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
    } catch (e) {
      // 예외가 발생했을 경우 처리
      print('비디오 처리 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('동영상을 처리하는 도중 오류가 발생했습니다.')),
      );
    }
  }

// MOV 파일을 MP4로 변환하는 함수
  Future<File?> _convertMovToMp4(File movFile) async {
    final outputFilePath =
        movFile.path.replaceAll('.mov', '.mp4'); // MP4로 변환될 경로 설정

    try {
      // FFmpeg 명령어로 MOV 파일을 MP4로 변환 (강제로 h264와 aac로 변환)
    final int result = await _flutterFFmpeg.execute(
        '-i ${movFile.path} -c:v libx264 -c:a aac -strict -2 -b:a 192k -pix_fmt yuv420p $outputFilePath');


      if (result == 0) {
        // 변환이 성공적으로 완료되었을 경우
        return File(outputFilePath); // 변환된 MP4 파일 반환
      } else {
        // 변환이 실패한 경우
        print('비디오 변환 실패. 오류 코드: $result');
        return null;
      }
    } catch (e) {
      // 예외가 발생했을 경우
      print('예외 발생: $e');
      return null;
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
