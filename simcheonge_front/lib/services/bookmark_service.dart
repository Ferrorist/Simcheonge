import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/bookmark_detail.dart';

class BookmarkService {
  static const String _baseUrl = 'https://j10e102.p.ssafy.io/api/bookmarks';

  // 북마크 조회 메서드 추가
  Future<List<Bookmark>> getBookmarks(String bookmarkType) async {
    print('체크중');

    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    final Uri url = Uri.parse('$_baseUrl?bookmarkType=$bookmarkType');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // 'bookmarks' 키에 해당하는 값을 추출하고, null이면 빈 리스트로 처리
      List<dynamic> bookmarksJson = jsonResponse['bookmarks'] ?? [];

      List<Bookmark> bookmarks = bookmarksJson
          .map((bookmarkJson) =>
              Bookmark.fromJson(bookmarkJson as Map<String, dynamic>))
          .toList();
      return bookmarks;
    } else {
      // 에러 처리
      print(accessToken);
      print(response.statusCode);
      throw Exception('Failed to load bookmarks');
    }
  }

  Future<int?> createBookmark(String bookmarkType,
      {int? policyId, int? postId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, dynamic> body = {
      'bookmarkType': bookmarkType,
      if (bookmarkType == "POL") 'policyId': policyId,
      if (bookmarkType == "POS") 'postId': postId,
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );
    print('여기여기 ${response.statusCode}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // 서버 응답에서 bookmarkId 추출
      return jsonResponse['bookmarkId'];
    } else {
      // 오류 처리: 상태 코드가 200이 아닌 경우, 실패로 간주
      print('Failed to create bookmark: ${response.body}');
      return null; // 실패 시 null 반환
    }
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$bookmarkId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Bookmark deleted successfully');
    } else {
      print('Failed to delete bookmark');
    }
  }
}
