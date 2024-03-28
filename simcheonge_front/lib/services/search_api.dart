import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/search_model.dart';
import 'package:flutter/material.dart'; // debugPrint를 사용하기 위해 추가

class SearchApi {
  Future<SearchModel> searchPolicies(
      String keyword, List<Map<String, dynamic>> filters,
      {String? startDate, String? endDate}) async {
    final url = Uri.parse('https://j10e102.p.ssafy.io/api/policy/search');

    // 요청 본문을 구성합니다.
    var requestBody = jsonEncode({
      "keyword": keyword,
      "list": filters,
      "startDate": startDate,
      "endDate": endDate,
    });

    // 디버그 출력을 사용하여 요청 본문을 출력합니다.
    debugPrint('Request body: $requestBody');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseData =
          json.decode(utf8.decode(response.bodyBytes, allowMalformed: true));
      return SearchModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load policies');
    }
  }
}
