import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  static const String _baseUrl = 'https://j10e102.p.ssafy.io/api/posts';

  static Future<Map<String, dynamic>> fetchPostDetail(int postId) async {
    print('Fetching post detail for postId: $postId');

    final url = Uri.parse('$_baseUrl/$postId');
    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': "Bearer $accessToken", // JWT 토큰을 여기에 삽입
      },
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final decodedJson = json.decode(responseBody);
      print('Post detail fetched successfully');
      print(decodedJson['data']);
      return decodedJson['data'];
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('로그인이 필요 합니다.');
    } else {
      print(response.statusCode);
      print('Failed to fetch post detail');

      throw Exception('게시글을 불러오는 데 실패했습니다.');
    }
  }

  List<Map<String, dynamic>> categoryOptions = [
    {'name': '정책 추천', 'number': 2},
    {'name': '공모전', 'number': 3},
    {'name': '생활 꿀팁', 'number': 4},
    {'name': '기타', 'number': 5},
  ];

  int? findCategoryNumber(String categoryName) {
    final category = categoryOptions.firstWhere(
      (option) => option['name'] == categoryName,
      orElse: () => {'number': null},
    );
    return category['number'];
  }

  static Future<List<dynamic>> fetchPosts(
      {int? categoryNumber, String keyword = ''}) async {
    // URI 수정: 정확한 서버 주소와 쿼리 파라미터를 사용합니다.
    final url = Uri.parse(
        '$_baseUrl?categoryCode=POS&categoryNumber=${categoryNumber ?? 1}&keyword=$keyword');

    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      }, // 필요에 따라 헤더 추가
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final decodedJson = json.decode(responseBody);
      print(decodedJson['data']);
      return decodedJson['data'];
    } else {
      print(response.statusCode);
      throw Exception('Failed to load posts');
    }
  }
}
