import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/search_model.dart';

class SearchApi {
  Future<SearchModel> searchPolicies(
      String keyword, List<Map<String, dynamic>> filters,
      {String? startDate, String? endDate}) async {
    final url = Uri.parse('https://j10e102.p.ssafy.io/api/policy/search');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      // body에 startDate와 endDate 추가
      body: jsonEncode({
        "keyword": keyword,
        "list": filters,
        "startDate": startDate, // startDate를 요청 본문에 포함
        "endDate": endDate, // endDate를 요청 본문에 포함
      }),
    );

    if (response.statusCode == 200) {
      // JSON 디코딩할 때 allowMalformed: true 옵션 추가
      final responseData =
          json.decode(utf8.decode(response.bodyBytes, allowMalformed: true));
      return SearchModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load policies');
    }
  }
}
