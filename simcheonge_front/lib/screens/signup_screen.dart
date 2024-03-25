import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  Future<void> signUp() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    final url = Uri.parse('https://j10e102.p.ssafy.io/api/user/signup');
    final requestData = jsonEncode({
      'userNickname': _nicknameController.text,
      'userLoginId': _idController.text,
      'userPassword': _passwordController.text,
      'userPasswordCheck': _passwordConfirmController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 성공했습니다.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입에 실패했습니다: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입에 실패했습니다: $e')),
      );
    }
  }

// 닉네임 중복 확인 함수
  Future<void> checkNickname() async {
    final url = Uri.parse(
        'https://j10e102.p.ssafy.io/api/user/check-nickname/${_nicknameController.text}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 중복이 없는 경우
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("사용 가능한 닉네임입니다.")));
      } else {
        // 중복인 경우 또는 그 외 에러
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 사용중인 닉네임이거나 조회에 실패했습니다.")));
      }
    } catch (e) {
      // HTTP 요청 중 예외 발생 시
      developer.log('닉네임 중복 검사 중 오류 발생', error: e.toString());
      // 또는 print 함수를 사용할 수도 있습니다.
      print('닉네임 중복 검사 중 오류 발생: ${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("닉네임 중복 검사 중 오류가 발생했습니다: $e")));
    }
  }

  // ID 중복 확인 함수
  Future<void> checkLoginId() async {
    final url = Uri.parse(
        'https://j10e102.p.ssafy.io/api/user/check-loginId/${_idController.text}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 중복이 없는 경우
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("사용 가능한 ID입니다.")));
      } else {
        // 중복인 경우 또는 그 외 에러
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 사용중인 ID이거나 조회에 실패했습니다.")));
      }
    } catch (e) {
      // HTTP 요청 중 예외 발생 시
      developer.log('ID 중복 검사 중 오류 발생', error: e.toString());
      // 또는 print 함수를 사용할 수도 있습니다.
      print('ID 중복 검사 중 오류 발생: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("ID 중복 검사 중 오류가 발생했습니다: ${e.toString()}"))); // 예외 메시지 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                      labelText: '닉네임',
                      hintText: '2~8자 한글/영문/한글+숫자/영문+숫자/한글+영문',
                    ),
                  ),
                ),
                // 중복 확인 버튼
                ElevatedButton(
                  onPressed: checkNickname,
                  child: const Text('중복 확인'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      hintText: '6~10자 영문/영문+숫자',
                    ),
                  ),
                ),
                // 중복확인 버튼
                ElevatedButton(
                  onPressed: checkLoginId,
                  child: const Text('중복 확인'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: '8~16자 영문/숫자/영문+숫자',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordConfirmController,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                hintText: '비밀번호를 다시 한번 입력하세요',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              child: const Text('가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
