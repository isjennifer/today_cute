import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_cute/services/api_service.dart';

Future<void> showDeletePostDialog(
    BuildContext context, String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // 모달 밖을 클릭하면 닫힘
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: 400,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning),
                SizedBox(height: 10),
                Text(
                  '게시물을 삭제하시겠습니까?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        await deletePostData(context, postId, accessToken); // 게시물 삭제
                      },
                      child: Text('삭제'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 모달 창 닫기
                      },
                      child: Text('취소'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
