import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<String> getUserIdFromToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? '';

  if (token.isNotEmpty) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['user_id'] ?? '';
  }

  return '';
}

DateTime? getTokenExpiryDate(String token) {
  return JwtDecoder.getExpirationDate(token);
}
