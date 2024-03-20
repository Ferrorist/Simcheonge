import 'package:flutter/material.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBoard; // 선택된 게시판
  final List<String> _boardTypes = ['게시판 A', '게시판 B', '게시판 C']; // 게시판 종류 예시
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

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
                  value: _selectedBoard,
                  hint: const Text('게시판 선택'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBoard = newValue;
                    });
                  },
                  items:
                      _boardTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
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
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200, // 고정된 높이를 가진 컨테이너
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // 필요에 따라 패딩 추가
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue, width: 2.0), // 테두리 스타일 지정
                    borderRadius: BorderRadius.circular(8.0), // 테두리 둥글게
                  ),
                  child: const SingleChildScrollView(
                    child: TextField(
                      maxLines: null, // 무제한 줄 입력 가능
                      decoration: InputDecoration(
                        labelText: '내용', // 라벨 텍스트
                        hintText: '여기에 내용을 입력하세요', // 힌트 텍스트
                        border: InputBorder.none, // TextField 내부의 테두리 제거
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('경고'),
                                content: const Text(
                                    '글 작성 중인 내용은 저장되지 않습니다. 계속하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 팝업을 닫습니다.
                                    },
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // 실제로 취소 기능을 수행하고, 이전 화면으로 돌아갑니다.
                                      Navigator.of(context).pop(); // 팝업을 닫습니다.
                                      Navigator.of(context)
                                          .pop(); // 글 작성 화면을 닫고 이전 화면으로 돌아갑니다.
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('취소')),
                    ElevatedButton(
                      onPressed: () {
                        // 작성 완료 로직
                        if (_formKey.currentState!.validate()) {
                          // 입력 데이터 사용
                        }
                      },
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
