import 'package:flutter/material.dart';

class PostEditScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostEditScreen({super.key, required this.post});

  @override
  _PostEditScreenState createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _postNameController;
  late TextEditingController _postContentController;
  String? _selectedCategoryName;
  final List<Map<String, dynamic>> _categoryOptions = [
    {'name': '정책 추천', 'number': 2},
    {'name': '공모전', 'number': 3},
    {'name': '생활 꿀팁', 'number': 4},
    {'name': '기타', 'number': 5},
  ];

  @override
  void initState() {
    super.initState();
    _postNameController = TextEditingController(text: widget.post['postName']);
    _postContentController =
        TextEditingController(text: widget.post['postContent']);
    _selectedCategoryName = _categoryOptions.firstWhere(
      (option) => option['number'] == widget.post['categoryNumber'],
      orElse: () => _categoryOptions[0],
    )['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 수정'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _selectedCategoryName,
                  hint: const Text('게시판 선택'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategoryName = newValue;
                    });
                  },
                  items: _categoryOptions.map<DropdownMenuItem<String>>(
                      (Map<String, dynamic> option) {
                    return DropdownMenuItem<String>(
                      value: option['name'],
                      child: Text(option['name']),
                    );
                  }).toList(),
                ),
                // 여기에 다른 필드 (예: _postNameController, _postContentController)를 위한 TextField 위젯 추가
                const SizedBox(height: 24), // Add some spacing

                TextField(
                  controller: _postNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '게시글 제목',
                  ),
                ),
                const SizedBox(height: 16), // Add some spacing
                TextField(
                  controller: _postContentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '게시글 내용',
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // 폼이 유효할 경우, 수정된 데이터를 서버에 전송
                      final updatedPost = {
                        'postName': _postNameController.text,
                        'postContent': _postContentController.text,
                        'categoryNumber': _categoryOptions.firstWhere(
                          (option) => option['name'] == _selectedCategoryName,
                          orElse: () => _categoryOptions[0],
                        )['number'],
                      };
                      Navigator.pop(context, updatedPost);
                    }
                  },
                  child: const Text('수정 완료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
