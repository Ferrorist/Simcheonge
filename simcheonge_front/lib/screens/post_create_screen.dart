import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategoryNumber; // 선택된 카테고리 번호
  final List<Map<String, dynamic>> _categoryOptions = [
    {'name': '정책 추천', 'number': 2},
    {'name': '공모전', 'number': 3},
    {'name': '생활 꿀팁', 'number': 4},
    {'name': '기타', 'number': 5},
  ]; // 카테고리 옵션 예시
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _createPost() async {
    if (_selectedCategoryNumber == null) {
      // 카테고리가 선택되지 않았을 경우 처리
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('카테고리를 선택해주세요.')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');

    final url = Uri.parse('https://j10e201.p.ssafy.io/api/posts');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // JWT 토큰을 여기에 삽입
        "Cache-Control": "no-cache",
      },
      body: jsonEncode({
        'postName': _titleController.text,
        'postContent': _contentController.text,
        'categoryCode': 'POS',
        'categoryNumber': int.parse(_selectedCategoryNumber!),
        'userNickname': '사용자 닉네임', // 실제 사용자 닉네임을 여기에 삽입
      }),
    );
    print(accessToken);
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('글 작성에 성공했습니다. 글 번호: ${responseData["data"]["post_id"]}')));
      // 글 작성 후 처리 로직, 예: 글 목록 화면으로 돌아가기
    } else {
      // 실패 처리
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('글 작성 실패: ${responseData["message"]}')));
      throw Exception('서버로부터 비어 있는 응답을 받았습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 작성'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryNumber,
                  hint: const Text('게시판 선택'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategoryNumber = newValue!;
                    });
                  },
                  items:
                      _categoryOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option['number'].toString(),
                      child: Text(option['name']),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: '제목', // 라벨 텍스트
                    hintText: '여기에 제목을 입력하세요', // 힌트 텍스트
                    border: OutlineInputBorder(
                      // 테두리를 정의
                      borderRadius: BorderRadius.circular(8.0), // 테두리 모서리를 둥글게
                    ),
                    enabledBorder: OutlineInputBorder(
                      // 활성화 상태일 때의 테두리 스타일
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 포커스를 받았을 때의 테두리 스타일
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null; // 검증을 통과했을 때는 null을 반환
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    controller: _contentController, // 컨트롤러 추가
                    maxLines: null, // 무제한 줄 입력 가능
                    decoration: InputDecoration(
                      labelText: '내용', // 라벨 텍스트
                      hintText: '여기에 내용을 입력하세요', // 힌트 텍스트
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // 테두리 둥글게
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // 활성화 상태일 때의 테두리 스타일
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 포커스를 받았을 때의 테두리 스타일
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                          left: 10.0,
                          right: 10.0), // 내부 패딩 조정
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '내용을 입력해주세요.';
                      }
                      return null; // 검증을 통과했을 때는 null을 반환
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 취소 버튼 클릭 시 이전 화면으로 돌아감
                        if (_formKey.currentState!.validate()) {
                          // 모든 validator를 통과하면 _createPost 함수 호출
                          _createPost();
                        }
                      },
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _createPost;
                        print('check');
                      }, // 작성 완료 버튼 클릭 시 글 작성 처리
                      child: const Text('작성 완료'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
