import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

// Fetch posts from API
Future<List<Post>> fetchPostData() async {
  try {
    final response = await http.get(
      Uri.parse('http://52.231.106.232:8000/api/post/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final List<dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    return decodedResponse.map((json) => Post.fromJson(json)).toList();
  } catch (e) {
    print('Error: $e');
    return []; // Return an empty list on error
  }
}

Future<void> deletePostData(String postId) async {
  try {
    final response = await http.delete(
      Uri.parse('http://52.231.106.232:8000/api/post/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final Map<String, dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    print('deletePostData: $decodedResponse');
  } catch (e) {
    print('Error: $e');
  }
}

// Fetch user data from API (if needed)
Future<void> fetchId() async {
  try {
    final responseId = await http.get(
      Uri.parse('http://52.231.106.232:8000/api/user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final List<dynamic> decodedResponseId =
        jsonDecode(utf8.decode(responseId.bodyBytes));

    // Handle response if needed
  } catch (e) {
    print('Error: $e');
  }
}
