import 'dart:convert';
import 'package:http/http.dart' as http;

class PostService {
  static Future<List<dynamic>> fetchPosts({int categoryNumber = 1}) async {
    final keyword = categoryNumber == 1 ? '' : '특정 키워드'; // 필요에 따라 조정
    final url = Uri.parse(
        'https://j10e201.p.ssafy.io/api/posts?keyword=$keyword&category_code=POS&category_number=$categoryNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
