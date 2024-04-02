import 'dart:convert';
import 'dart:math';
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
  ];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _userNickname;

  @override
  void initState() {
    super.initState();
    _loadUserNickname();
  }

  Future<void> _loadUserNickname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNickname = prefs.getString('userNickname'); // 닉네임 불러오기
    });
  }

  Future<void> _createPost() async {
    if (_selectedCategoryNumber == null) {
      // 카테고리가 선택되지 않았을 경우 처리
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('카테고리를 선택해주세요.')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');

    final url = Uri.parse('https://j10e102.p.ssafy.io/api/posts');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': "application/json; charset=UTF-8",
        'Authorization': "Bearer $accessToken", // JWT 토큰을 여기에 삽입
      },
      body: jsonEncode({
        'postName': _titleController.text,
        'postContent': _contentController.text,
        'categoryCode': 'POS',
        'categoryNumber': int.parse(_selectedCategoryNumber!),
        'userNickname': _userNickname, // 실제 사용자 닉네임을 여기에 삽입
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final postId = data['postId'];
      Navigator.pop(context); // 성공 시 이전 화면으로 돌아가기
    } else {
      print(response.statusCode);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('게시글 작성에 실패했습니다.')));
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
                        if (_formKey.currentState!.validate()) {
                          _createPost();
                          print('check');
                        }
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
