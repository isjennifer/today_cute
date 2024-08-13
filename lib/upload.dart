import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // Image Picker 인스턴스 생성
  final ImagePicker picker = ImagePicker();

  // 카메라 또는 갤러리의 이미지를 저장할 변수
  XFile? _imageFile;

  // 이미지를 가져오는 함수
  Future<void> getImage(ImageSource imageSource) async {
    try {
      // 카메라 또는 갤러리의 이미지
      final XFile? imageFile = await picker.pickImage(
          source: imageSource, maxHeight: 300, maxWidth: 300);

      if (imageFile != null) {
        // 이미지를 화면에 출력하기 위해 앱의 상태 변경
        setState(() {
          _imageFile = imageFile;
        });
      }
    } catch (e) {
      print("디버깅용 이미지 호출 에러 : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: _buildPhotoArea(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 카메라 선택 버튼
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: const Text("카메라"),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  // 앨범 선택 버튼
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    child: const Text("앨범"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    // 불러온 이미지가 있는지 없는지 확인
    return _imageFile != null
        // 불러온 이미지가 있으면 출력
        ? Center(
            child: Image.file(
              File(_imageFile!.path),
            ),
          )
        // 불러온 이미지가 없으면 텍스트 출력
        : const Center(
            child: Text("불러온 이미지가 없습니다."),
          );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';

// class UploadPage extends StatefulWidget {
//   const UploadPage({super.key});

//   @override
//   _UploadPageState createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   File? _image;
//   File? _video;
//   final picker = ImagePicker();

//   Future getImage(ImageSource source) async {
//     // 갤러리 권한 확인
//     if (source == ImageSource.gallery) {
//       var status = await Permission.photos.status;
//       if (!status.isGranted) {
//         status = await Permission.photos.request();
//         if (!status.isGranted) {
//           // 사용자가 권한을 거부한 경우
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('갤러리 접근 권한이 필요합니다.')),
//           );
//           return;
//         }
//       }
//     }

//     try {
//       final pickedFile = await picker.pickImage(source: source);

//       setState(() {
//         if (pickedFile != null) {
//           _image = File(pickedFile.path);
//         }
//       });
//     } catch (e) {
//       print('이미지 선택 중 오류 발생: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('이미지를 선택하는 중 오류가 발생했습니다.')),
//       );
//     }
//   }

//   Future getVideo(ImageSource source) async {
//     final pickedFile = await picker.pickVideo(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _video = File(pickedFile.path);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image != null
//                 ? Image.file(_image!, height: 200)
//                 : Text('선택된 이미지 없음'),
//             SizedBox(height: 20),
//             _video != null
//                 ? Text('비디오 선택됨: ${_video!.path}')
//                 : Text('선택된 비디오 없음'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               child: Text('갤러리에서 사진 선택'),
//               onPressed: () => getImage(ImageSource.gallery),
//             ),
//             ElevatedButton(
//               child: Text('카메라로 사진 촬영'),
//               onPressed: () => getImage(ImageSource.camera),
//             ),
//             ElevatedButton(
//               child: Text('갤러리에서 동영상 선택'),
//               onPressed: () => getVideo(ImageSource.gallery),
//             ),
//             ElevatedButton(
//               child: Text('카메라로 동영상 촬영'),
//               onPressed: () => getVideo(ImageSource.camera),
//             ),
//             ElevatedButton(
//               child: Text('업로드'),
//               onPressed: () {
//                 // 여기에 실제 업로드 로직을 구현합니다.
//                 // 예: 서버로 _image 또는 _video 파일 전송
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('업로드 기능은 아직 구현되지 않았습니다.')),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
