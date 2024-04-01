import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkNickname(String newNickname) async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  // 사용자가 입력한 새 닉네임을 API 요청 URL에 포함
  final url = Uri.parse(
      'https://j10e102.p.ssafy.io/api/users/update/check-nickname?userNickname=$newNickname');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  print(response.statusCode);
  return response.statusCode == 200;
}

Future<bool> updateNickname(String nickname) async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final url = Uri.parse('https://j10e102.p.ssafy.io/api/users/update/nickname');

  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({'userNickname': nickname}),
  );

  return response.statusCode == 200;
}
