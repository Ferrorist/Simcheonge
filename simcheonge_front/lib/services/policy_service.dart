import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:simcheonge_front/widgets/policy_detail.dart';

class PolicyService {
  static const String _baseUrl = 'https://j10e102.p.ssafy.io/api/policy';

  static Future<PolicyDetail> fetchPolicyDetail(int policyId) async {
    final url = Uri.parse('$_baseUrl/$policyId');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json; charset=UTF-8",
    });

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final decodedJson = json.decode(responseBody);
      return PolicyDetail.fromJson(decodedJson);
    } else {
      throw Exception('Failed to load policy detail');
    }
  }
}
